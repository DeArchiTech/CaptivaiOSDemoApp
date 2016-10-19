//
//  Copyright (c) 2013-2016 EMC Corporation.  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "CMSConstants.h"
#import "CMSImageDelegate.h"
#import "CMSContinuousCaptureDelegate.h"
#import "CMSCropDelegate.h"

@class UIImage;

/*!
    @abstract Captiva Mobile SDK Toolkit
    @discussion This is the main interface to the SDK.  In general, numbers in NSDictionary parameters are retrieved as NSNumber objects.  The SDK uses categories which require additional linker flags such as "-all_load" or "-force_load"..0
 */
@interface CMSCaptureImage : NSObject

/*!
    @abstract Registers toolkit based on application identifier and license code.
    @discussion Call this method to register your application.
    @param applicationId Application identifier.
    @param license License code.
 */
+(BOOL)addLicenseKey:(NSString *)applicationId license:(NSString *)license;

/*!
    @abstract Apply the set of filters, in the given order, to the current image.
    @discussion The filters will be applied in the order they exist in the <code>filterNames</code> argument.  A filter can only appear once in the list.   As the (client-side) image filters are intended for processing images of captured documents, they are not applied if the current image is smaller than 100 pixels on either dimension. When this occurs, the source image is not modified and no error is returned. The crop and resize filter can be used to generate images smaller than 100 pixels, such as those used for display, but those images cannot be processed further.
    @param filterNames Array of filter names (NSString).  This can be any combination of:
    <dl>
        <dt><code>CMSFilterAdaptiveBinary</code></dt>
        <dd>This applies a best effort adaptive binary filter to the image.  In the <code>parameters</code> argument, you can use the <code>CMSFilterParamAdaptiveBinaryForce</code> key as follows: YES - Forces the darkest pixels to be set to black, even when a comparison with the surrounding pixels would set them to white; NO (Default) - Uses the default behavior of the <code>CMSFilterAdaptiveBinary</code> filter. In the 2.0 release, this filter was updated to improve the handling of light text on dark backgrounds. To control the aggressiveness of light-on-dark handling, set a value for the <code>CMSFilterParamAdaptiveBinaryBlackness</code> key in the <code>parameters</code> argument. Valid values are 1-20 where lower values are more conservative about white text on lighter backgrounds; the recommended value is the default of 6. To retain the behavior from releases before 2.0, set this value to 2.
        </dd>
  		<dt><code>CMSFilterGrayscale</code></dt>
  		<dd>This applies grayscale filter to the image.</dd>
  		<dt><code>CMSFilterPerspective</code></dt>
  		<dd>This applies a best effort deskew filter to address 2D/3D skew issues and minor rotation issues.  An optional argument, <code>CMSFilterParamPerspectivePoints</code>, can be used to supply four points ordered top-left, top-right, bottom-right, and bottom-left to define the perspective correction.  This is an NSArray of CGPoint structures stored in NSValue objects.</dd>
  		<dt><code>CMSFilterCrop</code></dt>
  		<dd>
  			This applies a crop to the image. A rectangle to crop can be provided in the
  			<code>parameters</code> argument under the key of <code>CMSFilterParamCropRectangle</code> as a CGRect stored inside a NSValue object. Automatic cropping will be done if the rectangle is not provided.  Padding for automatic cropping can been modified by the <code>CMSFilterParamCropPadding</code> float parameter. A value of 0.02 represents 2% padding.
  		</dd>
  		<dt><code>CMSFilterResize</code></dt>
  		<dd>
  			This resizes the image. The width and height need to be provided in the <code>parameters</code>
  			argument as integers under the keys of <code>CMSFilterParamResizeWidth</code> and <code>CMSFilterParamResizeHeight</code> respectively.
  		</dd>
  		<dt><code>CMSFilterRotation</code></dt>
  		<dd>
  			This rotates the image.  The rotation value needs to be provided in the <code>parameters</code>
  			argument as an integer under the key of <code>CMSFilterParamRotationDegree</code> with any of the following acceptable
  			values: 90, 180, 270. These values are clockwise rotation values.
 		</dd>
 		<dt><code>CMSFilterBrightness</code></dt>
  		<dd>
  		    This changes the brightness of the image.  The scaling factor needs to be provided in the <code>parameters</code>
  		    argument as an integer under the key of <code>CMSFilterParamBrightnessScale</code> with a value in the range -255 to 255.
            -255 produces the darkest image, 255 produces the lightest image, and 0 does not change the brightness.
        </dd>
        <dt><code>CMSFilterContrast</code></dt>
        <dd>
            This changes the contrast of the image.  The scaling factor  needs to be provided in the <code>parameters</code>
            argument as an integer under the key of <code>CMSFilterParamContrastScale</code> with a value in the range -255 to 255.
            -255 produces the lowest contrast, 255 produces the highest contrast, and 0 does not change the contrast.
        </dd>
        <dt><code>CMSFilterRemoveNoise</code></dt>
        <dd>
            This removes noise from the image. The size of the noise to remove needs to be provided in the <code>parameters</code>
            argument as an integer under the key of <code>CMSFilterNoiseSize</code> with a value greater than 0.
		</dd>
    </dl>
    @param parameters Filter specific parameters.
 */
