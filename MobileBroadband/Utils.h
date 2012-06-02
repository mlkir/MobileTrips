//
//  Utils.h
//  MobileBroadband
//
//  Created by Медведь on 27.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PATH_RESOURCE           @"resources"
#define PATH_CONTENT            @"content"
#define FILENAME_ZIP            @"default_%@.zip"
#define FILENAME_ZIP_DEFAULT    @"default_en.zip"

//Начало гиперссылки при возврате колбэка из JavaScript
#define LINK_JS_CALLBACK_START_WITH @"callback:"

//Локализация
#define LocalizedString(key) [Utils getLocalizedStringForKey:(key)]

@interface Utils : NSObject

+ (NSString *)trim:(NSString *)str;	
+ (BOOL)isEmptyString:(NSString *) str; 
+ (BOOL)isDigitCString:(char *)str;
+ (NSString *)getHtmlWithBody:(NSString *)body;

+ (NSArray *)getComponentsSeparated:(NSString *)string separator:(NSString *)separator;

+ (NSString *)getErrorMessage:(NSString *)errorMessage withError:(NSError *)error;
+ (NSString *)getErrorMessage:(NSString *)errorMessage withException:(NSException *)exception;


+ (NSString *)getPathContent:(NSString *)pathComponent;
+ (NSString *)getPathInBundle:(NSString *)pathComponent;
+ (NSString *)getPathInDocument:(NSString *)pathComponent;
+ (NSString *)getPathInTemp:(NSString *)pathComponent;

+ (BOOL)deletePath:(NSString *)path;
+ (NSString *)loadFromFile:(NSString *)path;  
+ (BOOL)saveToFile:(NSString *)path dataString:(NSString *)stringWithData;

//+ (NSDate *)dateFromCString:(const char *)strDate;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)strDate;

+ (BOOL)isIPhone;

+ (NSString *)getSystemLanguage;
+ (NSString *)getCurrentLocale;
+ (void)loadLocalizableStrings;
+ (NSString *)getLocalizedStringForKey:(NSString *)key;

+ (UIColor *)getColorWithRed:(int)red green:(int)green blue:(int)blue;
+ (UIFont *)getFont;

+ (int)getFontSizeIndex;
+ (int)getFontNameIndex;
+ (void)setFontSizeIndex:(int)idx;
+ (void)setFontNameIndex:(int)idx;

+ (UIImageView *)newBackgroundView;


+ (NSURL *)getBaseURL;
+ (void)loadWebView:(UIWebView *)webView loadHtml:(NSString *)html;
+ (void)loadWebView:(UIWebView *)webView loadContentFile:(NSString *)fileName;

@end
