//
//  Utils.h
//  MobileBroadband
//
//  Created by Медведь on 27.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PATH_RESOURCE           @"resources"
#define FILENAME_ZIP            @"default_%@.zip"
#define FILENAME_ZIP_DEFAULT    @"default_ru.zip"

//Начало гиперссылки при возврате колбэка из JavaScript
#define LINK_JS_CALLBACK_START_WITH @"callback:"


@interface Utils : NSObject

+ (NSString *)trim:(NSString *)str;	
+ (BOOL)isEmptyString:(NSString *) str; 
+ (BOOL)isDigitCString:(char *)str;
+ (NSString *)getHtmlWithBody:(NSString *)body;

+ (NSArray *)getComponentsSeparated:(NSString *)string separator:(NSString *)separator;

+ (NSString *)getErrorMessage:(NSString *)errorMessage withError:(NSError *)error;
+ (NSString *)getErrorMessage:(NSString *)errorMessage withException:(NSException *)exception;


+ (NSString *)getPathInBundle:(NSString *)pathComponent;
+ (NSString *)getPathInDocument:(NSString *)pathComponent;
+ (NSString *)getPathInTemp:(NSString *)pathComponent;

+ (BOOL)deletePath:(NSString *)path;
+ (NSString *)loadFromFile:(NSString *)path;  
+ (BOOL)saveToFile:(NSString *)path dataString:(NSString *)stringWithData;

//+ (NSDate *)dateFromCString:(const char *)strDate;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)strDate;

+ (NSString *)getCurrentLanguage;

+ (NSURL *)getBaseURL;

+ (UIFont *)getFont;

+ (int)getFontSizeIndex;
+ (int)getFontNameIndex;
+ (void)setFontSizeIndex:(int)idx;
+ (void)setFontNameIndex:(int)idx;

@end