+(void)applyFilters:(NSArray *)filterNames parameters:(NSDictionary *)parameters;

/*!
    @abstract Calculate the edges for a given image and return the rectangle.
    @param threshold The percentage (0.12 = 12%) of a row or column which must be black for it to be considered an edge.  If the threshold is less than or equal to 0 or greater than 1 then it defaults to 0.01
    @param padding The percentage of the image width or height by which the crop rectangle is expanded before cropping.  If the padding is less than 0 or greater than 1 it will default to 0.00
    @return A rectangle which contains the edges.
    
 */
+(CGRect)autoCropRectWithThreshold:(double)threshold padding:(double)padding;

/*!
 @abstract Clear the undo buffer.
 @discussion Frees memory associated with the undo buffer. This buffer stores the original image data before modification by various functions.
 */
+(void)clearUndoImage;

/*!
 @abstract          Returns a set of encoded JPEG byte arrays from the captured images.
 @param callback	The callback that will be called when a picture is taken. Mandatory (must not be nil).
 @param parameters	Parameters that control the capture. See <code>takePicture</code> parameters in @link //apple_ref/occ/clm/CMSCaptureImage/takePicture:parameters:error: @/link.  Additionally these parameters are also available.
 <dl>
    <dt>Key=<code>CMSCaptureFrameDelay</code></dt>
    <dd>
        A positive integer representing the number of milliseconds to wait between frames.  The default value is 500.
    </dd>
 </dl>
 @param error Error object
 @throws            NSException
 */
+(int)continuousCapture: (id<CMSContinuousCaptureDelegate>)callback parameters:(NSDictionary *)parameters error:(NSError **) error;

/*!
    @abstract Search for barcodes in the current image.
    @param barcodeTypes Barcode types to search for. See <code>CMSBarcodeType</code>.
    @param barcodeMax Maximum number of barcodes to detect. Smaller numbers reduce detection time.
    @return A NSArray of NSDictionary objects representing the barcode. The NSDictionary contains the following keys:
    <dl>
        <dt>Key=<code>CMSBarcodeConfidence</dt>
        <dd>
            A long value representing the barcode decoding confidence ranging from 0 - 100. 100 is extremely certain.
        </dd>
        <dt>Key=<code>CMSBarcodePosition</dt>
        <dd>
            An NSArray of NSValue objects containing CGPoint structures in clockwise order with the first point being the top left.
        </dd>
        <dt>Key=<code>CMSBarcodeText</dt>
        <dd>
            A NSString representing the barcode value.
        </dd>
        <dt>Key=<code>CMSBarcodeType</dt>
        <dd>
            A String representing the barcode type.
        </dd>
    </dl>
 */
+(NSArray *)detectBarcodes:(NSArray *)barcodeTypes barcodeMax:(int)barcodeMax;

/*!
    @abstract Return an identifier for the device.
    @discussion This string is not guaranteed to be unique.  It is made up of one or more important identifiers available on the device.
    @return Identifier for the device.
 */
