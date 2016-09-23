//
//  Copyright (c) 2015-2016 EMC Corporation.  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CMSCaptureImage.h>
#import <CMSConstants.h>
#import <algorithm>
#import "CSSCustomWindow.h"
#import "CSSUtils.h"

@implementation CSSCustomWindow {
    int _mode;
    int _useMotion;
    BOOL _quads;
    int _statusBarHeight;
    
    // "extend" mode items
    UILabel *_customLabel;
    
    // "replace" mode items
    UIButton *_captureButton;
    UIButton *_cancelButton;
    UIView *_cropView;
    UIView *_bubbleView;
    UIView *_flashView;
    CAShapeLayer *_bubbleCircle;
    CAShapeLayer *_bubbleDot;
    CGFloat _bubbleRadius;
    
    // elements for showing the detected quadrilateral
    UIView *_quadView;
    CAShapeLayer *_quadLayer;
}

/**
 * Creates a custom capture window in either "replace" or extend mode
 * @param mode   A value that indicates whether the standard UI will be replaced by the custom window, extended, or used as is
 * @param motion YES if the motion sensor is in use
 * @param quads  YES if quadrilateral detection is in use
 * @return The custom window
 */
-(id)initWithMode:(int)mode motion:(BOOL)motion quads:(BOOL)quads {
    if ((self = [super init])) {
        _mode = mode;
        _useMotion = motion;
        _quads = quads;
    }
    
    return self;
}

/**
 * Configure the window (used by the Cordova sample app)
 * @param parameters A dictionary of values for the mode, motion sensor, and quad detection
 */
-(void) configure:(NSDictionary*)parameters
{
    _mode = [[parameters objectForKey:@"mode"] intValue];
    _useMotion = [[parameters objectForKey:@"motion"] boolValue];
    _quads = [[parameters objectForKey:@"quads"] boolValue];
}

/**
 * Create the custom UI elements
 */
-(void) viewDidLoad {
    UIView* root = [self view];
    
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    if (orient == UIInterfaceOrientationLandscapeLeft || orient == UIInterfaceOrientationLandscapeRight) {
        _statusBarHeight = statusBarSize.width;
    } else {
        _statusBarHeight = statusBarSize.height;
    }
    
    // add the quad view first so that it sits below the buttons in all cases
    _quadView = [[UIView alloc] initWithFrame:root.frame];
    _quadLayer = [CAShapeLayer layer];
    _quadLayer.lineWidth = 4.0f;
    _quadLayer.strokeColor = [UIColor blueColor].CGColor;
    _quadLayer.fillColor = [UIColor clearColor].CGColor;
    [_quadView.layer addSublayer:_quadLayer];
    [root addSubview:_quadView];
    
    // If we are not in "replace" mode, call the base class to render the default
    if (_mode != CSSCustomReplace) {
        [super viewDidLoad];
    }
    
    if (_mode == CSSCustomReplace) {
        [self loadReplaceView];
    } else if (_mode == CSSCustomExtend) {
        [self loadExtendView];
    }
}

-(void) centerCustomLabel {
    UIView *rootView = [self view];
    CGRect viewRect = rootView.bounds;
    _customLabel.center = CGPointMake(viewRect.origin.x + viewRect.size.width / 2,
                                      viewRect.origin.y + viewRect.size.height / 2);
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGSize rootSize = [self view].bounds.size;
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;

    // Recenter the custom label if we have one ("extend" mode only)
    if (_customLabel) {
        [self centerCustomLabel];
    }
    
    // Reposition the crop view, capture, and cancel buttons ("replace" mode only)
    if (_cropView && _captureButton && _cancelButton) {
        BOOL horizontal = orient == UIInterfaceOrientationLandscapeLeft ||
        orient == UIInterfaceOrientationLandscapeRight;
        
        // Reposition the labels depending on the orientation
        CGSize capSize = _captureButton.bounds.size;
        CGSize cancelSize = _cancelButton.bounds.size;
        CGFloat maxWidth = std::max(capSize.width, cancelSize.width);
        CGFloat maxHeight = std::max(capSize.height, cancelSize.height);
        
        if (horizontal) {
            _captureButton.center = CGPointMake(rootSize.width - maxWidth / 2 - 2,
                                                rootSize.height / 2 - capSize.height / 2 - 4);
            _cancelButton.center = CGPointMake(rootSize.width - maxWidth / 2 - 2,
                                                rootSize.height / 2 + cancelSize.height / 2 + 4);
        } else {
            _cancelButton.center = CGPointMake(rootSize.width / 2 - cancelSize.width / 2 - 4,
                                                rootSize.height - maxHeight / 2 - 2);
            _captureButton.center = CGPointMake(rootSize.width / 2 + capSize.width / 2 + 4,
                                                rootSize.height - maxHeight / 2 - 2);
        }
        
        // Reposition the crop view by finding a non-overlapping region and requesting it
        CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
        if (horizontal) {
            statusBarSize = CGSizeMake(statusBarSize.width, statusBarSize.width);
        }
        CGRect cropZone = CGRectMake(0,
                                     statusBarSize.height,
                                     rootSize.width - (horizontal ? maxWidth : 0),
                                     rootSize.height - statusBarSize.height - (horizontal ? 0 : maxHeight));
        cropZone = CGRectInset(cropZone, 8, 8);
        CGRect cropRect = [self setCropZoneForPreview:cropZone];
        _cropView.bounds = CGRectMake(0, 0, cropRect.size.width, cropRect.size.height);
        _cropView.center = CGPointMake(cropRect.origin.x + cropRect.size.width / 2,
                                       cropRect.origin.y + cropRect.size.height / 2);
    }

    // Reposition the bubble view ("replace" mode only)
    if (_bubbleView) {
        _bubbleView.center = CGPointMake(rootSize.width - _bubbleRadius - 2,
                                         _statusBarHeight + _bubbleRadius + 2);
    }
    
    // Reposition the quad view
    if (_quadView) {
        _quadView.bounds = [self view].bounds;
        _quadView.center = [self view].center;
    }
}

