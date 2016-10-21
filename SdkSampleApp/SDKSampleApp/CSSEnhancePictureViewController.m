//
//  Copyright (c) 2013-2016 EMC Corporation.  All rights reserved.
//

#import "AssetsLibrary/AssetsLibrary.h"
#import "QuartzCore/CAGradientLayer.h"

#import "CMSCaptureImage.h"
#import "CMSConstants.h"
#import "CSSEnhancePictureViewController.h"
#import "CSSSettings.h"
#import "SDKSampleApp-Swift.h"

/*
 * interface CropImageView hosts a resizable rectangle showing the crop selection
 */
@interface CropImageView : UIView
{
    int touchSize;
    BOOL isResizingTop;
    BOOL isResizingBottom;
    UIImageView *selection;
    UIImageView *topHandle;
    UIImageView *bottomHandle;

}

- (void)setSubviewFrames;
@end

@implementation CropImageView

/*
 * On initialization generate corner images used to show "resizing handles" on the crop rectangle
 */
- (id)initWithFrame:(CGRect)frame
{
    touchSize = 50;
    isResizingTop = NO;
    isResizingBottom = NO;
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self setMultipleTouchEnabled:NO];

        // generated crop rectangle of the translucent green color
        selection = [[UIImageView alloc] init];
        selection.alpha = 0.4;
        selection.backgroundColor = [UIColor greenColor];
        [self addSubview:selection];
        
        // generate blue corner indicating "resizing handle" which currently is not being moved
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,100), NO, 0);
        [[UIColor blueColor] set];
        UIBezierPath* blueLeftCorner = [UIBezierPath bezierPath];
        [blueLeftCorner setLineWidth:30.0];
        [blueLeftCorner moveToPoint:CGPointMake(0.0, 0.0)];
        [blueLeftCorner addLineToPoint:CGPointMake(100.0, 0.0)];
        [blueLeftCorner moveToPoint:CGPointMake(0.0, 0.0)];
        [blueLeftCorner addLineToPoint:CGPointMake(0.0, 100.0)];
        [blueLeftCorner stroke];
        [blueLeftCorner fill];
        UIImage* blueImageTop = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImage* blueImageBottom = [[UIImage alloc] initWithCGImage:blueImageTop.CGImage scale:1.0 orientation:UIImageOrientationDown];
        // assign this image to top and bottom "handles"
        topHandle = [[UIImageView alloc] initWithImage:blueImageTop];
        bottomHandle = [[UIImageView alloc] initWithImage:blueImageBottom];
        
        // generate purple corner indicating "resizing handle" which currently is being moved
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,100), NO, 0);
        [[UIColor purpleColor] set];
        UIBezierPath* purpleLeftCorner = [UIBezierPath bezierPath];
        [purpleLeftCorner setLineWidth:30.0];
        [purpleLeftCorner moveToPoint:CGPointMake(0.0, 0.0)];
        [purpleLeftCorner addLineToPoint:CGPointMake(100.0, 0.0)];
        [purpleLeftCorner moveToPoint:CGPointMake(0.0, 0.0)];
        [purpleLeftCorner addLineToPoint:CGPointMake(0.0, 100.0)];
        [purpleLeftCorner stroke];
        [purpleLeftCorner fill];
        UIImage* purpleImageTop = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImage* purpleImageBottom = [[UIImage alloc] initWithCGImage:purpleImageTop.CGImage scale:1.0 orientation:UIImageOrientationDown];
        UIGraphicsEndImageContext();
        // assign this image to top and bottom "handles"
        topHandle.highlightedImage = purpleImageTop;
        bottomHandle.highlightedImage = purpleImageBottom;
        
        [self addSubview:topHandle];
        [self addSubview:bottomHandle];

    }
    return self;
}

- (void)setSubviewFrames
{
    // Position the selection rectangle very close to the borders of the self.frame
    // Position the selection handles (corners named topHandle and bottomHandle)
    // in the top left and bottom right corners of the self.frame,
    // so that it appears that handles are drawn from the corners of the selection frame
    
    CGFloat selW = self.frame.size.width;
    CGFloat selH = self.frame.size.height;
    selection.frame = CGRectMake(0, 0, selW, selH);
    topHandle.frame = CGRectMake(0, 0, touchSize, touchSize);
    bottomHandle.frame = CGRectMake(selW-touchSize, selH-touchSize, touchSize, touchSize);
}

// recognize which corner is moved
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchStart = [touch locationInView:self];
    isResizingTop = (touchStart.x < 60 && touchStart.y < 60);
    isResizingBottom = (self.bounds.size.width-touchStart.x < 60 && self.bounds.size.height-touchStart.y < 60);
    
    // change the color of the moving corner by switching the highlighted property
    if (isResizingTop)
        topHandle.highlighted = YES;
    else
        topHandle.highlighted = NO;
    if (isResizingBottom)
        bottomHandle.highlighted = YES;
    else
        bottomHandle.highlighted = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // turn handle colors back to blue
    topHandle.highlighted = NO;
    bottomHandle.highlighted = NO;
}