+(NSString *)deviceId;

/*!
    @abstract Toggles an undo buffer capable of storing one change.
    @discussion The undo buffer stores one image used by @link //apple_ref/occ/clm/CMSCaptureImage/undoImageChanges @/link to restore the previous image. Disabling wll also clear the undo buffer and associated memory. This functionality could be used to implement a slider for a brightness control. The undo buffer can be freed with @link //apple_ref/occ/clm/CMSCaptureImage/clearUndoImage @/link. These operations can be restored by the undo buffer:
    <ul>
        <li>@link //apple_ref/occ/clm/CMSCaptureImage/applyFilters:parameters: @/link</li>
        <li>@link //apple_ref/occ/clm/CMSCaptureImage/loadFromBytes:error: @/link</li>
        <li>@link //apple_ref/occ/clm/CMSCaptureImage/loadFromFile:error: @/link</li>
        <li>@link //apple_ref/occ/clm/CMSCaptureImage/showQuadrilateralCrop:parameters: @/link</li>
    </ul>
    @param undo YES to enable; NO to disable.
 */
+(void)enableUndoImage:(BOOL)undo;

/*!
    @abstract Returns encoded bytes representing the image.
    @discussion The encoding could be one of JPG, PNG, or TIFF.  TIFF encoding only supports binary images.
    @param encoding Must be one of the following: <code>CMSSaveJpg</code>, <code>CMSSavePng</code>, or <code>CMSSaveTiff</code>.
    @param parameters The encoding parameters depend on the encoding:
    <dl>
  		<dt>Key=<code>CMSSaveDpiX</code></dt>
  		<dd>
            See the <code>CMSSaveDpiX</code> key in @link //apple_ref/occ/clm/CMSCaptureImage/saveToFile:encoding:parameters:error: @/link.
  		</dd>
  		<dt>Key=<code>CMSSaveDpiY</code></dt>
  		<dd>
            See the <code>CMSSaveDpiY</code> key in @link //apple_ref/occ/clm/CMSCaptureImage/saveToFile:encoding:parameters:error: @/link.
  		</dd>
  		<dt>Key=<code>CMSSaveJpgQuality</code></dt>
  		<dd>
            See the <code>CMSSaveJpgQuality</code> key in @link //apple_ref/occ/clm/CMSCaptureImage/saveToFile:encoding:parameters:error: @/link.
        </dd>
    </dl>
    @param error Error object.
    @return The encoded bytes or nil if an error occurred.
 */
+(NSData *)encodeForFormat:(NSString *)encoding parameters:(NSDictionary *)parameters error:(NSError **)error;

/*!
    @abstract Scales down the image to reduce image pixel data and show in mobile device.  
    @discussion Scales an image (or a portion of it) down to a bitmap. By scaling down, you
                reduce an image’s memory footprint without losing accuracy for better viewing on mobile
                device screens.  Note: The original image data in internal memory is not affected.
    @param width Width (in pixels) to which to scale rect.
    @param height Height (in pixels) to which to scale rect.
    @param rect Specifies the rectangular portion of the source image to use as the bitmap.
				To use the full size of the source image, specify 0 for either the width or height of rect.
    @return The scaled-down, native bitmap.
 */
+(UIImage *)imageForDisplayWithWidth:(int)width height:(int)height rect:(CGRect)rect;

/*!
 @abstract Converts a point on a captured image to its on-screen equivalent.
 @discussion Point conversion is only valid while the SDK-supplied camera view is displayed.
 @param point The point in image coordinates to convert.
 @return The converted point.
 */
+(CGPoint)imagePointToView:(CGPoint)point;

/*!
    @abstract Returns properties of the image.
    @return Image properties.  These are as follows:
    <dl>
  		<dt>Key=<code>CMSImagePropertyWidth</code></dt>
  		<dd>An integer that represents the width in pixels.</dd>
  		<dt>Key=<code>CMSImagePropertyHeight</code></dt>
  		<dd>An integer that represents the height in pixels.</dd>
  		<dt>Key=<code>CMSImagePropertyChannels</code></dt>
  		<dd>An integer that represents the number of color channels.</dd>
  		<dt>Key=<code>CMSImagePropertyBitsPerPixel</code></dt>
  		<dd>An integer that represents the number of bits per pixel.</dd>
    </dl>
 */
