//
//  Copyright (c) 2013-2016 EMC Corporation.  All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @header
 @abstract
 Protocols and constants related to continuous capture.
 */

typedef NS_ENUM(NSUInteger, CMSContinuousCaptureOperation) {
    CMSContinuousCaptureInvalid,
    CMSContinuousCaptureStop,
    CMSContinuousCaptureContinue,
    CMSContinuousCaptureContinueWithPrevious
};

/*!
 @abstract The protocol that contains methods called by @link //apple_ref/occ/clm/CMSCaptureImage/continuousCapture:parameters:error: @/link.
 */
@protocol CMSContinuousCaptureDelegate <NSObject>

/*!
 @abstract Called when picture is available.
 @param imageData Encoded JPG image data from the camera.
 @param data A dictionary containing information about the new frame. The dictionary contains:
  <dl>
      <dt>CMSCaptureSimilarity</dt>
      <dd>An <code>NSNumber</code> score indicating how similar this frame is to the previous frame. 0 is not very similar and 100 is extremely similar.</dd>
      <dt>CMSQualityCorners</dt>
      <dd>An <code>NSArray</code> of four points which indicate the corners of the detected quadrilateral. This value is only included if the quarilateral or perspective quality sensors were enabled and a quadrilateral was detected.</dd>
 </dl>
 @return <code>CMSContinuousCaptureOperation</code> to control operation.
 <dl>
    <dt>CMSContinuousCaptureInvalid</dt>
    <dd>Initial invalid enum value.</dd>
    <dt>CMSContinuousCaptureStop</dt>
    <dd>Stop the continuous capture operation.</dd>
    <dt>CMSContinuousCaptureContinue</dt>
    <dd>Continue capturing pictures.  The current captured frame will be used as the previous frame for the next comparision.</dd>
    <dt>CMSContinuousCaptureContinueWithPrevious</dt>
    <dd>Continue capturing pictures, persist the previous frame, and perform comparisions with this previous frame. This behavior will occur until <code>CMSContinuousCaptureContinue</code> is used. At that point the previous frame will be updated to the current frame.</dd>
    <dt>CMSCaptureSavedFileName</dt>
    <dd>The name of the saved file when the output type includes <code>CMSTakePictureReturnFile</code>. The value contains only the name and not the full path.</dd>
 </dl>
 */
- (CMSContinuousCaptureOperation)newImage:(NSData *)imageData data:(NSDictionary*)data;

/*!
 @abstract Called if the picture is canceled.
 @param  reason This provides a reason for the cancel. Additional reasons will be added in future releases.
     <ul>
         <li>CMSCancelReasonButton = Cancel button was pressed.</li>
         <li>CMSCancelReasonTimeout = Optimal condition requirements were not met.</li>
         <li>CMSCancelReasonError = Error occurred during image capturing process.</li>
         <li>CMSCancelReasonPermission = No permission to access the camera.</li>
         <li>CMSCancelReasonBackground = Application entered background status.</li>
     </ul>
 */
- (void)didCancel:(int)reason;

@end