// resize the crop rectangle
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint previousPoint = [touch previousLocationInView:self];
    
    float deltaWidth = touchPoint.x - previousPoint.x;
    float deltaHeight = touchPoint.y - previousPoint.y;
   
    // restrict the crop rectangle to the image borders and min width and height
    CGFloat ulx=0, uly=0, newWidth=0, newHeight=0;
    if (isResizingTop) {
        ulx = self.frame.origin.x + deltaWidth;
        if (ulx < 0) {
            deltaWidth = self.frame.origin.x;
            ulx = 0;
        }
        else if (ulx > self.superview.frame.size.width) {
            deltaWidth = self.superview.frame.size.width - ulx;
            ulx = self.superview.frame.size.width;
        }
        uly = self.frame.origin.y + deltaHeight;
        if (uly < 0) {
            deltaHeight = self.frame.origin.y;
            uly = 0;
        }
        if (uly > self.superview.frame.size.height) {
            deltaHeight = self.superview.frame.size.height - uly;
            uly = self.superview.frame.size.height;
        }
        newWidth = self.frame.size.width - deltaWidth;
        if (newWidth < CSSCropMinWidth) {
            ulx -= CSSCropMinWidth - newWidth;
            newWidth = CSSCropMinWidth;
        }
        newHeight = self.frame.size.height - deltaHeight;
        if (newHeight < CSSCropMinHeight) {
            uly -= CSSCropMinHeight - newHeight;
            newHeight = CSSCropMinHeight;
        }
    }
    if (isResizingBottom) {
        ulx = self.frame.origin.x;
        uly = self.frame.origin.y;
        newWidth = touchPoint.x + deltaWidth;
        if (newWidth < CSSCropMinWidth) {
            newWidth = CSSCropMinWidth;
        }
        newHeight = touchPoint.y + deltaHeight;
        if (newHeight < CSSCropMinHeight) {
            newHeight = CSSCropMinHeight;
        }
    }
    if (isResizingTop || isResizingBottom) {
        newWidth = MIN(newWidth, self.superview.frame.size.width-ulx);
        newHeight = MIN(newHeight, self.superview.frame.size.height-uly);
        // change the frame of the view hosting the crop rectangle and corner handles
        self.frame = CGRectMake(ulx, uly, newWidth, newHeight);
        // change the frame of the crop rectangles and locations of the corner handles
        [self setSubviewFrames];
    }
}

@end

/*
 * interface CSSCropViewController presents the image for cropping.
 */
@interface CSSCropViewController : UIViewController
{
    /*
     * baseView covers the complete view of the UIViewController. It's a superview of wipCropImageView.
     */
    UIView *baseView;
    
    /*
     * wipCropImageView hosts the image being cropped. 
     * This view frame has the same propotions as the image and is centered within the baseView.
     * It's a superview of croppingRect.
     */
    UIImageView *wipCropImageView;
    
    /*
     * croppingRect is the view hosting the translucent resizable crop rectangle and corner handles.
     * This view is set on top of the wipCropImageView and its bounds are always within the bounds of
     * wipCropImageView.
     */
    CropImageView *croppingRect;
    
    /*
     * fileImageWidth is the cached value of the image width obtained using the SDK method imageProperties;
     * This value is used to calculate the aspect ratio of the image. 
     */
    int fileImageWidth;
    
    /*
     * fileImageHeight is the cached value of the image height obtained using the SDK method imageProperties;
     * This value is used to calculate the aspect ratio of the image.
     */
    int fileImageHeight;
    
    /*
     * fileCropFrame is the cached frame of the crop rectangle in the file image coordinates.
     * This value is used to calculate crop rectangle frame during device rotation and to 
     * apply the crop to the image file.
     */
    CGRect fileCropFrame;
}

@property (nonatomic, weak) id<ImageUpdateDelegate> delegate;

@end

@implementation CSSCropViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    CSSLog(@"Received memory warning");
}

- (void)returnFromController
{
    [[self parentViewController] dismissViewControllerAnimated:YES completion:^{
       if (_delegate != nil)
           [_delegate resetScale];
        _delegate = nil;
    }
];
}

/*
 * Apply crop to the image
 */
