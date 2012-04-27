//
//  Utils.m
//  MobileBroadband
//
//  Created by Медведь on 27.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import <sys/xattr.h>


#define EMPTY_STRING @""						//Пустая строка
#define LIST_SEPARATORS_FOR_TEXT @",. ;:"		//Разделители текста на слова
#define FORMATTER_DATE_FORMAT @"d.MM.yyyy"		//Формат даты без времени  (время:  HH:mm:ss)
#define LOCALE_EN @"en_EN"						//Английская локализация
#define IS_DIGIT(c) ('0' <= (c) && (c) <= '9')	//Проверка что символ является цифрой

@implementation Utils

static UIFont *font = nil;
static int fontSizeIndex = 1;
static int fontNameIndex = 7;

#pragma mark -
#pragma mark Утилиты для работы со строками

+ (NSString *)trim:(NSString *)str {
	return [str	stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}	

+ (BOOL)isEmptyString:(NSString *)str {
	if (str == nil) return YES;
	str = [self trim:str];
	return ([str isEqual:EMPTY_STRING]);
}


+ (BOOL)isDigitCString:(char *)str {
	if (str == nil) return NO;
	int len = strlen(str);
	if (len == 0) return NO;
	BOOL result = isdigit(str[len - 1]);
	return result;
}


+ (NSArray *)getComponentsSeparated:(NSString *)string separator:(NSString *)separator {	
	return [string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:separator]];  
}


/* Получаем текст ошибки для вывода */
+ (NSString *)getErrorMessage:(NSString *)errorMessage withError:(NSError *)error {
	if (errorMessage == nil) return nil;	
    
	NSMutableString *message = [NSMutableString stringWithString:errorMessage];		
	if (error != nil) [message appendFormat:@"\n* NSError:\n%@", error];	
	
    return message;
}

/* Получаем текст ошибки для вывода */
+ (NSString *)getErrorMessage:(NSString *)errorMessage withException:(NSException *)exception {
	if (errorMessage == nil) return nil;
	
	NSMutableString *message = [NSMutableString stringWithString:errorMessage];	
	if (exception != nil) [message appendFormat:@"\n* NSException:\n%@", exception];
	
	return message;
}

#pragma mark -
#pragma mark Утилиты для работы c файловой системой


/* Получить полный путь к файлу в папке документов (Library) */
+ (NSString *)getPathInDocumentWithFileName:(NSString *)fileName {
    static NSString *docsDir = nil;
    if (docsDir == nil) {
        //Получаем путь к папке Documents
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        docsDir = [paths objectAtIndex:0];   
        //Проверяем, есть ли там папка в которой будут храниться данные не требующие бэкапирования через iCloud
        NSString *path = [docsDir stringByAppendingPathComponent:@"PrivateData"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path]) {
            //Создаем папку
            NSError *err;
            BOOL isSuccessfully = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];            
            if (isSuccessfully) {
                //Выставляем на папку маркер для исключения из бэкапирования iCloud
                const char* attrName = "com.apple.MobileBackup";
                u_int8_t attrValue = 1;                
                int result = setxattr([path UTF8String], attrName, &attrValue, sizeof(attrValue), 0, 0);
                if (result != 0) {
                    NSLog(@"Не удалось установить атрибут '%s' на папку '%@'", attrName, path);
                }                
            } else {
                NSLog(@"Не удалось создать папку:\n%@", err);											
            }             
        }
        docsDir = path;            
        [docsDir retain]; //чтобы не удалился
    }
    return [docsDir stringByAppendingPathComponent:fileName];
}

/* Получить полный путь к файлу в папке документов */
+ (NSString *)getPathInBundleWithFileName:(NSString *)fileName { 
    NSString *pathMainBundle = [[NSBundle mainBundle] resourcePath];
    return [pathMainBundle stringByAppendingPathComponent:fileName];    
}

/* Получить полный путь к файлу во временной папке */
+ (NSString *)getPathInTempWithFileName:(NSString *)fileName {
    static NSString *tmpDir = nil;
    if (tmpDir == nil) tmpDir = [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] retain];    
    return [tmpDir stringByAppendingPathComponent:fileName];
}

+ (BOOL)deleteFile:(NSString *)path {
    BOOL isSuccessfully = YES;
    
    //Получаем файлового менеджера
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //Если файл существует
    if ([fileManager fileExistsAtPath:path]) {
        NSError *err;
        isSuccessfully = [fileManager removeItemAtPath:path error:&err];
        if (!isSuccessfully) {
            printf("Error: %s\n", [[self getErrorMessage:@"Ошибка при удалении файла" withError:err] UTF8String]);											
        }        
    }
    return isSuccessfully;
}

