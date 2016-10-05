//
//  Copyright (c) 2013-2016 EMC Corporation.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMSImageDelegate.h"

#import "CSSUtils.h"


@interface CSSMainViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate, CMSImageDelegate, ImagePickerDelegate, ActionPickerDelegate, CMSContinuousCaptureDelegate> {
    int captureCount;
    UIActivityIndicatorView *indicator;
}

@property NSArray *actionsArray;
@property ActionPickerViewController *actionPicker;
@property UIPopoverController *actionPickerPopover;
@property UIPopoverController *imagePickerPopover;
@property UIImagePickerController *imagePickerController;
@property UIActivityIndicatorView *activityView;

@end