- (void)applyButtonPressed
{
    // calculate crop coordinates for the image file
    [self setFileCropFromView];
    // Use SDK to apply the crop to the loaded image
    NSValue* val = [NSValue valueWithCGRect:fileCropFrame];
    [CMSCaptureImage applyFilters:@[CMSFilterCrop] parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               val, CMSFilterParamCropRectangle,
                                                               nil]];
    //Notify the delegate if it exists.
    if (_delegate != nil) {
        [_delegate updateImageFromSDK];
    }
    // return from controller without restoring the cached zoom scale
    [[self parentViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void) setImage : (UIImage*) image {
    wipCropImageView = [[UIImageView alloc] initWithImage:image];
}

- (CGRect)getCenteredImageFrame
{
    CGRect newFrame = [CSSUtils getRectForLoadedImageWithOffset:YES];
    CGFloat offsetX = (baseView.bounds.size.width > newFrame.size.width) ?
                        (baseView.bounds.size.width - newFrame.size.width) * 0.5 : 0.0;
    CGFloat offsetY = (baseView.bounds.size.height > newFrame.size.height) ?
                        (baseView.bounds.size.height - newFrame.size.height) * 0.25 : 0.0;
    offsetY += self.navigationController.navigationBar.frame.size.height; // show the image below the navigation bar
    CGRect centeredFrame = CGRectMake(offsetX, offsetY, newFrame.size.width, newFrame.size.height);
    return centeredFrame;
}

/*
 * Calculate crop coordinates for the image file, using the view frame and image aspect ratio
 */
- (void)setFileCropFromView
{
    CGFloat ulCornerX = croppingRect.frame.origin.x;
    CGFloat ulCornerY = croppingRect.frame.origin.y;
    CGFloat width = croppingRect.frame.size.width;
    CGFloat height = croppingRect.frame.size.height;
    
    CGFloat viewW = wipCropImageView.frame.size.width;
    CGFloat viewH = wipCropImageView.frame.size.height;
    
    CGFloat wRat = fileImageWidth / viewW;
    CGFloat hRat = fileImageHeight / viewH;
    
    ulCornerX = ulCornerX * wRat;
    ulCornerY = ulCornerY * hRat;
    width = width * wRat;
    height = height * hRat;
    
    fileCropFrame = CGRectMake(ulCornerX, ulCornerY, width, height);
}

// Calculate crop coordinates for the image view, using the file crop and file aspect ratio
- (CGRect)getViewCropFromFile
{
    CGFloat viewW = wipCropImageView.frame.size.width;
    CGFloat viewH = wipCropImageView.frame.size.height;
    
    CGFloat wRat = viewW / fileImageWidth;
    CGFloat hRat = viewH / fileImageHeight;
    
    CGFloat ulCornerX = fileCropFrame.origin.x * wRat;
    CGFloat ulCornerY = fileCropFrame.origin.y * hRat;
    CGFloat width = fileCropFrame.size.width * wRat;
    CGFloat height = fileCropFrame.size.height * hRat;
    
    return CGRectMake(ulCornerX, ulCornerY, width, height);
}

- (void)loadView
{
    [super loadView];
    NSDictionary* imageProps = [CMSCaptureImage imageProperties];
    fileImageWidth = [[imageProps objectForKey:CMSImagePropertyWidth] intValue];
    fileImageHeight = [[imageProps objectForKey:CMSImagePropertyHeight] intValue];
    baseView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    baseView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    baseView.backgroundColor = [UIColor clearColor];
    self.view = baseView;
}

- (void)drawGoBackButton
{
    self.navigationItem.leftBarButtonItem = [CSSUtils getBarButtonItemForTarget:self
                                                                      imageName:@"ic_prev.png"
                                                                         action:@selector(returnFromController)
                                                                         height:self.navigationController.navigationBar.frame.size.height];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Crop Image";
    [self drawGoBackButton];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *applyButton = [[UIBarButtonItem alloc]
                         initWithTitle:@"Apply"
                         style:UIBarButtonItemStyleBordered
                         target:self
                         action:@selector(applyButtonPressed)];
    
    [self setToolbarItems:[NSArray arrayWithObjects:flexSpace, applyButton, flexSpace, nil]];
    self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.toolbar.alpha = 0.5;
    [self.navigationController setToolbarHidden:NO];

    wipCropImageView.frame = [self getCenteredImageFrame];
    [wipCropImageView setUserInteractionEnabled:YES];
    
    fileCropFrame = [CMSCaptureImage autoCropRectWithThreshold:0 padding:0];
    croppingRect = [[CropImageView alloc] initWithFrame:[self getViewCropFromFile]];
    croppingRect.alpha = 0.3;
    [croppingRect setSubviewFrames];
    
    [wipCropImageView addSubview:croppingRect];
    [baseView addSubview:wipCropImageView];
}

// The view size of the UIViewController is updated after viewDidLoad;
// Image position should be recalculated in viewWillAppear.
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self positionWipCropImageView];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    // cache current crop spec by translating it into coordinates within the image file
    [self setFileCropFromView];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self drawGoBackButton];
    // recalculate image and crop rectangle positions after device rotation
    [self positionWipCropImageView];
}

- (void)positionWipCropImageView
{
    CGRect centeredFrame = [self getCenteredImageFrame];
    wipCropImageView.frame = centeredFrame;
    croppingRect.frame = [self getViewCropFromFile];
    [croppingRect setSubviewFrames];
    [wipCropImageView setNeedsDisplay];
}

@end

/*
 * CSSEnhancePictureViewController provides the ability to enhance the image.
 * The main view is UIScrollView *imageScrollView, which allows tapping. 
 * When the zoom is 1, the imageScrollView frame is sized to be centered within 
 * the bounds of the screen and preserving the aspect ration of the loaded image.
 */
@implementation CSSEnhancePictureViewController

@synthesize imageLoader;
@synthesize activityView;
@synthesize backButtonWithSave;
@synthesize backButtonNoSave;
@synthesize toolBarButtons;
@synthesize lastFilterError;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    CSSLog(@"Received memory warning");
}

- (void)setImage:(UIImage*) image
{
    wipImageView = [[UIImageView alloc] initWithImage:image];
    wipImageView.frame = [CSSUtils getRectForLoadedImage];
}

- (void)setAppearance
{
    self.navigationItem.title = @"Enhance Image";

    backButtonNoSave = [CSSUtils getBarButtonItemForTarget:self
                                                imageName:@"ic_prev.png"
                                                action:@selector(returnFromController)
                                                height:self.navigationController.navigationBar.frame.size.height];
    
    
    backButtonWithSave = [CSSUtils getBarButtonItemForTarget:self
                                                imageName:@"ic_prevsave.png"
                                                action:@selector(saveAndReturnFromController)
                                                height:self.navigationController.navigationBar.frame.size.height];
    
    if (showUndoAndSaveButtons) {
        self.navigationItem.leftBarButtonItem = backButtonWithSave;
        [self setToolbarItems:toolBarButtons];
    } else {
        self.navigationItem.leftBarButtonItem = backButtonNoSave;
        [self setToolbarItems:nil];
    }
    
    listFiltersButton = [CSSUtils getBarButtonItemForTarget:self
                                                imageName:@"menu.png"
                                                action:@selector(listFiltersButtonPressed)
                                                height:self.navigationController.navigationBar.frame.size.height];

    self.navigationItem.rightBarButtonItem = listFiltersButton;
    [self setButtonsEnabled];
    if (_imageInfoPopover) {
        [_imageInfoPopover dismissPopoverAnimated:NO];
        [_imageInfoPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *)listFiltersButton
                                    permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];
    }
    else if (_filterPickerPopover) {
        [_filterPickerPopover dismissPopoverAnimated:NO];
        [_filterPickerPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *)listFiltersButton
                                     permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];

    }
}

