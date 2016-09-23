//
//  Copyright (c) 2013-2016 EMC Corporation.  All rights reserved.
//

#import "CSSSettings.h"
#import "CMSCaptureImage.h"
#import "CSSUtils.h"

@implementation CSSSettings

+(NSNumber *)integerForKey:(NSString *)defaultName {
    return [NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults]integerForKey:defaultName]];
}

+(NSNumber *)boolForKey:(NSString *)defaultName {
    return [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults]boolForKey:defaultName]];
}

+(BOOL)boolScalarForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
}

+(NSString *)stringForKey:(NSString *)defaultName {
    NSString *returnValue = [[NSUserDefaults standardUserDefaults] stringForKey:defaultName];
    
    if (returnValue == nil) {
        returnValue = [NSString string];
    }
    
    return returnValue;
}

+(NSNumber*)floatForKey:(NSString *)defaultName {
    return [NSNumber numberWithFloat:[[NSUserDefaults standardUserDefaults]floatForKey:defaultName]];
}

+(float)floatScalarForKey:(NSString *)defaultName {
    return [[NSNumber numberWithFloat:[[NSUserDefaults standardUserDefaults]floatForKey:defaultName]]floatValue];
}

+(UIColor *)uiColorForKey:(NSString *)prefixName {
    UIColor *color = [UIColor colorWithRed:[CSSSettings floatScalarForKey:[prefixName stringByAppendingString:@"R"]]
                                     green:[CSSSettings floatScalarForKey:[prefixName stringByAppendingString:@"G"]]
                                      blue:[CSSSettings floatScalarForKey:[prefixName stringByAppendingString:@"B"]]
                                     alpha:1.0];
    return color;
}

+(void)registerDefaults {
    NSDictionary *appDefaults = @{@"ImageFormat" : @"Jpg",
                                  @"JPGQuality" : @95,
                                  @"SensitivityMotion": @0.3,
                                  @"CaptureTimeout": @2500,
                                  @"CaptureDelay": @500,
                                  @"CancelButton": @YES,
                                  @"TorchButton": @NO,
                                  @"Torch": @NO,
                                  @"SensorMotion": @YES,
                                  @"SensorQuality": @NO,
                                  @"QualityGlare": @0,
                                  @"QualityQuadrilateral": @0,
                                  @"QualityPerspective": @0,
                                  @"FilterForce": @YES,
                                  @"FilterBlackness": @6,
                                  @"Immediately": @NO,
                                  @"NoiseSize": @7,
                                  @"UndoLast": @NO,                                  
                                  @"Trim": @NO,
                                  @"AspectRatioX": @0,
                                  @"AspectRatioY": @0,
                                  @"CropColorOkR": @0,
                                  @"CropColorOkG": @1,
                                  @"CropColorOkB": @0,
                                  @"CropColorWarningR": @1,
                                  @"CropColorWarningG": @0,
                                  @"CropColorWarningB": @0,
                                  @"CropColorProcessingR": @1,
                                  @"CropColorProcessingG": @1,
                                  @"CropColorProcessingB": @0,
                                  @"FrameDelay": @500,
                                  @"CaptureCount": @2,
                                  @"CaptureSimilarity": @50,
                                  @"QuadCropColorR": @0,
                                  @"QuadCropColorG": @0,
                                  @"QuadCropColorB": @1,
                                  @"QuadCropRadius": @24,
                                  @"QuadCropWidth": @4,
                                  @"QuadCropShade": @YES,
                                  @"BarcodeTypeAll": @YES,
                                  @"BarcodeMax": @5};
    
    [[NSUserDefaults standardUserDefaults]registerDefaults:appDefaults];
}

+(BOOL)license {
    NSString *applicationId = [CSSSettings stringForKey:@"ApplicationIdentifier"];
    NSString *licenseCode = [CSSSettings stringForKey:@"LicenseCode"];
    BOOL result = [CMSCaptureImage addLicenseKey:applicationId license:licenseCode];

    CSSLog(@"Returning %d", result);
    
    return result;
}
@end