+(NSDictionary *)imageProperties;

/*!
 @abstract Returns the last error generated by the SDK.
 @discussion The error is cleared at the beginning of every API call except this one.
 @return An object containing error information or nil if the last operation produced no error.
 */
+(NSError*)lastError;

/*!
    @abstract Initializes the private memory state with new image file data. 
    @discussion Supports images created by  @link //apple_ref/occ/clm/CMSCaptureImage/saveToFile:encoding:parameters:error: @/link, @link //apple_ref/occ/clm/CMSCaptureImage/encodeForFormat:parameters:error: @/link, and @link //apple_ref/occ/clm/CMSCaptureImage/takePicture:parameters:error: @/link.  Call this method to set the image data to be used. Any data passed will overwrite any previous data.
    @param encodedBytes Encoded bytes.
    @param error Error object
    @return NO if not successful.  The error object will contain further information.
    @throws NSException 
 */
+(BOOL)loadFromBytes:(NSData *)encodedBytes error:(NSError **)error;

/*!
    @abstract Call to load the image data from a file into private memory state.  
    @discussion Supports images created by  @link //apple_ref/occ/clm/CMSCaptureImage/saveToFile:encoding:parameters:error: @/link, @link //apple_ref/occ/clm/CMSCaptureImage/encodeForFormat:parameters:error: @/link, and @link //apple_ref/occ/clm/CMSCaptureImage/takePicture:parameters:error: @/link.  Call this method to set the image data to be used. Any data passed will overwrite any previous data.
    @param filePath The full path to the file to load.
    @param error Error object
    @return NO if not successful.  The error object will contain further information.
    @throws NSException 
 */
+(BOOL)loadFromFile:(NSString *)filePath error:(NSError **)error;

/*!
 @abstract Search for the four corners of a quadrilateral.
 @return An NSArray of NSValue objects containing CGPoint structures in clockwise order with the first point being the top left. An empty set will be returned if the corners cannot be determined.
 */
+(NSArray *)quadrilateralCropCorners;

/*!
 @abstract Measures the quality of the current image.
 @discussion The assessments listed in the <code>assessments</code> argument will be measured, each returning a value 0-100. These are then combined into a single weighted average to produce a value in the range 0-100. The weightings are normalized so that, for example, weightings of 4 and 1 are the same as weightings of 80 and 20. Any weighting outside the range 1-100 will be ignored. If the <code>assessments</code> argument is empty or contains only invalid values, the return value is 100.
 @param assessments Dictionary with assesment names (NSString) as the key and weightings (NSNumber) as the value.  The names can be any combination of:
 <dl>
 <dt><code>CMSMeasureGlare</code></dt>
 <dd>This determines the significance of the glare spot in the image, if any. Smaller values indicate more glare. Binary images and images without glare return 100.
 </dd>
 <dt><code>CMSMeasureQuadrilateral</code></dt>
 <dd>This determines whether there a quadrilateral detected in the image and if so, its size. Larger values indicate a larger quadrilateral. Images with no detected quadrilateral return 0.
 </dd>
 <dt><code>CMSMeasurePerspective</code></dt>
 <dd>This determines whether there a quadrilateral detected in the image and if so, its distortion. Larger values corners that are more square. Images with no detected quadrilateral return 0.
 </dd>
 </dl>
 @param assessments The assessments to use and their weights.
 */
+(int)measureQuality:(NSDictionary *)assessments;

