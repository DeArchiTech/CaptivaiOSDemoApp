//
//  Copyright (c) 2015-2016 EMC Corporation.  All rights reserved.
//

#ifndef SDK_Sample_App_CSSCustomWindow_h
#define SDK_Sample_App_CSSCustomWindow_h

#import <CMSCaptureWindow.h>

const int CSSCustomNone = 0;
const int CSSCustomExtend = 1;
const int CSSCustomReplace = 2;

@interface CSSCustomWindow : CMSCaptureWindow

-(id) initWithMode:(int)mode motion:(BOOL)motion quads:(BOOL)quads;

-(void) viewDidLoad;
-(void) onSensorChange:(NSInteger)sensor valid:(BOOL)valid data:(NSArray*)data;
-(void) onShowCaptureMode:(int)mode;
-(void) viewWillLayoutSubviews;
-(void) flash;

@end


#endif