/**
 * Respond to changes in sensor data
 */
-(void) onSensorChange:(NSInteger)sensor valid:(BOOL)valid data:(NSObject*)data {
    // If we are not replacing the view completely, forward the change to the base class
    if (_mode != CSSCustomReplace) {
        [super onSensorChange:sensor valid:valid data:data];
    }
    
    if (sensor == CMSSensorMovement) {
        [self onMotion:(CMDeviceMotion*)data];
    }
    
    if (sensor == CMSSensorQuality && _quads) {
        [self onQuality:data valid:valid];
    }
}

/**
 * When the motion sensor changes, update the custom label and bubble level
 */
-(void) onMotion:(CMDeviceMotion*)motion {
    if (!motion) {
        return;
    }
    
    // Update the text in the custom label ("extend" mode only)
    if (_customLabel && !_customLabel.hidden) {
        _customLabel.text = [NSString stringWithFormat:@"x:%.2f\r\ny:%.2f\r\nz:%.2f",
                             motion.userAcceleration.x * 9.81,
                             motion.userAcceleration.y * 9.81,
                             motion.userAcceleration.z * 9.81];
    }
    
    // Update the bubble position and color ("replace" mode only)
    if (_bubbleView) {
        // Get the x and y offsets for the bubble, limiting them to the edge of the circle
        CGFloat x = -(motion.userAcceleration.x + motion.gravity.x) * _bubbleRadius;
        x = std::max(-_bubbleRadius, std::min(x, _bubbleRadius));
        CGFloat y = (motion.userAcceleration.y + motion.gravity.y) * _bubbleRadius;
        y = std::max(-_bubbleRadius, std::min(y, _bubbleRadius));
        
        // Transform the offsets based on the device orientation
        UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
        if (orient == UIInterfaceOrientationLandscapeLeft) {
            CGFloat tmp = x;
            x = -y;
            y = tmp;
        } else if (orient == UIInterfaceOrientationLandscapeRight) {
            CGFloat tmp = x;
            x = y;
            y = -tmp;
        }
        
        // Update the bubble position and level color
        _bubbleDot.position = CGPointMake(x, y);
        CGColor* color = fabs(x) <= 5 && fabs(y) <= 5 ? [UIColor greenColor].CGColor : [UIColor whiteColor].CGColor;
        _bubbleDot.strokeColor = _bubbleDot.fillColor = color;
        _bubbleCircle.strokeColor = color;
    }
}

/**
 * When the quality sensor changes, update the quadrilateral overlay
 */
-(void) onQuality:(id)obj valid:(BOOL)valid {
    NSDictionary *dict = obj;
    NSArray *corners = dict ? [dict objectForKey:CMSQualityCorners] : nil;
    CSSLog(@"corners: %@", corners);
    [self setQuadCorners:corners valid:valid];
}

/**
 * When corners are updated, redraw the quadrilateral overlay
 */
-(void) setQuadCorners:(NSArray *)corners valid:(BOOL)valid {
    if (!_quads) {
        return;
    }

    if (!corners || corners.count != 4) {
        _quadLayer.hidden = YES;
        return;
    }

    _quadLayer.hidden = NO;
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    CGPoint points[4];
    for (int i=0; i<4; i++) {
        NSValue* value = [corners objectAtIndex:i];
        CGPoint pt = [value CGPointValue];
        points[i] = [CMSCaptureImage imagePointToView:pt];
    }
    
    // draw the box
    [path moveToPoint:points[3]];
    for (int i = 0; i < 4; i++) {
        [path addLineToPoint:points[i]];
    }
    
    //draw the circles
    for (int i = 0; i < 4; i++) {
        [path moveToPoint:CGPointMake(points[i].x + 8.0f, points[i].y)];
        [path addArcWithCenter:points[i] radius:8.0f startAngle:0 endAngle:2*M_PI clockwise:NO];
    }
    
    _quadLayer.path = path.CGPath;
    _quadLayer.strokeColor = valid ? [UIColor greenColor].CGColor : [UIColor redColor].CGColor;
}

