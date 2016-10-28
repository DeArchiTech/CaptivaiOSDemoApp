//
//  Copyright (c) 2013-2016 EMC Corporation.  All rights reserved.
//

#import "AssetsLibrary/AssetsLibrary.h"
#include <libkern/OSAtomic.h>
#include <stdio.h>
#import "QuartzCore/CAGradientLayer.h"

#import "CMSCaptureImage.h"
#import "CMSConstants.h"

#import "CSSUtils.h"
#import "CSSSettings.h"
#import "SDKSampleApp-Swift.h"


// main screen title
NSString * const CSSMainTitle = @"SDK Sample";

// main menu content
NSString * const CSSMenuTakePicture = @"Take Picture";
NSString * const CSSMenuContinuousCapture = @"Continuous Capture";
NSString * const CSSMenuEnhanceImage = @"Enhance Image";
NSString * const CSSMenuDeleteDocFiles = @"Delete All Documents";
NSString * const CSSMenuCreateSession = @"New POD Session";
NSString * const CSSCreateProfile = @"Create Filter Profile";
NSString * const CSSSelectFilterProfile = @"Select Filter Profile";

// SelectImage menu content
NSString * const CSSSelectImageTitle = @"Select Image";
NSString * const CSSSelectImageFromPhotos = @"Photos";
NSString * const CSSSelectImageFromPhotoAlbums = @"Photo Albums";
NSString * const CSSSelectImageFromDocuments = @"Documents Folder";

// filter names
NSString * const CSSEnhanceItemBlackAndWhite = @"Black-White";
NSString * const CSSEnhanceItemGray = @"Gray";
NSString * const CSSEnhanceItemDeskew = @"Deskew";
NSString * const CSSEnhanceItemAutoCrop = @"Auto Crop";
NSString * const CSSEnhanceItemResize = @"Resize";
NSString * const CSSEnhanceItemRotate180 = @"Rotate 180";
NSString * const CSSEnhanceItemRotateLeft = @"Rotate Left";
NSString * const CSSEnhanceItemRotateRight = @"Rotate Right";
NSString * const CSSEnhanceItemCrop = @"Crop";
NSString * const CSSEnhanceItemLighter = @"Lighter";
NSString * const CSSEnhanceItemDarker = @"Darker";
NSString * const CSSEnhanceItemIncreaseContrast = @"Increase Contrast";
NSString * const CSSEnhanceItemDecreaseContrast = @"Decrease Contrast";
NSString * const CSSEnhanceItemRemoveNoise = @"Remove Noise";
NSString * const CSSEnhanceItemGetInfo = @"Get Information";
NSString * const CSSEnhanceItemExport = @"Export to Photos";
NSString * const CSSEnhanceItemQuadCrop = @"Quadrilateral Crop";
NSString * const CSSEnhanceItemBarcode = @"Detect barcodes";

// Additional Items
NSString * const CSSUploadImage = @"Upload Image Now";
NSString * const CSSTakeAnotherImage =@"Take another Image";
NSString * const CSSInsertPOD =@"Insert POD & Upload";

const int CSSActionPickerFilterType = 0;
const int CSSActionPickerImageLocationType = 1;

const float CSSCropMinWidth = 100.0;
const float CSSCropMinHeight = 100.0;

/*
 * Utility class to host a list of actions. Used on iPad with UIPopoverController
 */
@implementation ActionPickerViewController

@synthesize actionNames;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    CSSLog(@"Received memory warning");
}

