//
//  Copyright (c) 2013-2016 EMC Corporation.  All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @abstract The protocol that contains methods called by @link //apple_ref/occ/clm/CMSCaptureImage/takePicture:parameters:error: @/link.
 */
@protocol CMSImageDelegate <NSObject>

/*!
    @abstract Called when picture is available.
    @param imageData Encoded JPG image data from the camera.
    @param data A dictionary containing information about the new frame. The dictionary contains:
       <dl>
          <dt><code>CMSCaptureSimilarity</code></dt>
              <dd>An <code>NSNumber</code> score indicating how similar this frame is to the previous frame. 0 is not very similar and 100 is extremely similar.</dd>
          <dt><code>CMSQualityCorners</code></dt>
              <dd>An <code>NSArray</code> of four points which indicate the corners of the detected quadrilateral. This value is only included if the quarilateral or perspective quality sensors were enabled and a quadrilateral was detected.</dd>
          <dt><code>CMSCaptureSavedFileName</code></dt>
              <dd>The name of the saved file when the output type includes <code>CMSTakePictureReturnFile</code>. The value contains only the name and not the full path.</dd>
        </dl>
 */
- (void)imageDidTakePicture:(NSData *)imageData data:(NSDictionary *)data;

/*!
 @abstract Called when picture is available.
 @param imageData Encoded JPG image data from the camera.
 @discussion This method exists for backwards compatibility. New code should use @link imageDidTakePicture:data: imageDidTakePicture:data: @/link instead as that method provides more information about the taken picture and support for file output.
 */
- (void)imageDidTakePicture:(NSData *)imageData;

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
- (void)imageDidCancelTakePicture:(int)reason;

@end
