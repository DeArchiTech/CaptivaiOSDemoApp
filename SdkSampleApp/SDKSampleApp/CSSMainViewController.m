//
//  Copyright (c) 2013-2016 EMC Corporation.  All rights reserved.
//

#import "AssetsLibrary/AssetsLibrary.h"
#import "QuartzCore/CAGradientLayer.h"

#import "CMSCaptureImage.h"
#import "CMSConstants.h"

#import "CSSMainViewController.h"
#import "CSSEnhancePictureViewController.h"
#import "CSSSettings.h"

#import "CSSCustomWindow.h"
#import "SDKSampleApp-Swift.h"

/**
 * CSSMainViewController interface represents the main window offering the ability to take a picture,
 * or enhance an image from either the photo album or application documents folder.
 *
 * CSSMainViewController implements the <CMSImageDelegate> protocol required for SDK takePicture API.
 */
@implementation CSSMainViewController {
    CSSCustomWindow *customWindow;
}

@synthesize actionsArray;
@synthesize activityView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    CSSLog(@"Received memory warning");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:100.0/255.0 green:150.0/255.0 blue:200.0/255.0 alpha:1.0];
    self.navigationItem.title = CSSMainTitle;
    self.actionsArray = [NSArray arrayWithObjects:CSSMenuTakePicture, CSSMenuContinuousCapture, CSSMenuEnhanceImage, CSSMenuDeleteDocFiles, nil];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainScreen@2x.png"]]];
    self.view.backgroundColor = [UIColor clearColor];
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(0.0, 0.0, 80.0, 80.0);
    [activityView.layer setBackgroundColor:[[UIColor colorWithWhite: 0.0 alpha:0.30] CGColor]];
    activityView.center = self.view.center;
    [self.view addSubview: activityView];

    [CSSSettings registerDefaults];
    
    //Call Network Manager Login

    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager loginWithCompletion:^(NSDictionary * _Nullable param1, NSError * _Nullable param2){
        NSLog(@"%@","completed");
        NSLog(@"%@", param1);
        NSLog(@"%@", param2);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // enable tableView selection, which was disabled while the image was processed
    self.tableView.allowsSelection = YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    activityView.center = self.view.center;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.actionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = [self.actionsArray objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:160.0/255.0 blue:255.0/255.0 alpha:1.0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dispatch back to main queue. Experiencing a random slow segue to next view controller.
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text compare:CSSMenuTakePicture] == NSOrderedSame) {
            [self takePicture:self continuous:NO];
        }
        else if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text compare:CSSMenuContinuousCapture] == NSOrderedSame) {
            captureCount = 0;
            [self takePicture:self continuous:YES];
        }
        else if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text compare:CSSMenuEnhanceImage] == NSOrderedSame) {
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            [self selectImage:cell.frame];
        }
        else if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text compare:CSSMenuDeleteDocFiles] == NSOrderedSame) {
            // Get user confirmation before deleting all files
            // (just to make sure the user didn't accidentally touched the wrong button)
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please confirm action" message:@"Delete all files from the Documents folder?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert addButtonWithTitle:@"Yes"];
            [alert show];
        }
    });
}

/**
 * Launches the camera window to take a picture, which is then saved by the imageDidTakePicture() delegate method
 * @param sender      The view for the control event.
 * @param continuous  Capture a set of images.
 */