// "Undo All" button is shown together with the "Save and Go Back".
// When "Undo All" button is not shown, the icon for the "Go Back" button is also changed.
- (void)showUndoButton:(BOOL)showUndo
{
    showUndoAndSaveButtons = showUndo;
    [self setAppearance];
}

- (void)dismissPopovers
{
    if (_imageInfoPopover) {
        [_imageInfoPopover dismissPopoverAnimated:YES];
        _imageInfoPopover.delegate = nil;
        _imageInfoPopover = nil;
    }
    if (_filterPickerPopover) {
        [_filterPickerPopover dismissPopoverAnimated:YES];
        _filterPickerPopover.delegate = nil;
        _filterPickerPopover = nil;
    }
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self dismissPopovers];
}

/*
 * ImageUpdateDelegate method is called by the CSSCropViewController when a user presses the "Apply" button
 */
- (void)updateImageFromSDK
{
    // use our utility method to get a scaled frame of the loaded image. The utility uses SDK API to obtain data.
    CGRect rect = [CSSUtils getRectForLoadedImage];
    
    // Use SDK method imageForDisplayWithWidth to get the scaled down version of the loaded image
    // request the data for a larger frame in order to have better zoom images
    UIImage *image = [CMSCaptureImage imageForDisplayWithWidth:0 height:0 rect:CGRectMake(0, 0, 0, 0)];
    
    [wipImageView setImage:image];
    
    // center the updated image
    [self positionWipImageViewForFrame:rect];
    [self showUndoButton:YES];
}

- (void)cacheZoomScaleAndSetTo1
{
    cachedContentOffset = imageScrollView.contentOffset;
    cachedZoomScale = imageScrollView.zoomScale;
    [imageScrollView setZoomScale:1.0];
}

-(void)resetScale
{
    // reset the zoom
    [imageScrollView setZoomScale:cachedZoomScale];
    [imageScrollView setContentOffset:cachedContentOffset];
    [imageScrollView setNeedsDisplay];
}

- (void)saveAndReturnFromController
{
    NSError *error;
    // our utility generates a new file name and saves the image using the SDK method
    [imageLoader saveLoaded:&error];
    if (error != nil) {
        [CSSUtils showAlertOnError:error title:@"Error in imageSaveLoaded"];
    }
    [self returnFromController];
}

- (void)returnFromController
{
    [self dismissPopovers];
    if (_filterPicker != nil) {
        _filterPicker.delegate = nil;
        _filterPicker = nil;
    }
    if (_imageInfoController != nil) {
        _imageInfoController.delegate = nil;
        _imageInfoController = nil;
    }
    if (imageScrollView != nil) {
        imageScrollView.delegate = nil;
        imageScrollView = nil;
    }
    [[self parentViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)restoreUndoImage
{
    // use our utility method to get a scaled frame of the loaded image. The utility uses SDK API to obtain data.
    CGRect rect = [CSSUtils getRectForLoadedImage];
    
    // Use SDK method imageForDisplayWithWidth to get the scaled down version of the loaded image
    // request the data for a larger frame in order to have better zoom images
    UIImage *image = [CMSCaptureImage imageForDisplayWithWidth:0 height:0 rect:CGRectMake(0, 0, 0, 0)];
    [wipImageView setImage:image];
    [self positionWipImageViewForFrame:rect];
    [self resetScale];
}

- (void)undoFiltersButtonPressed
{
    [self cacheZoomScaleAndSetTo1];
    [self dismissPopovers];
    [self showUndoButton:NO];
    NSError *error;
    
    // our utility uses SDK method to reload the image from either file or byte array
    [imageLoader reload:&error];
    if (error != nil) {
        [CSSUtils showAlertOnError:error title:@"Error in imageReload"];
    }
    
    [self restoreUndoImage];
}

- (void)undoFilterButtonPressed
{
    [self cacheZoomScaleAndSetTo1];
    [self dismissPopovers];
    
    // Undo a single change
    NSError *error = nil;
    BOOL result = [CMSCaptureImage undoImageChanges:&error];
    
    if (!result) {
        NSString *message;
        NSInteger code = error.code;
        
        if (code == CMSErrorUndoDisabled) {
            message = @"Last change undo disabled";
        } else if (code == CMSErrorUndoMissing) {
            message = @"Nothing to undo";
        } else {
            message = @"Undo failed";
        }
        
        [CSSUtils showAlertWithMessage:message title:@"Error on undo"];
    }

    [self restoreUndoImage];
}
 
- (void)listFiltersButtonPressed
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self presentFilterMenuForIPhone];
    } else {
        [self presentFilterMenuForIPad];
    }
}

