//
//  PSAlertDownloadUpdate.m
//  MobileBroadband
//
//  Created by Медведь on 06.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSAlertDownloadUpdate.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "DBManager.h"
#import "SSZipArchive.h"
#import "PSParamModel.h"


@implementation PSAlertDownloadUpdate

+ (void)showWithMessage:(NSString *)message {
    PSAlertDownloadUpdate *alert = [[PSAlertDownloadUpdate alloc] initWithTitle:LocalizedString(@"alert.title.warning") message:message delegate:self cancelButtonTitle:LocalizedString(@"button.close") otherButtonTitles:LocalizedString(@"button.download"), nil];
    [alert show];
    [alert release];
}

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 1) return;
    
    //Проверяем наличие соединение с Интернетом
    Reachability *r = [Reachability  reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if (internetStatus != ReachableViaWiFi && internetStatus != ReachableViaWWAN) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"alert.title.warning") message:LocalizedString(@"alert.message.network_not_connected") delegate:nil cancelButtonTitle:LocalizedString(@"button.ok") otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    //Блокируем любые касания
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    //Получаем папку куда закачаем наш файл
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/data.zip"];    
    
    //Определяем строку запроса    
    NSString *lang = [Utils getSystemLanguage];
    NSString *str = [NSString stringWithFormat:@"http://tricks4trips.com/current_%@.zip", lang];
    NSURL *url = [NSURL URLWithString:str];    
    
    //Отправляем запрос на сервер    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDownloadDestinationPath:path];    
    //В случаи возникновения ошибки
    [request setFailedBlock:^{
        //Удаляем за собой скаченную базу
        [Utils deletePath:path];        
        //Выводим сообщение об ошибке
        //NSString *statusMessage = [request responseStatusMessage];
        NSString *statusMessage = request.error.localizedDescription;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"alert.title.error") message:statusMessage delegate:nil  cancelButtonTitle:LocalizedString(@"button.ok") otherButtonTitles:nil];
        [alert show];
        [alert release];           
        
        //Снимаем блокировку касаний
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
    //В случае успешного завершения выполнения
    [request setCompletionBlock:^{
        @try {
            //Проверяем, что получили с серврера
            NSFileManager *fileManager = [NSFileManager defaultManager];    
            //Если файл существует
            BOOL isDownloaded = [fileManager fileExistsAtPath:path];
            //Проверяем размер
            if (isDownloaded) {
                NSError *error = nil;
                NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:&error];
                if (error) {
                    printf("Error: %s\n", [[Utils getErrorMessage:@"Неудалось получить атибуты загруженного файла." withError:error] UTF8String]);														
                    isDownloaded = NO;
                } else if (fileAttributes.fileSize < 10) { //меньше 10 байт
                    //Если размер слишком мал - считает что база не была получена
                    isDownloaded = NO;
                }
            }
            
            //Если файл не был получен - база самая новая - выходим
            if (!isDownloaded) return;
            
            //Закрывем соединение со старой базой
            DBManager *dbManager = [DBManager getInstance];
            [dbManager closeDB];
            
            //Удаляем старые данные
            NSString *pathWithResources = [Utils getPathInDocument:PATH_RESOURCE];
            [Utils deletePath:pathWithResources];
            
            //Распаковываем полученные ресурсы
            [SSZipArchive unzipFileAtPath:path toDestination:pathWithResources];        
            
            //Если данные не распакованы - приложение дальше будет работать некорректно т.к. старые данные уже удалены
            if (![fileManager fileExistsAtPath:pathWithResources]) {        
                NSString *message = [NSString stringWithFormat:LocalizedString(@"alert.message.extract_failed"), url.relativePath]; 
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"alert.title.error") message:message delegate:nil  cancelButtonTitle:LocalizedString(@"button.ok") otherButtonTitles:nil];
                [alert show];
                [alert release];          
                return;
            }    
            
            //Записываем дату скачивания
            NSString *currentDate = [Utils stringFromDate:[NSDate date]];
            [PSParamModel insertValue:currentDate withKey:PARAM_LAST_UPDATE];
            
            //Запоминаем на каком языке база
            [PSParamModel insertValue:lang withKey:PARAM_LANGUAGE];
            
            //Перегружаем файл локализации
            [Utils loadLocalizableStrings];
            
            //Выводим сообщение об успешном обновлении
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"alert.title.info") message:LocalizedString(@"alert.message.successfull") delegate:nil  cancelButtonTitle:LocalizedString(@"button.ok") otherButtonTitles:nil];
            [alert show];
            [alert release];
        } @finally {
            //Удаляем за собой скаченную базу
            [Utils deletePath:path];
            //Снимаем блокировку касаний
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    }];
    [request startAsynchronous];
}

@end