- (void)takePicture:(id)sender continuous:(BOOL)continuous{
    @try {
        // disable other menu item selection while a picture is taken and returned
        self.tableView.allowsSelection = NO;
        
        // Obtain our picture parameters from the preferences.
        NSMutableString *sensors = [NSMutableString stringWithCapacity:3];
        
        if ([CSSSettings boolScalarForKey:@"SensorFocus"]) {
            [sensors appendString:@"f"];
        }
        
        BOOL motion = NO;
        if ([CSSSettings boolScalarForKey:@"SensorMotion"]) {
            [sensors appendString:@"m"];
            motion = YES;
        }
        
        if ([CSSSettings boolScalarForKey:@"SensorQuality"]) {
            [sensors appendString:@"q"];
        }
        
        // Any thresholds 1-100 will be used for measuring quality
        BOOL useQuads = NO;
        NSNumber *threshold;
        NSMutableDictionary *quality = [NSMutableDictionary dictionary];
        threshold = [CSSSettings integerForKey:@"QualityGlare"];
        if (threshold.integerValue > 0 && threshold.integerValue <= 101) {
            [quality setObject:threshold forKey:CMSMeasureGlare];
        }
        threshold = [CSSSettings integerForKey:@"QualityQuadrilateral"];
        if (threshold.integerValue > 0 && threshold.integerValue <= 100) {
            useQuads = YES;
            [quality setObject:threshold forKey:CMSMeasureQuadrilateral];
        }
        threshold = [CSSSettings integerForKey:@"QualityPerspective"];
        if (threshold.integerValue > 0 && threshold.integerValue <= 100) {
            useQuads = YES;
            [quality setObject:threshold forKey:CMSMeasurePerspective];
        }
        
        CGSize crop = CGSizeMake(0, 0);
        
        if ([CSSSettings boolScalarForKey:@"Trim"]) {
            crop = CMSTakePictureCropVisible;
        } else {
            crop = CGSizeMake([[CSSSettings floatForKey:@"AspectRatioX"] floatValue], [[CSSSettings floatForKey:@"AspectRatioY"] floatValue]);
        }
        
        NSDictionary *coreParameters = @{CMSTakePictureContext: self,
                                         CMSTakePictureSensors: sensors,
                                         CMSTakePictureMotionSensitivity: [CSSSettings floatForKey:@"SensitivityMotion"],
                                         CMSTakePictureEdgeLabel: [CSSSettings stringForKey:@"LabelEdge"],
                                         CMSTakePictureCenterLabel: [CSSSettings stringForKey:@"LabelCenter"],
                                         CMSTakePictureCaptureLabel: [CSSSettings stringForKey:@"LabelCapture"],
                                         CMSTakePictureCaptureTimeout: [CSSSettings integerForKey:@"CaptureTimeout"],
                                         CMSTakePictureCaptureDelay: [CSSSettings integerForKey:@"CaptureDelay"],
                                         CMSTakePictureOptimalConditions: [CSSSettings boolForKey:@"OptimalConditions"],
                                         CMSTakePictureGuidelines: [CSSSettings boolForKey:@"Guidelines"],
                                         CMSTakePictureCancelButton: [CSSSettings boolForKey:@"CancelButton"],
                                         CMSTakePictureTorch: [CSSSettings boolForKey:@"Torch"],
                                         CMSTakePictureTorchButton: [CSSSettings boolForKey:@"TorchButton"],
                                         CMSTakePictureImmediately: [CSSSettings boolForKey:@"Immediately"],
                                         CMSTakePictureCrop: [NSValue valueWithCGSize:crop],
                                         CMSTakePictureQualityMeasures : quality,
                                         CMSTakePictureCropOk: [CSSSettings uiColorForKey:@"CropColorOk"],
                                         CMSTakePictureCropWarning: [CSSSettings uiColorForKey:@"CropColorWarning"],
                                         CMSTakePictureCropProcessing: [CSSSettings uiColorForKey:@"CropColorProcessing"],
                                         CMSCaptureFrameDelay: [CSSSettings integerForKey:@"FrameDelay"]};
        
        // If custom UI is requested, add one more parameter
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:coreParameters];
        NSString *uiType = [CSSSettings stringForKey:@"CustomUI"];
        customWindow = nil;
        if ([uiType isEqualToString:@"Extend"]) {
            customWindow = [[CSSCustomWindow alloc] initWithMode:CSSCustomExtend motion:motion quads:useQuads];
        } else if ([uiType isEqualToString:@"Replace"]) {
            customWindow = [[CSSCustomWindow alloc] initWithMode:CSSCustomReplace motion:motion quads:useQuads];
        } else if (useQuads) {
            // If quadrilateral detection is in active, use a custom window to draw the
            // detected quadrilateral.
            customWindow = [[CSSCustomWindow alloc] initWithMode:CSSCustomNone motion:motion quads:useQuads];
        }
        
        if (customWindow) {
            [parameters setObject:customWindow forKey:CMSTakePictureCaptureWindow];
        }
            
        NSError *error = nil;
        
        // Launch the camera to take a picture.
        CSSLog(@"Camera continuous:%d parameters: %@", continuous, parameters);
        if (continuous) {
            [CMSCaptureImage continuousCapture:self parameters:parameters error:&error];
        } else {
            [CMSCaptureImage takePicture:self parameters:parameters error:&error];
        }
        
        if (error != nil)  {
            [CSSUtils showAlertOnError:error title:@"Error in CMSCaptureImage.takePicture()"];
            self.tableView.allowsSelection = YES;
        }
    }
    @catch (NSException *exception) {
        self.tableView.allowsSelection = YES;
        [CSSUtils showAlertOnException:exception title:@"Exception"];
        CSSLog(@"%@", exception);
    }
}

