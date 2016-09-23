//
//  Copyright (c) 2013-2016 EMC Corporation.  All rights reserved.
//

#ifndef CSSENHANCEPICTUREVIEWCONTROLLER_H
#define CSSENHANCEPICTUREVIEWCONTROLLER_H

#import <UIKit/UIKit.h>
#import "CMSImageDelegate.h"
#import "CSSUtils.h"


@interface CSSEnhancePictureViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate, UIPopoverControllerDelegate, ActionPickerDelegate, ImageUpdateDelegate, CMSCropDelegate>
{
    UIImageView *wipImageView;
    UIScrollView *imageScrollView;
    UIBarButtonItem *listFiltersButton;
    UIBarButtonItem *undoFiltersButton;
    UIBarButtonItem *undoFilterButton;
    CGFloat cachedZoomScale;
    CGPoint cachedContentOffset;
    BOOL showUndoAndSaveButtons;
    BOOL enableButtons;
}

@property ActionPickerViewController *filterPicker;
@property UIPopoverController *filterPickerPopover;
@property CSSImageInfoViewController *imageInfoController;
@property UIPopoverController *imageInfoPopover;
@property UIActivityIndicatorView *activityView;
@property CSSImageHelper *imageLoader;
@property UIBarButtonItem *backButtonWithSave;
@property UIBarButtonItem *backButtonNoSave;
@property NSArray *toolBarButtons;
@property NSError *lastFilterError;

-(void) setAppearance;
-(void) setImage : (UIImage*) image;

@end

#endif // CSSENHANCEPICTUREVIEWCONTROLLER_H