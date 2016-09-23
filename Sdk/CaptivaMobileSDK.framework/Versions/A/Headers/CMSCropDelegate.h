//
//  Copyright (c) 2013-2016 EMC Corporation.  All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMSCropDelegate <NSObject>
/*!
    @abstract Called when the crop user interface completes.
    @param  reason This provides a reason for the completion. Additional reasons will be added in future releases.
    <ul>
        <li>CMSCropReasonCropped = Cancel button was pressed.</li>
        <li>CMSCropReasonCancelled = Optimal condition requirements were not met.</li>
        <li>CMSCropReasonError = Error occurred during crop process.</li>
    </ul>
 */
- (void)cropCompleted:(int)reason;

@end