/* 
 * <CMSImageDelegate> method called by takePicture API.
 * See CMSImageDelegate imageDidTakePicture:(NSData *)imageData 
 */
- (void)imageDidTakePicture:(NSData *)imageData
{
    if (imageData == nil) {
        self.tableView.allowsSelection = YES;
        [CSSUtils showAlertWithMessage:@"Unable to retrieve image" title:@"Error"];
        return;
    } else {
        self.tableView.allowsSelection = NO;
        NSError* error;
        // CSSImageHelper is a wrapper around SDK methods to load and save images.
        // In this case we need to load the image from its encoded bytes
        CSSImageHelper *imageHelper = [[CSSImageHelper alloc] init];
        
        // load the image into the SDK
        [imageHelper loadFromBytes:imageData error:&error];
        
        // save the image on disk
        if (error == nil) {
            [imageHelper savePicture:imageData error:&error];
        }
        if (error == nil) {
            // present the image for enhancements
            [self enhanceLoadedImage:imageHelper];
        }
        if (error != nil)  {
            self.tableView.allowsSelection = YES;
            [CSSUtils showAlertOnError:error title:@"Error"];
        }
    }
}

/*
 *  <CMSImageDelegate> method called by takePicture API.
 * See CMSImageDelegate imageDidCancelTakePicture:(int)reason
 */
- (void)imageDidCancelTakePicture:(int)reason
{
    // This callback is called if the take picture operation is canceled.
    if (reason == CMSCancelReasonTimeout) {
        [CSSUtils showAlertWithMessage:@"The optimal conditions were not met and the picture was canceled." title:@"Attention"];
    } else if (reason == CMSCancelReasonPermission) {
        [CSSUtils showAlertWithMessage:@"The application does not have sufficient permissions to take a picture." title:@"Attention"];
    }
}

/*
 * Generates a popup menu for image selection (photo albums or documents folder)
 */
- (void)selectImage:(CGRect)frame {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        UIActionSheet *filterActionSheet = [[UIActionSheet alloc] initWithTitle:CSSSelectImageTitle delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
            otherButtonTitles:CSSSelectImageFromPhotos, CSSSelectImageFromPhotoAlbums, CSSSelectImageFromDocuments, nil];
        filterActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [filterActionSheet showInView:self.view];
    } else {
        [self presentImageLocationMenuForIPad:frame];
    }
}

/*
 * Presents iPad-specific popover menu with locations for image selection.
 */
- (void)presentImageLocationMenuForIPad:(CGRect)frame
{
    if (_actionPicker == nil) {
        // Create the ActionPickerViewController.
        _actionPicker = [[ActionPickerViewController alloc] initWithStyle:UITableViewStylePlain];
        [_actionPicker setData:CSSActionPickerImageLocationType];
        
        // Set this VC as the delegate.
        _actionPicker.delegate = self;
    }
    
    if (_actionPickerPopover == nil) {
        // The filter picker popover is not showing. Show it.
        _actionPickerPopover = [[UIPopoverController alloc] initWithContentViewController:_actionPicker];
        _actionPickerPopover.delegate = self;
        [_actionPickerPopover presentPopoverFromRect:frame inView:self.view
                                     permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        // The filter picker popover is showing. Hide it.
        [_actionPickerPopover dismissPopoverAnimated:YES];
        _actionPickerPopover.delegate = nil;
        _actionPickerPopover = nil;
    }
}

/*
 * ActionPickerDelegate method - invoked on iPad
 */
- (void)selectedAction:(NSString *)actionName
{
    //Dismiss the popover if it's showing.
    [self dismissPopover];
    [self applySelectedAction:actionName];
}

- (void)dismissPopover
{
    if (_actionPickerPopover) {
        [_actionPickerPopover dismissPopoverAnimated:YES];
        _actionPickerPopover = nil;
    }
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self dismissPopover];
}

/*
 * UIActionSheet delegate method - invoked on iPhone
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *actionName = [actionSheet buttonTitleAtIndex:buttonIndex];
    [self applySelectedAction:actionName];
}

/*
 * Presents list of images either from the photo albums or from the documents folder
 */
