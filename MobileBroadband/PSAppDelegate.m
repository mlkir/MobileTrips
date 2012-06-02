//
//  PSAppDelegate.m
//  MobileBroadband
//
//  Created by Медведь on 23.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "PSAppDelegate.h"
#import "Utils.h"
#import "DBManager.h"
#import "PSHomePageController.h"
#import "SSZipArchive.h"
#import "PSParamModel.h"
@implementation PSAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Получаем менеджера файловой системы
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //Проверяем распокованы ресурсы или нет
    NSString *pathWithResources = [Utils getPathInDocument:PATH_RESOURCE];    
    if (![fileManager fileExistsAtPath:pathWithResources]) {                
        //Распаковываем ресурсы для работы
        NSString *lang = [Utils getCurrentLanguage];
        NSString *fileZip = [NSString stringWithFormat:FILENAME_ZIP, lang];
        fileZip = [Utils getPathInBundle:fileZip];
        if (![fileManager fileExistsAtPath:fileZip]) fileZip = [Utils getPathInBundle:FILENAME_ZIP_DEFAULT];                
        [SSZipArchive unzipFileAtPath:fileZip toDestination:pathWithResources];        
    }

    //Создаем window
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    //Создаем контроллер
    PSHomePageController *rootController = [[[PSHomePageController alloc] initWithNibName:@"PSHomePageController" bundle:nil] autorelease];
    UINavigationController *rootNavigationController = [[[UINavigationController alloc] initWithRootViewController:rootController] autorelease];
    rootNavigationController.navigationBar.tintColor = [Utils getColorWithRed:17 green:29 blue:55];
    self.navigationController = rootNavigationController;
    self.window.rootViewController = self.navigationController;
    //Выводим
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{    
    //Если язык не соответсвует текущему выбранному
    NSString *lang = [PSParamModel getValueByKey:PARAM_LANGUAGE];
    if (lang && ![lang isEqualToString:[Utils getCurrentLanguage]]) {
        //Выводим сообщение что нужно обновить базу чтобы получить ее на текущем языке
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert.title.warning", nil) message:NSLocalizedString(@"alert.message.lang_not_found", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"button.ok", nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
        //Удаляем чтобы больше не сообщать пользователю о необходимости обновиться
        //[PSParamModel deleteValueWithKey:PARAM_LANGUAGE];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