- (void)setData:(int)actionType
{
    //Initialize the array
    actionNames = [NSMutableArray array];
        
    if (actionType == CSSActionPickerFilterType) {
        //Set up the array of filter names.
        [actionNames addObject:CSSEnhanceItemAutoCrop];
        [actionNames addObject:CSSEnhanceItemBlackAndWhite];
        [actionNames addObject:CSSEnhanceItemIncreaseContrast];
        [actionNames addObject:CSSEnhanceItemDecreaseContrast];
        [actionNames addObject:CSSEnhanceItemCrop];
        [actionNames addObject:CSSEnhanceItemDeskew];
        [actionNames addObject:CSSEnhanceItemGray];
        [actionNames addObject:CSSEnhanceItemResize];
        [actionNames addObject:CSSEnhanceItemRotate180];
        [actionNames addObject:CSSEnhanceItemRotateLeft];
        [actionNames addObject:CSSEnhanceItemRotateRight];
        [actionNames addObject:CSSEnhanceItemLighter];
        [actionNames addObject:CSSEnhanceItemDarker];
        [actionNames addObject:CSSEnhanceItemRemoveNoise];
        [actionNames addObject:CSSEnhanceItemQuadCrop];
        [actionNames addObject:CSSEnhanceItemBarcode];
        [actionNames addObject:CSSEnhanceItemExport];
        [actionNames addObject:CSSEnhanceItemGetInfo];
        [actionNames addObject:CSSUploadImage];
        [actionNames addObject:CSSTakeAnotherImage];
        [actionNames addObject:CSSInsertPOD];
    }
    else if (actionType == CSSActionPickerImageLocationType) {
        // set up array of image location names
        [actionNames addObject:CSSSelectImageFromPhotos];
        [actionNames addObject:CSSSelectImageFromPhotoAlbums];
        [actionNames addObject:CSSSelectImageFromDocuments];
    }
    //Make row selections persist.
    self.clearsSelectionOnViewWillAppear = NO;
    
    //Calculate how tall the view should be by multiplying
    //the individual row height by the total number of rows.
    NSInteger rowsCount = [actionNames count];
    NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView
                                            heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSInteger totalRowsHeight = rowsCount * singleRowHeight;
        
    //Calculate how wide the view should be by finding how
    //wide each string is expected to be
    CGFloat largestLabelWidth = 0;
    for (NSString *filterName in actionNames) {
        //Checks size of text using the default font for UITableViewCell's textLabel.
        CGSize labelSize = [filterName sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
        if (labelSize.width > largestLabelWidth) {
            largestLabelWidth = labelSize.width;
        }
    }
        
    //Add a little padding to the width
    CGFloat popoverWidth = largestLabelWidth + 20;
        
    //Set the property to tell the popover container how big this view will be.
    self.contentSizeForViewInPopover = CGSizeMake(popoverWidth, totalRowsHeight);
}
    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [actionNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.textLabel.text = [actionNames objectAtIndex:indexPath.row];
    
    return cell;
}

/*
 * Table view delegate
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *selectedActionName = [actionNames objectAtIndex:indexPath.row];
    
    //Notify the delegate if it exists.
    if (_delegate != nil) {
        [_delegate selectedAction:selectedActionName];
    }
}

@end

/*
 * CSSImageInfoViewController presents image info using SDK methods deviceId and imageProperties
 */
@implementation CSSImageInfoViewController

@synthesize textView;
@synthesize deviceIdStr;
@synthesize imageInfoData;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    CSSLog(@"Received memory warning");
}

- (id)initWithFilterError:(NSError *)filterError
{
    self = [super init];
    if (self) {
        NSString *format = @"\nDevice ID: %@\n\nImage Width: %d\nImage Height: %d\nImage Channels: %d\nImage Bits Per Pixel: %d\n\nVersion: %@\n\nGlare: %d\nQuadrilateral: %d\nPerspective: %d\nTotal Quality: %d\n\nLast Error: %@";
        deviceIdStr = [CMSCaptureImage deviceId];
        NSDictionary* imageProps = [CMSCaptureImage imageProperties];
        int glare = [CMSCaptureImage measureQuality:@{CMSMeasureGlare:@1}];
        int quadrilateral = [CMSCaptureImage measureQuality:@{CMSMeasureQuadrilateral:@1}];
        int perspective = [CMSCaptureImage measureQuality:@{CMSMeasurePerspective:@1}];
        
        NSDictionary* allAssessments =
        @{
          CMSMeasureGlare: @1,
          CMSMeasureQuadrilateral: @1,
          CMSMeasurePerspective: @1
          };
        int totalQuality = [CMSCaptureImage measureQuality:allAssessments];
        NSString *error = filterError ? [filterError localizedDescription] : @"No error";
        imageInfoData = [[NSString alloc] initWithFormat:format,
                                   deviceIdStr,
                                   [[imageProps objectForKey:CMSImagePropertyWidth] integerValue],
                                   [[imageProps objectForKey:CMSImagePropertyHeight] integerValue],
                                   [[imageProps objectForKey:CMSImagePropertyChannels] integerValue],
                                   [[imageProps objectForKey:CMSImagePropertyBitsPerPixel] integerValue],
                                   [CMSCaptureImage version],
                                    glare,
                                    quadrilateral,
                                    perspective,
                                    totalQuality,
                                    error
                                   ];
    }
    return self;
}

