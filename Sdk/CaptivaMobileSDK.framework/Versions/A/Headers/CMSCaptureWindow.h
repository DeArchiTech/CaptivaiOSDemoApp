//
//  Copyright (c) 2015-2016 EMC Corporation.  All rights reserved.
//

#ifndef Captiva_Mobile_SDK_CMSCaptureWindow_h
#define Captiva_Mobile_SDK_CMSCaptureWindow_h


#import <UIKit/UIKit.h>
@interface CMSCaptureWindow : NSObject

//
// Methods used for constructing custom UI.
//

/*!
 * Gets the view for the capture window. Custom UI should be added to this view.
 * @returns The capture window view.
 */
-(UIView*) view;

//
// Methods used for controlling the capture window behavior.
//

/*!
 * Cancels the take picture process.
 * @param reason The cancellation reason that is returned to the application.
 */
-(void) cancelPicture:(int)reason;

/*!
 * Starts the picture taking process, changing the mode from idle to capturing.
 */
-(void) beginTakePicture;

/*!
 * Turns the device's torch on or off.
 * @param on YES to turn the torch on; no to turn it off.
 * @discussion If the device does not have a torch, this method does nothing.
 */
-(void) setTorch:(BOOL)on;

/*!
 * Gets a value that indicates whether all requested sensors are valid.
 * @return YES if all sensors are valid; NO otherwise.
 * @discussion The quality sensor is only measured after a candidate picture has 
 * been taken. During the idle state and while waiting, the return value for this
 * method is based only on the other sensors.
 */
-(BOOL) areAllSensorsValid;

/*!
 * Gets the rectangle in screen coordinates to which captured images will be cropped.
 * @return A rectangle in screen coordinates; the return value is empty if crop guidelines are not in use.
 * @discussion This method only returns a valid rectangle during or after the 
 * first execution of the viewWillLayoutSubviews method. Custom UI can position a 
 * view at the location described by this rectangle to indicate to the user where the
 * document should be positioned.
 */
-(CGRect) cropGuidelineForPreview;

/*!
 * Sets the zone for the crop guidelines.
 * @return A rectangle in screen coordinates; the return value is <code>CGRectZero</code> if crop guidelines are not in use.
 * @param cropZone The rectangle in screen coordinates into which the crop guidelines must fit. If the zone is empty, the entire screen is used.
 */
-(CGRect) setCropZoneForPreview:(CGRect)cropZone;

//
// Captiva events called by the SDK
//

/*!
  Called when the SDK changes the capture mode.
  @param mode The new capture mode. The modes and their meanings are:
 <dl>
   <dt><code>CMSCaptureModeIdle</code></dt>
   <dd>The application has just launched the capture UI and the user has not yet
        clicked the capture button.</dd>
   <dt><code>CMSCaptureModeCapturing</code></dt>
   <dd>The application is capturing images.</dd>
 </dl>
 */
-(void) onShowCaptureMode:(int)mode;

/*!
  Called when the picture taking process is being cancelled.
  @param reason The reason capture is cancelled. The reasons and their meanings are:
 <ul>
   <li>CMSCancelReasonButton = Cancel button was pressed.</li>
   <li>CMSCancelReasonTimeout = Optimal condition requirements were not met.</li>
   <li>CMSCancelReasonError = Error occurred during image capturing process.</li>
   <li>CMSCancelReasonPermission = No permission to access the camera.</li>
   <li>CMSCancelReasonBackground = Application entered background status.</li>
 </ul>
 */
-(void) onCancelPicture:(int)reason;

/*!
  Called when a sensor value changes.
  @param sensor The ID of the changed sensor. Supported sensors are:
 <dl>
   <dt><code>CMSSensorMovement</code></dt>
   <dd>The device has moved. The <code>data</code> is a <code>CMDeviceMotion</code> object.</dd>
   <dt><code>CMSSensorFocus</code></dt>
   <dd>Focus has changed. No data is returned.</dd>
   <dt><code>CMSSensorQuality</code></dt>
   <dd>The quality of the image has changed. The <code>data</code> is an <code>NSDictionary</code> as described in the discussion.</dd>
 </dl>
  @param valid YES if the sensor meets the thresholds; NO otherwise
  @param data A data object that is appropriate for the sensor.
  @discussion When the quality sensor changes, the returned data dictionary contains the following entries:
 <dl>
   <dt><code>CMSQualityCorners</code></dt>
   <dd>NSArray of NSValue objects wrapping CGPoint.</dd>
 </dl>
 */
-(void) onSensorChange:(NSInteger)sensor valid:(BOOL)valid data:(NSObject*)data;

//
// System events forwarded by the SDK
//

/*!
  Called when the capture view has been loaded. An application can use this to create its custom elements.
 */
-(void) viewDidLoad;

/*!
  Called to lay out the capture view.
 */
-(void) viewWillLayoutSubviews;

/*!
  Called when the view is about to be removed.
  @param animated YES if the change is being animated; NO otherwise.
 */
-(void) viewWillDisappear:(BOOL)animated;

/*!
  Called when the application receives a memory warning.
 */
-(void) didReceiveMemoryWarning;

/*!
  Called when Cordova configures the capture window.
 */
-(void) configure:(NSDictionary*)configuration;

@end

#endif