- (void)applySelectedAction:(NSString *)actionName
{
    if ([actionName compare:CSSSelectImageFromPhotos] == NSOrderedSame ||
        [actionName compare:CSSSelectImageFromPhotoAlbums] == NSOrderedSame)
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerController.sourceType = ([actionName compare:CSSSelectImageFromPhotoAlbums] == NSOrderedSame) ? UIImagePickerControllerSourceTypeSavedPhotosAlbum : UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        self.imagePickerController = imagePickerController;
       
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            _imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
            [_imagePickerPopover presentPopoverFromRect:CGRectMake(10, 10, 100, 100) inView:self.view
                                permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
        } else {
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }
        
    }
    else if ([actionName compare:CSSSelectImageFromDocuments] == NSOrderedSame) {
        // Prepare the file list for presentation. Yhis process may take some time
        // and therefore it's done on a separate thread
        // while the main thread shows Activity Indicator
        self.tableView.allowsSelection = NO;
        CSSSelectDocImageViewController *selectDocVC = [[CSSSelectDocImageViewController alloc] init];
        activityView.center = self.view.center;
        [activityView startAnimating];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
        dispatch_async(queue, ^{
            // Generate thumbnails for image files to show them in the file list
            [selectDocVC populateFileList];
            dispatch_async(dispatch_get_main_queue(), ^{
                selectDocVC.imagePickedDelegate = self;
                selectDocVC.navigationItem.title = CSSSelectImageTitle;
                UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:selectDocVC];
                navC.navigationBar.barTintColor = [CSSUtils getNavigationBarColor];
                [activityView stopAnimating];
                
                [self presentViewController:navC animated:YES completion:nil];
                self.tableView.allowsSelection = YES;
            });
        });
    }
}

- (void)dismissImagePickerPopover
{
    if (_imagePickerPopover != nil) {
        // The filter picker popover is showing. Hide it.
        [_imagePickerPopover dismissPopoverAnimated:YES];
        _imagePickerPopover = nil;
    }
}

/*
 * This method is called when an image has been selected from the photo album using the UIImagePickerController
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissImagePickerPopover];
    
    // the UIImagePickerController is dismissed differently on iPhone and iPad devices
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.imagePickerController = nil;
        [self selectedJPEGImage:image];
    } else {
        [picker dismissViewControllerAnimated:YES completion:^{
            [self selectedJPEGImage:image];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissImagePickerPopover];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.imagePickerController = nil;
}

/*
 * ImagePickerDelegate method. Called from CSSSelectDocImageViewController when an image has been selected.
 * in our sample application these images are saved in the Documents folder.
 */
- (void)selectedImagePath:(NSString *)imagePath
{
    NSError *error;
    // CSSImageHelper is a wrapper around SDK methods to load and save images.
    // In this case we need to load the image from an existing file.
    // In case a user modifies the image and wants to save the updates, a new
    // file will be created. See CSSImageHelper methods for more info.
    CSSImageHelper *imageHelper = [[CSSImageHelper alloc] init];
    
    // load the image into the SDK
    [imageHelper loadFromFile:imagePath error:&error];
    if (error == nil) {
        // present the image for enhancements
        [self enhanceLoadedImage:imageHelper];
    } else {
        [CSSUtils showAlertOnError:error title:@"Error"];
    }
}

/*
 * selectedJPEGImage is called when a user selected an image out of the photo album.
 */
- (void)selectedJPEGImage:(UIImage *)image
{
    NSError *error;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    // CSSImageHelper is a wrapper around SDK methods to load and save images.
    // In this case we need to load the image from the byte array of an image
    // from the photo album.
    // If a user modifies the image and then wants to undo changes, then the images
    // will be reloaded from this byte array.
    // If a user modifies the image and wants to save the updates, a new
    // file will be created in the Documents folder. See CSSImageHelper methods for more info.
    CSSImageHelper *imageHelper = [[CSSImageHelper alloc] init];
    
    // load the image into the SDK
    [imageHelper loadFromBytes:imageData error:&error];
    
    if (error == nil) {
        // present the image for enhancements
        [self enhanceLoadedImage:imageHelper];
    } else {
        [CSSUtils showAlertOnError:error title:@"Error"];
    }
}

/*
 * enhanceLoadedImage presents the loaded image for enhancements
 */