/*!
    @abstract Call to save the image to a file.
    @discussion The encoding could be one of JPG, PNG, or TIFF.  TIFF encoding only supports binary images.
    @param filePath The full path to the file to which to save the image. May be <code>nil</code> if <code>CMSSaveToGallery</code> is <code>YES</code>.
    @param encoding Must be one of the following: <code>CMSSaveJpg</code>, <code>CMSSavePng</code>, or <code>CMSSaveTiff</code>.
    @param parameters The encoding parameters depend on the encoding:
    <dl>
        <dt>Key=<code>CMSSaveDpiX</code></dt>
        <dd>
             Set the horizontal resolution in dots per inch in the metadata. If both resolution keys are not provided and the aspect ratio is between 1.2 and 1.5 then the resolution will be calculated from a letter sized page (8.5" x 11"). 200 will be used if the aspect ratio is out of that range. If only one key is provided then the other key is set to that value.
        </dd>
        <dt>Key=<code>CMSSaveDpiY</code></dt>
        <dd>
            Set the vertical resolution in dots per inch in the metadata. If both resolution keys are not provided and the aspect ratio is between 1.2 and 1.5 then the resolution will be calculated from a letter sized page (8.5" x 11"). 200 will be used if the aspect ratio is out of that range. If only one key is provided then the other key is set to that value.
        </dd>
        <dt>Key=<code>CMSSaveJpgQuality</code></dt>
        <dd>
             This is an integer that set the quality factor for compression. Acceptable
             values are 0 (poor quality but maximum compression) to 100 (Best quality but little or no compression).
             If not provided then 95 will be used.
        </dd>
        <dt>Key=<code>CMSSaveToGallery</code></dt>
        <dd>
             A BOOL that indicates whether the image is to be saved to the gallery rather than a file. If set to <code>YES</code>, the <code>filePath</code> parameter is ignored.
        </dd>
        <dt>Key=<code>CMSSaveToGalleryCompletionSelector</code></dt>
        <dd>
             A selector that indicates the callback to execute when the image is saved to the gallery rather than a file. The value is ignored unless <code>CMSSaveToGalllery</code> is set to <code>YES</code>. If set, the value must be an <code>NSValue</code> wrapping a <code>SEL</code> where the method signature is that of the selector for the iOS method <code>UIImageWriteToSavedPhotosAlbum</code>.
        </dd>
        <dt>Key=<code>CMSSaveToGalleryCompletionTarget</code></dt>
        <dd>
             The <code>id</code> of an object whose selector is called if <code>CMSSaveToGalleryCompletionSelector</code> is set and <code>CMSSaveToGalllery</code> is <code>YES</code>. The value is ignored otherwise.
        </dd>
        <dt>Key=<code>CMSSaveToGalleryContext</code></dt>
        <dd>
             The context passed to the selector if <code>CMSSaveToGalleryCompletionSelector</code> is set and <code>CMSSaveToGalllery</code> is <code>YES</code>. The value is ignored otherwise. If set, the value must be an <code>NSValue</code> wrapping a <code>void*</code>
        </dd>
    </dl>
    @param error The error object for the operation. If the function is used to save the image to the gallery, this return value is that from launching the save operation; if the operation fails, its error is passed to the completion selector.
    @return NO if not successful.  The error object will contain further information.
    @throws NSException
 */
+(BOOL)saveToFile:(NSString *)filePath encoding:(NSString *)encoding parameters:(NSDictionary *)parameters error:(NSError **)error;

/*!
 @abstract Present the quadrilateral crop user interface.
 @param callback	The callback that will be called when the crop operation is completed. Mandatory (must not be nil).
 @param parameters	Parameters that control the presentation of the user interface. The following key=value parameters are supported:
 <dl>
    <dt>Key=<code>CMSCropContext</code></dt>
    <dd>
        A UIViewController object from which showQuadrilateralCrop() was invoked.
        takePicture() presents its UIViewController using the CMSCropContext object,
        and then transitions back to this object when the crop operation is completed.
        This parameter is mandatory and must not be nil.
    </dd>
    <dt>Key=<code>CMSCropColor</code></dt>
    <dd>
        The UIColor to use for the lines and circles. The default value is blue.
    </dd>
    <dt>Key=<code>CMSCropLineWidth</code></dt>
    <dd>
        The width in pixels of the lines and circles.  The default value is 4.
    </dd>
    <dt>Key=<code>CMSCropCircleRadius</code></dt>
    <dd>
        The radius of the circles at the corners.  A value less than 1 produces no circles.  The default value is 24.
    </dd>
    <dt>Key=<code>CMSCropShadeBackground</code></dt>
    <dd>
        If YES then the area that will be cropped away is shaded a darker gray than the area to be kept.  If NO then no shading is done.  The default value is YES.
    </dd>
 </dl>
 @throws NSException 
*/
+(void)showQuadrilateralCrop:(id<CMSCropDelegate>)callback parameters:(NSDictionary*)parameters;