- (CGSize)getWidthOfText
{
    return [deviceIdStr sizeWithFont:[UIFont systemFontOfSize:20.0f]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    textView = [[UITextView alloc] init];
    textView.text = imageInfoData;
    textView.editable = NO;
    self.view = textView;
}

- (void)addBackButton
{
    self.navigationItem.leftBarButtonItem = [CSSUtils getBarButtonItemForTarget:self
                                                                      imageName:@"ic_prev.png"
                                                                         action:@selector(returnFromController)
                                                                         height:self.navigationController.navigationBar.frame.size.height];
}

- (void)returnFromController
{
    [[self parentViewController] dismissViewControllerAnimated:YES completion:^{
        if (_delegate != nil)
            [_delegate resetScale];
    }];
}

@end


/*
 * CSSSelectDocImageViewController presents the list of file from the application Documents folder
 */
@implementation CSSSelectDocImageViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // do not load any more images into the UITableView
    showImages = NO;
    [thumbnailArray removeAllObjects];
    CSSLog(@"Received memory warning");
}

- (id)init
{
    self = [super init];
    if (self) {
        showImages = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [CSSUtils getBarButtonItemForTarget:self
                                                                      imageName:@"ic_prev.png"
                                                                         action:@selector(returnFromController)
                                                                         height:self.navigationController.navigationBar.frame.size.height];
    self.tableView.tableFooterView = [UIView new];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.navigationItem.leftBarButtonItem = [CSSUtils getBarButtonItemForTarget:self
                                                                      imageName:@"ic_prev.png"
                                                                         action:@selector(returnFromController)
                                                                         height:self.navigationController.navigationBar.frame.size.height];
}

- (void)returnFromController
{
    self.imagePickedDelegate = nil;
    [[self parentViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)populateFileList
{
    fileNameArray = [NSMutableArray array];
    filePathArray = [NSMutableArray array];
    thumbnailArray = [NSMutableArray array];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSArray *dirContents = [fileMan contentsOfDirectoryAtPath:documentsDirectory error:nil];
    NSArray *extensions = [NSArray arrayWithObjects:@"jpg", @"png", @"tif", nil];
    NSArray *files = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", extensions]];
    for (NSString *fileName in files) {
        [fileNameArray addObject:fileName];
        [filePathArray addObject:[documentsDirectory stringByAppendingPathComponent:fileName]];
        UIImage* fullImage = [[UIImage alloc] initWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:fileName]];
        CGSize sz = [fullImage size];
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width/20, sz.height/20), NO, 0);
        [fullImage drawInRect:CGRectMake(0,0,sz.width/20,sz.height/20)];
        [thumbnailArray addObject:UIGraphicsGetImageFromCurrentImageContext()];
        UIGraphicsEndImageContext();
        fullImage = nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fileNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = (NSString *)[fileNameArray objectAtIndex:indexPath.row];
    if (showImages) {
        cell.imageView.image = (UIImage*)[thumbnailArray objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.imagePickedDelegate != nil) {
        NSString *filePath = [filePathArray objectAtIndex:indexPath.row];
        if (filePath != nil && filePath.length > 0) {
            [[self parentViewController] dismissViewControllerAnimated:YES completion:^{
                id<ImagePickerDelegate> delegate = self.imagePickedDelegate;
                self.imagePickedDelegate = nil;
                [delegate selectedImagePath:filePath];
            }];
        }
    }
}
@end

/*
 * CSSImageHelper is a wrapper around SDK methods loadFromBytes, loadFromFile, and saveToFile.
 * The image can be loaded from a photo album file (without using its actual filepath) or from 
 * a file in the application Documents folder. 
 * In case of the photo album file, the image is loaded using loadFromBytes method. If this image
 * is changed through cropping or filter application and then saved, it's saved in the application
 * Documentes folder.
 * in the case of the image from the Documents folder, if it's changed it's saved in the Documents
 * folder under a new name.
 */
@implementation CSSImageHelper

@synthesize imageFilePath;
@synthesize encodedBytes;
@synthesize isLoadedFromFilePath;

- (id)init
{
    self = [super init];
    if (self) {
        imageFilePath = nil;
        encodedBytes = nil;
        isLoadedFromFilePath = NO;
    }
    return self;
}

/*
 * A wrapper around the SDK loadFromBytes method. 
 * It's needed to set the isLoadedFromFilePath flag, which is used in the reload method.
 */
- (void)loadFromBytes:(NSData *)imageData error:(NSError **)error
{
    encodedBytes = imageData;
    [CMSCaptureImage loadFromBytes:encodedBytes error:error];
    isLoadedFromFilePath = NO;
}

/*
 * A wrapper around the SDK loadFromFile method.
 * It's needed to set the isLoadedFromFilePath flag, which is used in the reload method.
 */

- (void)loadFromFile:(NSString *)imagePath error:(NSError **)error
{
    imageFilePath = imagePath;
    [CMSCaptureImage loadFromFile:imageFilePath error:error];
    isLoadedFromFilePath = YES;
}

/*
 * A wrapper around the SDK loadFromBytes and loadFromFile methods.
 * reload method is called when a user decided to undo enhancements made to an image.
 */
- (void)reload:(NSError **)error
{
    if (isLoadedFromFilePath)
        [CMSCaptureImage loadFromFile:imageFilePath error:error];
    else
        [CMSCaptureImage loadFromBytes:encodedBytes error:error];
}

/*
 * Save a JPEG picture in the Documents folder using a new file name. This method does not use SDK API's.
 */
- (void)savePicture:(NSData *)picture error:(NSError **)error {
    // generate file path
    imageFilePath = [CSSImageHelper generateFilename:@".jpg"];
    CSSLog(@"imageFilePath: %@", imageFilePath);
    
    // save the image file
    [picture writeToFile:imageFilePath options:0 error:error];
    isLoadedFromFilePath = YES;
    
    CSSUtilHelper *helper = [[CSSUtilHelper alloc] init];
    [helper saveImageWithData:picture imagePath:imageFilePath];

}

/*
 * A wrapper around SDK saveToFile method.
 * The image is always saved under a new file name, which is generated using current time stamp.
 * If the user specified TIFF as the image format, this method applies the CMSFilterAdaptiveBinary filter
 * to the image before saving it in the file.
 */
- (void)saveLoaded:(NSError **)error
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *encoding = [CSSSettings stringForKey:@"ImageFormat"];
    NSString *extension;
    NSNumber *value;
    
    // grab dpi and compression properties
    value = [CSSSettings integerForKey:@"DPIX"];
    if ([value intValue] > 0) {
        [parameters setObject:value forKey:CMSSaveDpiX];
    }
    
    value = [CSSSettings integerForKey:@"DPIY"];
    if ([value intValue] > 0) {
        [parameters setObject:value forKey:CMSSaveDpiY];
    }
    
    value = [CSSSettings integerForKey:@"JPGQuality"];
    if ([value intValue] > 0) {
        [parameters setObject:value forKey:CMSSaveJpgQuality];
    }
             
    // process encoding
    if ([encoding isEqualToString:@"Tiff"]) {
        encoding = CMSSaveTiff;
        extension = @".tif";
        [CMSCaptureImage applyFilters:@[CMSFilterAdaptiveBinary] parameters:nil]; // tif format only supports binary images
    } else if ([encoding isEqualToString:@"Png"]) {
        encoding = CMSSavePng;
        extension = @".png";
    } else {
        encoding = CMSSaveJpg;
        extension = @".jpg";
    }
    
    // generate file path
    imageFilePath = [CSSImageHelper generateFilename:extension];
    CSSLog(@"imageFilePath: %@", imageFilePath);
    
    // save the image file with encoding
    [CMSCaptureImage saveToFile:imageFilePath encoding:encoding parameters:parameters error:error];
    isLoadedFromFilePath = YES;
}

/*
 * Generate a unique filename for the documents folder based on current time stamp.
 */
+ (NSString *)generateFilename:(NSString *)extension
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSDateFormatter* dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"yyyyMMddHHmmssSSS"];

    NSString *fileName = [dateForm stringFromDate:[NSDate date]];
    NSString *imageFilePath;
    fileName = [fileName stringByAppendingString:extension];
    imageFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    CSSLog(@"imageFilePath: %@", imageFilePath);
    return imageFilePath;
}
@end