/**
 * Show/hide the "idle" elements as appropriate
 */
- (void)onShowCaptureMode:(int)mode {
    if (_customLabel) {
        _customLabel.hidden = mode != CMSCaptureModeIdle;
    }
    
    if (_captureButton) {
        _captureButton.hidden = mode != CMSCaptureModeIdle;
    }
}

/**
 * Setup the "replace" view by adding an accelerometer reading to the screen
 */
-(void) loadReplaceView {
    UIView *rootView = [self view];
    
    // Add the crop rectangle
    CGRect cropRect = [self cropGuidelineForPreview];
    _cropView = [[UIView alloc] initWithFrame:cropRect];
    _cropView.layer.borderColor = [UIColor yellowColor].CGColor;
    _cropView.layer.borderWidth = 1;
    [rootView addSubview:_cropView];
    
    // Add the capture button
    _captureButton = [[UIButton alloc] init];
    [_captureButton setTitle:@"Capture" forState:UIControlStateNormal];
    [_captureButton sizeToFit];
    _captureButton.bounds = CGRectInset(_captureButton.bounds, -4, -4);
    _captureButton.backgroundColor = [UIColor blackColor];
    _captureButton.alpha = 0.75f;
    [_captureButton addTarget:self action:@selector(onCapture) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:_captureButton];
    
    // Add the cancel button
    _cancelButton = [[UIButton alloc] init];
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelButton sizeToFit];
    _cancelButton.bounds = CGRectInset(_cancelButton.bounds, -4, -4);
    _cancelButton.backgroundColor = [UIColor blackColor];
    _cancelButton.alpha = 0.75f;
    [_cancelButton addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:_cancelButton];
    
    // Add the bubble level if motion is in use
    if (_useMotion) {
        _bubbleRadius = std::min(rootView.bounds.size.width,
                                 rootView.bounds.size.height) * 0.1f;
        _bubbleView = [[UIView alloc] init];
        _bubbleView.bounds = CGRectMake(0, 0, 2 * _bubbleRadius, 2 * _bubbleRadius);
        _bubbleView.alpha = 0.75f;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(_bubbleRadius, _bubbleRadius) radius:_bubbleRadius startAngle:0 endAngle:2 * M_PI clockwise:NO];
        _bubbleCircle = [CAShapeLayer layer];
        _bubbleCircle.path = path.CGPath;
        _bubbleCircle.lineWidth = 4.0f;
        _bubbleCircle.strokeColor = [UIColor whiteColor].CGColor;
        _bubbleCircle.fillColor = [UIColor clearColor].CGColor;
        
        path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(_bubbleRadius, _bubbleRadius) radius:4.0f startAngle:0 endAngle:2 * M_PI clockwise:NO];
        _bubbleDot = [CAShapeLayer layer];
        _bubbleDot.path = path.CGPath;
        _bubbleDot.lineWidth = 4.0f;
        _bubbleDot.strokeColor = [UIColor whiteColor].CGColor;
        _bubbleDot.fillColor = [UIColor whiteColor].CGColor;
        
        [_bubbleView.layer addSublayer:_bubbleCircle];
        [_bubbleView.layer addSublayer:_bubbleDot];
        [rootView addSubview:_bubbleView];
    }

    // Add the element that flashes when a picture is taken
    _flashView = [[UIView alloc]init];
    _flashView.center = rootView.center;
    _flashView.bounds = rootView.bounds;
    _flashView.alpha = 0.5;
    _flashView.backgroundColor = [UIColor whiteColor];
    _flashView.userInteractionEnabled = NO;
    _flashView.hidden = YES;
    [rootView addSubview:_flashView];
}

/**
 * Setup the "extend" view by adding a label to the pre-capturing state.
 */
-(void) loadExtendView {
    _customLabel = [[UILabel alloc] init];
    _customLabel.text = @"";
    _customLabel.numberOfLines = 3;
    _customLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _customLabel.textAlignment = NSTextAlignmentCenter;
    _customLabel.textColor = [UIColor whiteColor];
    _customLabel.backgroundColor = [UIColor blackColor];
    _customLabel.alpha = 0.75f;
    
    CGSize size = [@"x:-10.00" sizeWithFont:_customLabel.font];
    _customLabel.bounds = CGRectMake(0, 0, size.width, 3 * size.height);
    
    [self centerCustomLabel];
    [[self view] addSubview:_customLabel];
}

/**
 * Handle the custom capture button click event
 */
-(void) onCapture {
    [self beginTakePicture];
}

/**
 * Handle the custom cancel button click event
 */
-(void) onCancel {
    [self cancelPicture:CMSCancelReasonButton];
}

-(void) flashOff {
    _flashView.hidden = YES;
}

-(void) flash {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        // bring UI processing back to the UI thread
        _flashView.hidden = NO;
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(flashOff) userInfo:nil repeats:NO];
        
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    });
}

@end