- (void)enhanceLoadedImage:(CSSImageHelper *)imageHandler
{
    // Use SDK method imageForDisplayWithWidth to get the scaled down version of the loaded image
    UIImage *image = [CMSCaptureImage imageForDisplayWithWidth:0 height:0 rect:CGRectMake(0, 0, 0, 0)];
    
    // Present the image for enhancements
    CSSEnhancePictureViewController *enhancePictureVC = [[CSSEnhancePictureViewController alloc] init];
    enhancePictureVC.hidesBottomBarWhenPushed = NO;
    enhancePictureVC.imageLoader = imageHandler;  
    [enhancePictureVC setImage:image];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:enhancePictureVC];
    navC.navigationBar.barTintColor = [CSSUtils getNavigationBarColor];
    [self presentViewController:navC animated:YES completion:nil];
}

/*
 * UIAlertViewDelegate method used to get confirmation for file deletion
 */
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // Delete all files from the application Documents folder.
        // This may take few seconds, therefore show UIActivityIndicatorView
        [activityView startAnimating];
        dispatch_queue_t deleteFilesQueue = dispatch_queue_create("deleteFiles", NULL);
        dispatch_async(deleteFilesQueue, ^{
            [CSSUtils deleteAllFilesFromDocFolder];
            // UI changes should be done only on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [activityView stopAnimating];
                [CSSUtils showAlertWithMessage:@"Deleted files from the Documents folder." title:@"Finished operation."];
            });
        });

    }
}

/*
 * <CMSContinuousDelegate> method called by continuousCapture API.
 * See CMSContinuousDelegate newImage:imageData similarity:
 */
- (CMSContinuousCaptureOperation)newImage:(NSData *)imageData data:(NSDictionary *)data {
    NSInteger similarity = [[data objectForKey:CMSCaptureSimilarity] integerValue];
    NSInteger captureSimilarity = [[CSSSettings integerForKey:@"CaptureSimilarity"] integerValue];

    CSSLog(@"captureSimilarity %d - similarity %d.", (int)captureSimilarity, (int)similarity);
    
    self.tableView.allowsSelection = YES;
    
    if (imageData == nil) {
        [CSSUtils showAlertWithMessage:@"Unable to retrieve image." title:@"Error"];
        return CMSContinuousCaptureStop;
    }
    
    if (captureSimilarity >= similarity) {
        NSError* error;
        
        // CSSImageHelper is a wrapper around SDK methods to load and save images.
        // In this case we need to load the image from its encoded bytes
        CSSImageHelper *imageHelper = [[CSSImageHelper alloc] init];
        
        // Load the image into the SDK.
        [imageHelper loadFromBytes:imageData error:&error];
        if (error != nil) {
            [CSSUtils showAlertOnError:error title:@"Error"];
            return CMSContinuousCaptureStop;
        }

        // Run autocrop
        NSDictionary *imageProps = [CMSCaptureImage imageProperties];
        NSInteger shortSideFullSize = MIN([[imageProps objectForKey:CMSImagePropertyWidth] integerValue], [[imageProps objectForKey:CMSImagePropertyHeight] integerValue]);
        [CMSCaptureImage applyFilters:@[CMSFilterCrop] parameters:nil];
        imageProps = [CMSCaptureImage imageProperties];
        
        // Only keep the cropped image if it is at least 10% the size of the short side of the full image to prevent over-cropping
        if (([[imageProps objectForKey:CMSImagePropertyWidth] integerValue] > shortSideFullSize / 10) && ([[imageProps objectForKey:CMSImagePropertyHeight] integerValue] > shortSideFullSize / 10)) {
            // Save cropped image
            imageData = [CMSCaptureImage encodeForFormat:CMSSaveJpg parameters:nil error:&error];
            if (error != nil) {
                [CSSUtils showAlertOnError:error title:@"Error"];
                return CMSContinuousCaptureStop;
            }
        }

        [self flash]; // flash on save
        [imageHelper savePicture:imageData error:&error];
        if (error != nil) {
            [CSSUtils showAlertOnError:error title:@"Error"];
            return CMSContinuousCaptureStop;
        }
         
        CSSLog(@"Saved image #%d", captureCount);
        NSInteger captureTotal = [[CSSSettings integerForKey:@"CaptureCount"] integerValue];
        if (++captureCount >= captureTotal) {
            CSSLog(@"Done with continuous capture [%d/%zd].", captureCount, captureTotal);
            return CMSContinuousCaptureStop;
        }
    } else {
        CSSLog(@"Similarity failed.");
        return CMSContinuousCaptureContinueWithPrevious;
    }
    
    return CMSContinuousCaptureContinue;
}

- (void)flash {
    if (customWindow) {
        [customWindow flash];
    }
}

- (void)didCancel:(int)reason {
    [self imageDidCancelTakePicture:reason];
}

@end