@implementation CSSUtils

+ (CGRect)getRectForLoadedImage
{
    return [self getRectForLoadedImageWithOffset:YES];
}

/*
 * getRectForLoadedImageWithOffset calculates a frame for the loaded image
 * so that it fits within the screen bounds with the original aspect ratio.
 */
+ (CGRect)getRectForLoadedImageWithOffset:(BOOL)withOffset
{
    CGFloat screenWidth;
    CGFloat screenHeight;
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        screenWidth = [[UIScreen mainScreen] applicationFrame].size.height;
        screenHeight = [[UIScreen mainScreen] applicationFrame].size.width;
    } else {
        screenWidth = [[UIScreen mainScreen] applicationFrame].size.width;
        screenHeight = [[UIScreen mainScreen] applicationFrame].size.height;
    }
    
    // get image properties using the SDK API.
    NSDictionary* imageProps = [CMSCaptureImage imageProperties];
    NSInteger fileImageWidth = [[imageProps objectForKey:CMSImagePropertyWidth] integerValue];
    NSInteger fileImageHeight = [[imageProps objectForKey:CMSImagePropertyHeight] integerValue];
    
    // calculate view width and height to match the original image aspect ratio.
    CGFloat viewWidth = screenWidth;
    CGFloat viewHeight = viewWidth * fileImageHeight / fileImageWidth;
    if (viewHeight > screenHeight) {
        viewHeight = screenHeight;
        viewWidth = viewHeight * fileImageWidth / fileImageHeight;
    }
    
    if (withOffset) {
        // make sure view height is less than screen height by 110 points to allow
        // for toolbar and some space for crop borders.
        CGFloat diff = screenHeight - viewHeight;
        if (diff < 110) {
            viewHeight -= 110 - diff;
            // adjust view width to main the original aspect ratio.
            viewWidth = viewHeight * fileImageWidth / fileImageHeight;
        }
    }
    
    CGRect rect = CGRectMake(0, 0, viewWidth, viewHeight);
    return rect;
}

