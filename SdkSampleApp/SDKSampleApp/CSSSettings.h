//
//  Copyright (c) 2013-2016 EMC Corporation.  All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * Settings wrapper
 * Wrapper around settings class to get values and register defaults.
 */
@interface CSSSettings : NSObject

+(NSNumber *)integerForKey:(NSString *)defaultName;

+(NSNumber *)boolForKey:(NSString *)defaultName;

+(BOOL)boolScalarForKey:(NSString *)defaultName;

+(NSString *)stringForKey:(NSString *)defaultName;

+(NSNumber*)floatForKey:(NSString *)defaultName;

+(float)floatScalarForKey:(NSString *)defaultName;

+(UIColor *)uiColorForKey:(NSString *)prefixName;

+(void)registerDefaults;

+(BOOL)license;
@end