- (void)presentFilterMenuForIPad
{
    BOOL dismissAndReturn = (_filterPickerPopover != nil || _imageInfoPopover != nil);
    [self dismissPopovers];
    if (dismissAndReturn)
        return;
    
    if (_filterPicker == nil) {
        // Create the ActionPickerViewController.
        _filterPicker = [[ActionPickerViewController alloc] initWithStyle:UITableViewStylePlain];
        [_filterPicker setData:CSSActionPickerFilterType];
        
        // Set this VC as the delegate.
        _filterPicker.delegate = self;
    }
    
    if (_filterPickerPopover == nil) {
        // The filter picker popover is not showing. Show it.
        _filterPickerPopover = [[UIPopoverController alloc] initWithContentViewController:_filterPicker];
        _filterPickerPopover.delegate = self;
        [_filterPickerPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *)listFiltersButton
                                     permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (void)presentFilterMenuForIPhone
{
    UIActionSheet *filterActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Filter" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                                          otherButtonTitles:
                                        
                                                            CSSUploadImage,
                                        
                                                            CSSTakeAnotherImage,
                                        
                                                            CSSEnhanceItemAutoCrop,
                                                                            CSSEnhanceItemBlackAndWhite,
                                                                            CSSEnhanceItemLighter,
                                                                            CSSEnhanceItemDarker,
                                                                            CSSEnhanceItemIncreaseContrast,
                                                                            CSSEnhanceItemDecreaseContrast,
                                                                            CSSEnhanceItemCrop,
                                                                            CSSEnhanceItemDeskew,
                                                                            CSSEnhanceItemGray,
                                                                            CSSEnhanceItemResize,
                                                                            CSSEnhanceItemRotate180,
                                                                            CSSEnhanceItemRotateLeft,
                                                                            CSSEnhanceItemRotateRight,
                                                                            CSSEnhanceItemRemoveNoise,
                                                                            CSSEnhanceItemQuadCrop,
                                                                            CSSEnhanceItemBarcode,
                                                                            CSSEnhanceItemExport,
                                                                            CSSEnhanceItemGetInfo,

                                                               nil];
    filterActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [filterActionSheet showFromBarButtonItem:listFiltersButton animated:YES];
}

/*
 * UIActionSheet delegate method
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *actionName = [actionSheet buttonTitleAtIndex:buttonIndex];
    // if Cancel button was pressed - do nothing
    if ([actionName compare: @"cancel" options:NSCaseInsensitiveSearch] != NSOrderedSame)
    {
        [self applyAction:actionName];
    }
}

/*
 * ActionPickerDelegate method
 */
- (void)selectedAction:(NSString *)actionName
{
    [self dismissPopovers];
    [self applyAction:actionName];
}

/*
 * Callback for UIImageWriteToSavedPhotosAlbum.
 */
- (void)image:(UIImage *)image error:(NSError *)error context:(void *)context
{
    [CSSUtils showAlertOnError:error title:@"Error"];
}

/*
 * Callback for showQuadrilateralCrop
 */
- (void)cropCompleted:(int)reason
{
    if (reason == CMSCropReasonError) {
        [CSSUtils showAlertWithMessage:@"Quadrilateral crop failed." title:@"Error"];
    } else if (reason == CMSCropReasonCropped) {
        [self updateImageFromSDK];
    }
}

/*
 * Calls SDK API's to apply selected filter to a loaded image or execute other menu item actions
 */
- (void)applyAction:(NSString *)actionName
{
    if ([actionName compare:CSSEnhanceItemGetInfo] == NSOrderedSame) {
        // show image info
        [self presentImageInfo];
        return;
    }
    
    if ([actionName compare:CSSEnhanceItemBarcode] == NSOrderedSame) {
        int barcodeMax = [CSSSettings integerForKey:@"BarcodeMax"].intValue;
        NSArray *barcodeTypes = self.barcodeTypes;
        NSArray *barcodes = [CMSCaptureImage detectBarcodes:barcodeTypes barcodeMax:barcodeMax];
        NSMutableString *message = [NSMutableString stringWithFormat:@"Detected %zd barcode(s).\n\n", barcodes.count];
        
        for (NSUInteger i = 0; i < barcodes.count; i++) {
            NSDictionary *barcode = barcodes[i];
            [message appendFormat:@"#%zd %@ [%@, %@, %@]\n\n",
                i + 1,
                [barcode objectForKey:CMSBarcodeText],
                [barcode objectForKey:CMSBarcodeType],
                [barcode objectForKey:CMSBarcodeConfidence],
                [barcode objectForKey:CMSBarcodePosition]
            ];
        }
        
        if (barcodes.count > 0) {
            [CSSUtils showAlertWithMessage:message title:@"Barcodes"];
        } else {
            [CSSUtils showAlertWithMessage:@"No barcodes found." title:@"Barcodes"];
        }
        
        return;
    }
    
    if ([actionName compare:CSSEnhanceItemExport] == NSOrderedSame) {
        NSError *error;
        [CMSCaptureImage saveToFile:nil encoding:CMSSaveJpg
            parameters:@{
                         CMSSaveToGallery: [NSNumber numberWithBool:YES],
                         CMSSaveToGalleryCompletionTarget: self,
                         CMSSaveToGalleryCompletionSelector: [NSValue valueWithPointer:@selector(image:error:context:)]
                         } error:&error];
        
        if (error != nil) {
            [CSSUtils showAlertOnError:error title:@"Error"];
        }
        
        return;
    }
    
    if ([actionName compare:CSSEnhanceItemCrop] == NSOrderedSame) {
        [self cacheZoomScaleAndSetTo1];
        // Launch manual crop view controller
        CSSCropViewController *cropVC = [[CSSCropViewController alloc] init];
        cropVC.hidesBottomBarWhenPushed = NO;
        [cropVC setImage:wipImageView.image];
        cropVC.delegate = self;
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:cropVC];
        navC.navigationBar.barTintColor = [CSSUtils getNavigationBarColor];
        [self presentViewController:navC animated:YES completion:nil];
        return;
    }
    
    if ([actionName compare:CSSEnhanceItemQuadCrop] == NSOrderedSame) {
        NSDictionary *parameters = @{CMSCropCircleRadius: [CSSSettings integerForKey:@"QuadCropRadius"],
                                     CMSCropColor: [CSSSettings uiColorForKey:@"QuadCropColor"],
                                     CMSCropContext: self,
                                     CMSCropLineWidth: [CSSSettings integerForKey:@"QuadCropWidth"],
                                     CMSCropShadeBackground: [CSSSettings boolForKey:@"QuadCropShade"]};
        
        @try {
            [CMSCaptureImage showQuadrilateralCrop:self parameters:parameters];
        }
        @catch (NSException *e) {
            [CSSUtils showAlertOnException:e title:@"Exception"];
            CSSLog(@"%@", e);
        }

        return;
    }
    
    if ([actionName compare:CSSEnhanceItemDeskew] == NSOrderedSame) {
        [self applyDeskewFilter];
        return;
    }
    
    BOOL keepZoomScale = NO;
    
    if ([actionName compare:CSSEnhanceItemGray] == NSOrderedSame) {
        // Apply the gray scale filter.
        [CMSCaptureImage applyFilters:@[CMSFilterGrayscale] parameters:nil];
        keepZoomScale = YES;
    }
    else if ([actionName compare:CSSEnhanceItemBlackAndWhite] == NSOrderedSame) {
        // Apply the adaptive black and white filter.
        [CMSCaptureImage applyFilters:@[CMSFilterAdaptiveBinary] parameters:@{CMSFilterParamAdaptiveBinaryForce: [CSSSettings boolForKey:@"FilterForce"],
              CMSFilterParamAdaptiveBinaryBlackness: [CSSSettings integerForKey:@"FilterBlackness"]}];
        keepZoomScale = YES;
    }
    else if ([actionName compare:CSSEnhanceItemAutoCrop] == NSOrderedSame) {
        // Apply the auto-cropping operation.
        NSDictionary *parameters = @{CMSFilterParamCropPadding: [CSSSettings floatForKey:@"FilterPadding"]};
        [CMSCaptureImage applyFilters:@[CMSFilterCrop] parameters:parameters];
    }
    else if ([actionName compare:CSSEnhanceItemResize] == NSOrderedSame) {
        NSDictionary* imageProps = [CMSCaptureImage imageProperties];
        int imageWidth = [[imageProps objectForKey:CMSImagePropertyWidth] intValue];
        int imageHeight = [[imageProps objectForKey:CMSImagePropertyHeight] intValue];
        // resize width and height to be 80% of the original width and height
        [CMSCaptureImage applyFilters:@[CMSFilterResize] parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)(imageWidth*0.8)], CMSFilterParamResizeWidth, [NSNumber numberWithInt:(int)(imageHeight*0.8)], CMSFilterParamResizeHeight, nil]];
    }
    else if ([actionName compare:CSSEnhanceItemRotate180] == NSOrderedSame) {
        // Rotate the image.
        [CMSCaptureImage applyFilters:@[CMSFilterRotation] parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:180], CMSFilterParamRotationDegree, nil]];
    }
    else if ([actionName compare:CSSEnhanceItemRotateLeft] == NSOrderedSame) {
        // Rotate the image.
        [CMSCaptureImage applyFilters:@[CMSFilterRotation] parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:270], CMSFilterParamRotationDegree, nil]];
    }
    else if ([actionName compare:CSSEnhanceItemRotateRight] == NSOrderedSame) {
        // Rotate the image.
        [CMSCaptureImage applyFilters:@[CMSFilterRotation] parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:90], CMSFilterParamRotationDegree, nil]];
    }
    else if ([actionName compare:CSSEnhanceItemLighter] == NSOrderedSame) {
        // Make the image lighter.
        [CMSCaptureImage applyFilters:@[CMSFilterBrightness] parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:16], CMSFilterParamBrightnessScale, nil]];
    }
    else if ([actionName compare:CSSEnhanceItemDarker] == NSOrderedSame) {
        // Make the image darker.
        [CMSCaptureImage applyFilters:@[CMSFilterBrightness] parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:-16], CMSFilterParamBrightnessScale, nil]];
    }
    else if ([actionName compare:CSSEnhanceItemIncreaseContrast] == NSOrderedSame) {
        // Increase the contrast.
        [CMSCaptureImage applyFilters:@[CMSFilterContrast] parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:64], CMSFilterParamContrastScale, nil]];
    }
    else if ([actionName compare:CSSEnhanceItemDecreaseContrast] == NSOrderedSame) {
        // Decrease the contrast.
        [CMSCaptureImage applyFilters:@[CMSFilterContrast] parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:-64], CMSFilterParamContrastScale, nil]];
    }
    else if ([actionName compare:CSSEnhanceItemRemoveNoise] == NSOrderedSame) {
        // Remove noise.
        NSDictionary *parameters = @{CMSFilterParamNoiseSize: [CSSSettings integerForKey:@"NoiseSize"]};
        [CMSCaptureImage applyFilters:@[CMSFilterRemoveNoise] parameters:parameters];
    }
    
    lastFilterError = [CMSCaptureImage lastError];
    [self updateImageViewWithZoomScale:keepZoomScale];
    
    //Upload Image
    
    if ([actionName compare:CSSUploadImage] == NSOrderedSame){
        [self uploadImageAction];
    }
}