/*!
    @abstract Returns an encoded JPEG byte array from the captured image.
    @param callback		The callback that will be called when a picture is taken. Mandatory (must not be nil).
    @param parameters	Parameters that control the capture. The following key=value parameters are supported:
    <dl>
        <dt>Key=<code>CMSTakePictureContext</code></dt>
        <dd>
            A UIViewController object from which takePicture() was invoked. 
            takePicture() presents its UIViewController using the CMSTakePictureContext object, 
            and then transitions back to this object when the picture is taken or cancelled.
            This parameter is mandatory and must not be nil.
        </dd>
 		<dt>Key=<code>CMSTakePictureEdgeLabel</code></dt>
  		<dd>
  			The edge label displays the provided text on the camera overlay on the long edge side
  			of the phone. This is useful for displaying some instructional information to the user.
  			If not provided, then nothing will be displayed. The text will be truncated to
  			150 characters.  The text will remain on screen until the capture button is selected.
  		</dd>
  		<dt>Key=<code>CMSTakePictureCenterLabel</code></dt>
  		<dd>
  			The center label displays the provided text in the middle of the screen.
  			If not provided, then nothing will be displayed. The text will be truncated to
  			150 characters.  The text will remain on screen until the capture button is selected.
  		</dd>
  		<dt>Key=<code>CMSTakePictureCaptureLabel</code></dt>
  		<dd>
  			The capture label displays the provided text in the middle of the screen.
  			If not provided, then nothing will be displayed. The text will be truncated to
  			150 characters.  The text is displayed after the user selects the capture button and
            remains until the picture is taken.
  		</dd>
  		<dt>Key=<code>CMSTakePictureSensors</code></dt>
  		<dd>
  			Provides control over the sensors that will be displayed and used for determining the
            optimal picture-taking conditions (see the description for <code>CMSTakePictureOptimalConditions</code>.  If not
  			provided, the default is "FM", which means all physical sensors will be displayed. This
  			can be any combination of the following characters:
  			<ul>
  				<li>'F' = Focus sensor.</li>
  				<li>'M' = Motion sensor.</li>
                <li>'Q' = Quality sensor.</li>
  			</ul>
  		</dd>
  		<dt>Key=<code>CMSTakePictureMotionSensitivity</code></dt>
  		<dd>
            The amount of motion that can be tolerated by the motion sensor.  A 0.0 float value
  			indicates that absolutely no motion can be tolerated while 10.0 indicates that a
  			large amount of motion can be tolerated.  The default is 0.30.
  		</dd>
        <dt>Key=<code>CMSTakePictureQualityMeasures</code></dt>
        <dd>
            A NSDictionary object to enable image quality detection.  See <code>assessments</code> in @link //apple_ref/occ/clm/CMSCaptureImage/measureQuality: @/link.  Not meeting the quality level displays the quality sensor icon.
        </dd>
  		<dt>Key=<code>CMSTakePictureCaptureTimeout</code></dt>
  		<dd>
  			A positive integer representing the maximum number of milliseconds to wait for optimal conditions before taking the picture.  See the description for <code>CMSTakePictureOptimalConditions</code>.  A value of
  			0 indicates no wait. The default value is 0.
  		</dd>
  		<dt>Key=<code>CMSTakePictureCaptureDelay</code></dt>
  		<dd>
  			A positive integer representing the number of milliseconds to wait from the time that the user 
            selects the capture button to when the picture is taken.  The default value is 500.
  		</dd>
  		<dt>Key=<code>CMSTakePictureOptimalConditions</code></dt>
  		<dd>
  			If true, then the sensors as indicated in <code>CMSTakePictureSensors</code> and their corresponding thresholds (as specified in <code>CMSTakePictureMotionSensitivity</code>) must be satisfied before the user is allowed to take a picture. If focus is one of the sensors indicated in <code>CMSTakePictureSensors</code>, then the picture must be in focus. Furthermore, if <code>CMSTakePictureCaptureTimeout</code> has been exceeded, then @link //apple_ref/c/func/onPictureCanceled: @/link is called.
            The default value is NO.
  		</dd>
  		<dt>Key=<code>CMSTakePictureGuidelines</code></dt>
  		<dd>
  			Boolean value to toggle display of guidelines.  The default value is NO.
  		</dd>
  		<dt>Key=<code>CMSTakePictureCancelButton</code></dt>
  		<dd>
  			Boolean value to toggle display of cancel button.  The default value is NO.
  		</dd>
        <dt>Key=<code>CMSTakePictureTorchButton</code></dt>
        <dd>
            Boolean value to toggle display of torch button.  The default value is NO.
        </dd>
        <dt>Key=<code>CMSTakePictureTorch</code></dt>
        <dd>
            Boolean value to toggle torch mode.  The default value is NO.
        </dd>
        <dt>Key=<code>CMSTakePictureImmediately</code></dt>
        <dd>
            Boolean value to take a picture immediately without requiring a button click.  The default value is NO.
        </dd>
        <dt>Key=<code>CMSTakePictureCrop</code></dt>
        <dd>
            NSValue object holding a CGSize defining the dimension guides which the image will be cropped to.  A special value, <code>CMSTakePictureCropVisible</code>, will be used to trim the image to what is visible in the current view.
        </dd>
        <dt>Key=<code>CMSTakePictureCropWarning</code></dt>
        <dd>
            An UIColor object defining the warning color of the dimension guide.  The default value is red.
        </dd>
        <dt>Key=<code>CMSTakePictureCropOk</code></dt>
        <dd>
            An UIColor object defining the OK color of the dimension guide.  The default value is green.
        </dd>
        <dt>Key=<code>CMSTakePictureCropProcessing</code></dt>
        <dd>
            An UIColor object defining the processing color of the dimension guide.  The default value is yellow.
        </dd>
        <dt>Key=<code>CMSTakePictureCaptureWindow</code></dt>
        <dd>
            A class instance derived from <code>CMSCaptureWindow</code> to replace the default camera overlay.
        </dd>
        <dt>Key=<code>CMSTakePictureReturnMode</code></dt>
        <dd>
            The actions to take after the picture is taken. The value can be a bitwise-or combination of the following. If omitted, the value  <code>CMSTakePictureReturnCallback</code> is used.
            <ul>
                <li><code>CMSTakePictureReturnCallback</code> - return the image through the callback.</li>
                <li><code>CMSTakePictureReturnFile</code> - save the image to the directory identified by <code>CMSTakePicureSaveTo</code>. The full path to the file is returned through the callback.</li>
                <li><code>CMSTakePictureReturnLoad</code> - load the image into the processing buffer.</li>
            </ul>
        </dd>
        <dt>Key=<code>CMSTakePictureSaveTo</code></dt>
        <dd>
            The path to the directory where taken pictures will be saved if the return mode includes <code>CMSTakePictureReturnFile</code>.
        </dd>
    </dl>
    @throws NSException
 */
+(BOOL)takePicture:(id<CMSImageDelegate>)callback parameters:(NSDictionary*)parameters error:(NSError**)error;

/*!
 @abstract Undo the previous image change.
 @discussion The image in the undo buffer replaces the current image. This restores the previous state.
 @param error Optional error object.
 @return YES if the changes were reverted; NO if undo was not enabled, no image was loaded, or operation cannot be undone.  The error object will contain further information.
 */
+(BOOL)undoImageChanges:(NSError **) error;

/*!
 @abstract Returns the version of the toolkit.
 @return NSString object representing the version of the toolkit.
 */
+(NSString *)version;
@end