/* Загрузить в строку все данные из файла, кодировка  UTF-8 (если файл не найден вернет nil и в лог запишит ошибку) */
+ (NSString *)loadFromFile:(NSString *)path  {
    /*
     //Получаем файлового менеджера
     NSFileManager *fileManager = [NSFileManager defaultManager];
     
     //Если файл не найден
     if (![fileManager fileExistsAtPath:path]) {
     Logger1Error("Файл '%s' - не найден", [path UTF8String]);
     return nil;
     }
     //Получаем данные из файла      
     NSData *bufferData = [fileManager contentsAtPath:path];
     //Получаем  ввиде строки с кодировкой UTF-8
     NSString *resultString = [[NSString alloc] initWithData:bufferData encoding:NSUTF8StringEncoding];
     
     //Возвращаем результат
     return [resultString autorelease];
     */
    NSError *err;
    NSString *stringWithData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    if (stringWithData == nil) {
        printf("Error: %s\n", [[self getErrorMessage:@"Ошибка чтения из файла" withError:err] UTF8String]);											
    }
    return stringWithData;
}

/* Сохранить данные из строки в файл, кодировка  UTF-8 (если файл существует - будет перезаписан новыми данными) */
+ (BOOL)saveToFile:(NSString *)path dataString:(NSString *)stringWithData {
    //Получаем файлового менеджера
    /*NSFileManager *fileManager = [NSFileManager defaultManager];
     
     //Получаем данные из строки
     NSData *bufferData = [stringWithData dataUsingEncoding:NSUTF8StringEncoding];
     
     //Записываем в файл
     [fileManager createFileAtPath:path contents:bufferData attributes:nil];
     */
    
    NSError *err;
    BOOL isSuccessfully = [stringWithData writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (!isSuccessfully) {
        printf("Error: %s\n", [[self getErrorMessage:@"Ошибка записи в файл" withError:err] UTF8String]);											
    }
    return isSuccessfully;
}

#pragma mark -
#pragma mark Утилиты для работы с датами

/* Получить объект для преобразования строки в дату и наоборот */
+ (NSDateFormatter *)getDateFormatter {	
	static NSDateFormatter *formatter = nil;
	if (formatter == nil) {	
		formatter = [[NSDateFormatter alloc] init];
		[formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:LOCALE_EN];
		[formatter setLocale:locale];
		[locale release];
		[formatter setDateFormat:FORMATTER_DATE_FORMAT];		
	}	
	return formatter;	
}

/* Получить дату из строки d.m.yyyy (01.01.2000 или 1.1.2000) */
+ (NSDate *)dateFromString:(NSString *)strDate {
	return [[self getDateFormatter] dateFromString:strDate];
}

/* Получить строку d.m.yyyy по дате  (01.01.2000 или 1.1.2000) */
+ (NSString *)stringFromDate:(NSDate *)date {
	return [[self getDateFormatter] stringFromDate:date];
}

#pragma mark -
#pragma mark Настройки

+ (void)setFontWithNameByIndex:(int)indexName andSizeByIndex:(int)indexSize  {    
    [font release];
    
    NSString *name = [[UIFont familyNames] objectAtIndex:indexName];
    
    CGFloat size = 0.0f;
    switch (indexSize) {
        case 0: 
            size = [UIFont smallSystemFontSize];            
            break;
        case 1: 
            size = [UIFont systemFontSize];
            break;   
        default:
            size = [UIFont systemFontSize] + 4.0f;
            break;
    }
    
    font = [[UIFont fontWithName:name size:size] retain];
}

+ (UIFont *)getFont {    
    if (!font) {
        fontNameIndex = [[UIFont familyNames] indexOfObject:@"Helvetica"];
        [self setFontWithNameByIndex:fontNameIndex andSizeByIndex:fontSizeIndex];
    }
    return  font;
}

+ (int)getFontSizeIndex {
    return fontSizeIndex;
}

+ (int)getFontNameIndex {
    return fontNameIndex;
}

+ (void)setFontSizeIndex:(int)idx {
    fontSizeIndex = idx;
    [self setFontWithNameByIndex:fontNameIndex andSizeByIndex:fontSizeIndex];
}

+ (void)setFontNameIndex:(int)idx {
    fontNameIndex = idx;
    [self setFontWithNameByIndex:fontNameIndex andSizeByIndex:fontSizeIndex];
}


#pragma mark -
#pragma mark Локализация


/* Получить текущий язык (en, ru и т.д.) */
+ (NSString *)getCurrentLanguage {
    NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    return  [languages objectAtIndex:0];
}


+ (NSURL *)getBaseURL {
    return nil;
}
@end