- (void)setButtonsEnabled
{
    listFiltersButton.enabled = enableButtons;
    backButtonNoSave.enabled = enableButtons;
    backButtonWithSave.enabled = enableButtons;
    undoFiltersButton.enabled = enableButtons;
    undoFilterButton.enabled = enableButtons;
}

/*
 * Apply Deskew filter
 */
- (void)applyDeskewFilter
{
    // This filter application may take few seconds, therefore:
    // 1. disable the filter menu, goBack and undoFiltersButton buttons
    enableButtons = NO;
    [self setButtonsEnabled];
    // 3. set zoom scale to 1 to show the full document
    [imageScrollView setZoomScale:1.0];
    // 2. show UIActivityIndicatorView
    activityView.center = self.view.center;
    [activityView startAnimating];
    dispatch_queue_t deskewQueue = dispatch_queue_create("deskew", NULL);
    dispatch_async(deskewQueue, ^{
        // Apply the deskew/perspective filter.
        [CMSCaptureImage applyFilters:@[CMSFilterPerspective] parameters:nil];
        // UI changes should be done only on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityView stopAnimating];
            [self updateImageViewWithZoomScale:NO];
            enableButtons = YES;
            [self setButtonsEnabled];
        });
    });
}

/*
 * Update the view with the changed image.
 * Called after a filter has been applied.
 */