+ (void)showAlertWithMessage:(NSString *)message title:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

+ (void)showAlertOnError:(NSError *)error title:(NSString *)title
{
    if (error != nil) {
        NSString *message = [[NSString alloc] initWithFormat:@"%@", error];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

+ (void)showAlertOnException:(NSException *)exception title:(NSString *)title
{
    if (exception != nil) {
        NSString *message = [[NSString alloc] initWithFormat:@"%@", exception];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

+ (UIColor *)getNavigationBarColor
{
    return [UIColor colorWithRed:0.0/255.0 green:100.0/255.0 blue:200.0/255.0 alpha:1.0];
}

/*
 * Generates a UIBarButtonItem for a specified Navigation Bar with the given image, size, and action.
 */
+ (UIBarButtonItem*)getBarButtonItemForTarget:(id)target imageName:(NSString *)imageName action:(SEL)action height:(CGFloat)height
{
    CGFloat buttonH = height;
    UIImage *image=[UIImage imageNamed:imageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, buttonH * 1.3, buttonH);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

/*
 * Deletes all files from the application Documents folder.
 */
+ (void)deleteAllFilesFromDocFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSArray *files = [fileMan contentsOfDirectoryAtPath:documentsDirectory error:nil];
    for (NSString *fileName in files) {
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        [fileMan removeItemAtPath:filePath error:nil];
    }
}

@end

