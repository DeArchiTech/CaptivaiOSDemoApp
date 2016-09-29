//
//  Copyright (c) 2013-2016 EMC Corporation.  All rights reserved.
//

#ifndef CSSUTILS_H
#define CSSUTILS_H
#import <UIKit/UIKit.h>
#import "CMSImageDelegate.h"

#define CSSLog(format, ...) NSLog((@"%s:%d " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

// main screen title
extern NSString * const CSSMainTitle;

// main menu content
extern NSString * const CSSMenuTakePicture;
extern NSString * const CSSMenuContinuousCapture;
extern NSString * const CSSMenuEnhanceImage;
extern NSString * const CSSMenuDeleteDocFiles;

// SelectImage menu content
extern NSString * const CSSSelectImageTitle;
extern NSString * const CSSSelectImageFromPhotos;
extern NSString * const CSSSelectImageFromPhotoAlbums;
extern NSString * const CSSSelectImageFromDocuments;

// enhance operations
extern NSString * const CSSEnhanceItemBlackAndWhite;
extern NSString * const CSSEnhanceItemGray;
extern NSString * const CSSEnhanceItemDeskew;
extern NSString * const CSSEnhanceItemAutoCrop;
extern NSString * const CSSEnhanceItemResize;
extern NSString * const CSSEnhanceItemRotate180;
extern NSString * const CSSEnhanceItemRotateLeft;
extern NSString * const CSSEnhanceItemRotateRight;
extern NSString * const CSSEnhanceItemCrop;
extern NSString * const CSSEnhanceItemLighter;
extern NSString * const CSSEnhanceItemDarker;
extern NSString * const CSSEnhanceItemIncreaseContrast;
extern NSString * const CSSEnhanceItemDecreaseContrast;
extern NSString * const CSSEnhanceItemRemoveNoise;
extern NSString * const CSSEnhanceItemQuadCrop;
extern NSString * const CSSEnhanceItemGetInfo;
extern NSString * const CSSEnhanceItemExport;
extern NSString * const CSSEnhanceItemBarcode;
extern NSString * const CSSUploadImage;

extern const int CSSActionPickerFilterType;
extern const int CSSActionPickerImageLocationType;

extern const float CSSCropMinWidth;
extern const float CSSCropMinHeight;



@protocol ImagePickerDelegate <NSObject>
@required
-(void)selectedImagePath:(NSString *)imagePath;
@end


@protocol ActionPickerDelegate <NSObject>
@required
-(void)selectedAction:(NSString *)newFilter;
@end

@protocol ImageUpdateDelegate <NSObject>
@required
-(void)updateImageFromSDK;
-(void)resetScale;
@end

@interface ActionPickerViewController : UITableViewController

@property NSMutableArray *actionNames;
@property id<ActionPickerDelegate> delegate;

-(void)setData:(int)actionType;

@end

@interface CSSImageInfoViewController : UIViewController

@property UITextView *textView;
@property NSString *deviceIdStr;
@property NSString *imageInfoData;
@property (nonatomic, weak) id<ImageUpdateDelegate> delegate;

- (CGSize)getWidthOfText;
- (void)addBackButton;
- (id)initWithFilterError:(NSError*)filterError;
@end

@interface CSSSelectDocImageViewController : UITableViewController
{
    // do not generate image thumbnails on low memory
    BOOL showImages;
    
    NSMutableArray *fileNameArray;
    NSMutableArray *filePathArray;
    NSMutableArray *thumbnailArray;
}
@property id<ImagePickerDelegate> imagePickedDelegate;

- (void)populateFileList;

@end

@interface CSSImageHelper : NSObject

@property NSString *imageFilePath;
@property NSData *encodedBytes;
@property BOOL isLoadedFromFilePath;

-(void)loadFromBytes:(NSData *)imageData error:(NSError **)error;
-(void)loadFromFile:(NSString *)imagePath error:(NSError **)error;
-(void)saveLoaded:(NSError **)error;
-(void)savePicture:(NSData *)picture error:(NSError **)error;
-(void)reload:(NSError **)error;

@end

@interface CSSUtils : NSObject

+ (CGRect)getRectForLoadedImage;
+ (CGRect)getRectForLoadedImageWithOffset:(BOOL)withOffset;
+ (void)showAlertWithMessage:(NSString *)message title:(NSString *)title;
+ (void)showAlertOnError:(NSError *)error title:(NSString *)title;
+ (void)showAlertOnException:(NSException *)exception title:(NSString *)title;
+ (UIColor*)getNavigationBarColor;
+ (UIBarButtonItem*)getBarButtonItemForTarget:(id)target imageName:(NSString *)imageName action:(SEL)action height:(CGFloat)height;
+ (void)deleteAllFilesFromDocFolder;

@end

#endif // CSSUTILS_H