- (void)updateImageViewWithZoomScale:(BOOL)keepScale
{
    [self showUndoButton:YES];
    // get the changed image from SDK
    CGRect rect = [CSSUtils getRectForLoadedImage];
    UIImage *image = [CMSCaptureImage imageForDisplayWithWidth:0 height:0 rect:CGRectMake(0, 0, 0, 0)];
    [wipImageView setImage:image];
    [self cacheZoomScaleAndSetTo1];
    [self positionWipImageViewForFrame:rect];

    // re-apply zoom scale if specified
    if (keepScale)
        [self resetScale];
    
    [wipImageView setNeedsDisplay];
}

/*
 * Show image info obtained using SDK imageProperties methd.
 */
- (void)presentImageInfo
{
    _imageInfoController = [[CSSImageInfoViewController alloc] initWithFilterError:lastFilterError];
    _imageInfoController.title = @"Information";
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:_imageInfoController];
    navC.navigationBar.barTintColor = [CSSUtils getNavigationBarColor];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [self cacheZoomScaleAndSetTo1];
        [_imageInfoController addBackButton];
        _imageInfoController.delegate = self;
        [self presentViewController:navC animated:YES completion:nil];
    } else {
        _imageInfoPopover = [[UIPopoverController alloc] initWithContentViewController:navC];
        _imageInfoPopover.delegate = self;
        CGSize dataSize = [_imageInfoController getWidthOfText];
        [_imageInfoPopover setPopoverContentSize:CGSizeMake(dataSize.width, dataSize.height*12)];
        [_imageInfoPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *)listFiltersButton
                                 permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (void)uploadImageAction
{
    //Push Upload Image View Controller
    [self displayLoadingSpinner];
    UIImage* image = wipImageView.image;
    [self uploadImage:image];
}

- (void)uploadImage:(UIImage *)image
{
    EnhanceVCHelper *helper = [[EnhanceVCHelper alloc] init];
    [helper uploadImageWithImage: image completion:^(NSDictionary * _Nullable param1, NSError * _Nullable param2){
        [self removeLoadingSpinner];
        [self displayUploadResult:param1 :param2];
    }];
}

// zoom support
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if (imageScrollView.zoomScale == 5.0)
        imageScrollView.zoomScale = 1.0;
    else
        imageScrollView.zoomScale = 5.0;
    
}

// The view size of the UIViewController is updated after viewDidLoad;
// Image position should be recalculated in viewWillAppear.
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.alpha = 0.5;
    self.hidesBottomBarWhenPushed = NO;
    [self.navigationController setToolbarHidden:NO];
    self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.toolbar.alpha = 0.5;
    [self positionWipImageViewForFrame:[CSSUtils getRectForLoadedImage]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setAppearance];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    undoFiltersButton = [[UIBarButtonItem alloc]
                         initWithTitle:@"Undo All"
                         style:UIBarButtonItemStyleBordered
                         target:self
                         action:@selector(undoFiltersButtonPressed)];
    undoFilterButton = [[UIBarButtonItem alloc]
                        initWithTitle:@"Undo Last"
                        style:UIBarButtonItemStyleBordered
                        target:self
                        action:@selector(undoFilterButtonPressed)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBarButtons = [NSArray arrayWithObjects:undoFilterButton, flexSpace, undoFiltersButton, nil];

    imageScrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [imageScrollView setContentSize:CGSizeMake(wipImageView.frame.size.width, wipImageView.frame.size.height)];
    wipImageView.userInteractionEnabled = YES;
    imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [twoFingerTap setNumberOfTouchesRequired:2];
    
    [wipImageView addGestureRecognizer:doubleTap];
    [wipImageView addGestureRecognizer:twoFingerTap];
    
    [imageScrollView setCanCancelContentTouches:NO];
    imageScrollView.clipsToBounds = YES;
    imageScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    imageScrollView.minimumZoomScale = 1.0;
    imageScrollView.maximumZoomScale = 5.0;
    imageScrollView.delegate = self;
    [imageScrollView addSubview:wipImageView];
    self.view = imageScrollView;
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(0.0, 0.0, 80.0, 80.0);
    [activityView.layer setBackgroundColor:[[UIColor colorWithWhite: 0.0 alpha:0.30] CGColor]];
    activityView.center = self.view.center;
    [imageScrollView addSubview: activityView];
    enableButtons = YES;
    
    [CMSCaptureImage enableUndoImage:[CSSSettings boolForKey:@"UndoLast"].boolValue];
    
    [self initializeSpinner];
    
    //Add A Text Field at the bottom
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(45, 30, 200, 40)];
    tf.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    tf.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    tf.backgroundColor=[UIColor whiteColor];
    tf.text=@"Insert POD NUmber";
    
    float someY = [UIScreen mainScreen].bounds.size.height;
    float someOtherY = tf.frame.size.height;
    float y = [UIScreen mainScreen].bounds.size.height - tf.frame.size.height;
    float anotherY = imageScrollView.frame.size.height - tf.frame.size.height;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, anotherY, 400 , 400)];
    [view addSubview:tf];
    [self.view addSubview:view];
    
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [imageScrollView setZoomScale:1.0];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self positionWipImageViewForFrame:[CSSUtils getRectForLoadedImage]];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return wipImageView;
}

