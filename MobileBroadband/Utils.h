//
//  Utils.h
//  MobileBroadband
//
//  Created by Медведь on 27.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Utils : NSObject

+ (NSString *)trim:(NSString *)str;	
+ (BOOL)isEmptyString:(NSString *) str; 
+ (BOOL)isDigitCString:(char *)str;

+ (NSArray *)getComponentsSeparated:(NSString *)string separator:(NSString *)separator;

+ (NSString *)getErrorMessage:(NSString *)errorMessage withError:(NSError *)error;
+ (NSString *)getErrorMessage:(NSString *)errorMessage withException:(NSException *)exception;


+ (NSString *)getPathInBundleWithFileName:(NSString *)fileName;
+ (NSString *)getPathInDocumentWithFileName:(NSString *)fileName;
+ (NSString *)getPathInTempWithFileName:(NSString *)fileName;

+ (BOOL)deleteFile:(NSString *)path;
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