/*
 * Centers image frame
 */
- (void)positionWipImageViewForFrame:(CGRect)frame
{
    wipImageView.frame = frame;
    [imageScrollView setContentSize:CGSizeMake(wipImageView.frame.size.width, wipImageView.frame.size.height)];
    activityView.center = self.view.center;
    // cacluate the x-offset so that the image is centered horizontally
    CGFloat offsetX = (imageScrollView.bounds.size.width > imageScrollView.contentSize.width) ?
                    (imageScrollView.bounds.size.width - wipImageView.frame.size.width) * 0.5 : 0.0;
    // calculate the y-offset so that the image is slightly lower than the navigation bar.
    CGFloat offsetY = (imageScrollView.bounds.size.height > imageScrollView.contentSize.height) ?
                    (imageScrollView.bounds.size.height - imageScrollView.contentSize.height
                     - self.navigationController.navigationBar.frame.size.height) * 0.25 : 0.0;
    wipImageView.center = CGPointMake(imageScrollView.contentSize.width * 0.5 + offsetX, imageScrollView.contentSize.height * 0.5 + offsetY);
    [wipImageView setNeedsDisplay];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView* zoomView = [scrollView.delegate viewForZoomingInScrollView:scrollView];
    CGRect zoomViewFrame = zoomView.frame;
    if(zoomViewFrame.size.width < scrollView.bounds.size.width)
    {
        zoomViewFrame.origin.x = (scrollView.bounds.size.width - zoomViewFrame.size.width) / 2.0;
    }
    else
    {
        zoomViewFrame.origin.x = 0.0;
    }
    if(zoomViewFrame.size.height < scrollView.bounds.size.height)
    {
        zoomViewFrame.origin.y = (scrollView.bounds.size.height - zoomViewFrame.size.height
                                  - self.navigationController.navigationBar.frame.size.height) / 4.0;
    }
    else
    {
        zoomViewFrame.origin.y = 0.0;
    }
    zoomView.frame = zoomViewFrame;
}

- (NSArray *)barcodeTypes
{
    NSMutableArray *types = [NSMutableArray array];
    NSArray *typesToCheck = @[CMSBarcodeTypeAll,
                              CMSBarcodeTypeIndustry2of5,
                              CMSBarcodeTypeInterleaved2of5,
                              CMSBarcodeTypeIATA2of5,
                              CMSBarcodeTypeDatalogic2of5,
                              CMSBarcodeTypeInverted2of5,
                              CMSBarcodeTypeBCDMatrix,
                              CMSBarcodeTypeMatrix2of5,
                              CMSBarcodeTypeCode32,
                              CMSBarcodeTypeCode39,
                              CMSBarcodeTypeCodabar,
                              CMSBarcodeTypeCode93,
                              CMSBarcodeTypeCode128,
                              CMSBarcodeTypeEAN13,
                              CMSBarcodeTypeEAN8,
                              CMSBarcodeTypeUPCA,
                              CMSBarcodeTypeUPCE,
                              CMSBarcodeTypeAdd5,
                              CMSBarcodeTypeAdd2,
                              CMSBarcodeTypeEAN128,
                              CMSBarcodeTypePatchcode,
                              CMSBarcodeTypePostnet,
                              CMSBarcodeTypePDF417,
                              CMSBarcodeTypeDatamatrix,
                              CMSBarcodeTypeCode93Extended,
                              CMSBarcodeTypeCode39Extended,
                              CMSBarcodeTypeQRCode,
                              CMSBarcodeTypeIntelligentMail,
                              CMSBarcodeTypeRoyalPost4State,
                              CMSBarcodeTypeAustralianPost4State,
                              CMSBarcodeTypeAztec,
                              CMSBarcodeTypeGS1DataBar];
    
    for (NSString *type in typesToCheck) {
        if ([CSSSettings boolScalarForKey:type]) {
            [types addObject:type];
        }
    }
    
    return types;
}

- (bool)displayUploadResult:(NSDictionary*)jsonResult :(NSError*)error{
    
    if (jsonResult != nil){
        return [self displayUploadSuccess:jsonResult];
    }else if( error != nil){
        return [self displayUploadError:error];
    }
    return false;
}

- (bool) displayUploadSuccess:(NSDictionary*)jsonResult{
    
    [CSSUtils showAlertWithMessage:@"The image was uploaded to server successfully" title:@"Upload Success"];
    return true;
}

- (bool) displayUploadError:(NSError*)error{
    
    [CSSUtils showAlertOnError:error title:@"Error, please try to log in again"];
    return true;
}

- (void) displayLoadingSpinner{

    [indicator startAnimating];

}

- (void) removeLoadingSpinner{
    
    [indicator stopAnimating];
    
}

- (void) initializeSpinner{
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;

}
@end
