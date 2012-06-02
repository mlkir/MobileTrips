//
//  PSCountryInfoController.m
//  MobileBroadband
//
//  Created by Медведь on 13.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSCountryInfoController.h"
#import "PSCountryController.h"
#import "PSTariffsController.h"
#import "PSProviderModel.h"
#import "PSProviderInfoController.h"


@interface PSCountryInfoController ()

@end



@implementation PSCountryInfoController

@synthesize webView = _webView;
@synthesize country = _country;
@synthesize isLoadFromString = _isLoadFromString;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    //Указываем заголовок
    self.title = _country.name;
    
    //Загружаем страницу
    _isLoadFromString = YES;
    NSString *html = [Utils getHtmlWithBody:_country.page];
    [self.webView loadHTMLString:html baseURL:[Utils getBaseURL]];
                         
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}



#pragma mark -
#pragma mark UIWebViewDelegate

/* Если возникли ошибки при загрузке*/
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	printf("\n\n************************************************************************************\n");
	printf("%s: didFailLoadWithError \n", [[[[webView description] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";"]] objectAtIndex:0] UTF8String]);
	printf("Error: %s\n", [[error description] UTF8String]);
	printf("************************************************************************************\n\n\n");
    
	
}

/* Возвращает ответ (строку "result") при вызове в JavaScript: document.location = "callback:result"; в противном случае - nil */
- (NSString *)getCallbackFromURLString:(NSString *)urlString {
    //Проверяем на вхождение строки
    NSRange range = [urlString rangeOfString:LINK_JS_CALLBACK_START_WITH];
    //Если не найдена
    if (range.location == NSNotFound && range.length == 0) return nil;
    //Получаем значение колбэка
    NSString *callback = [urlString substringFromIndex:(range.location + range.length)];
    return callback;
}

/* Перед тем как загрузить страницу*/
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {	
    
    //Получае URL для перехода
    NSString *urlString = [[request URL] absoluteString];    
    //NSLog(@"URL: %@", urlString);
    
    //Проверяем не является ли данная гиперссылка callback от JavaScript
    NSString *callback = [self getCallbackFromURLString:urlString];
    if (callback != nil) {
        //NSLog(@"CALLBACK: %@", callback);
        //Если иребуется переход к списку тарифов
        if ([@"gotoTariffs" isEqualToString:callback]) {
            //Переходим к списку тарифов
            PSTariffsController *controller = [[[PSTariffsController alloc] initWithNibName:@"PSTariffsController" bundle:nil] autorelease];
            [controller setCountry:_country];
            [self.navigationController pushViewController:controller animated:YES];
            return NO;
        } 
        
        //Получаем ключ значение через разделитель ':'
        NSArray *arr = [Utils getComponentsSeparated:callback separator:@":"];
        NSString *key = [arr objectAtIndex:0];
        NSString *value = (arr.count > 1) ? [arr objectAtIndex:1] : @"-1";
        //Если требуется переход к провайдеру
        if ([@"provider" isEqualToString:key]) {
            int ID = [value intValue];
            PSProviderModel *provider = [PSProviderModel newEntityByID:ID];
            //Переходим к описанию провайдера
            PSProviderInfoController *controller = [[[PSProviderInfoController alloc] initWithNibName:@"PSProviderInfoController" bundle:nil] autorelease];
            [controller setProvider:provider];
            [provider release];
            [self.navigationController pushViewController:controller animated:YES];
        }
        return NO;
    }

    if (!_isLoadFromString) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    _isLoadFromString = NO;
    
    return YES;  	
}

/* Перед началом загрузки страницы */
- (void)webViewDidStartLoad:(UIWebView *)webView {			
    
}

/* После загрузки страницы */
- (void)webViewDidFinishLoad:(UIWebView *)webView {			
    
}


@end
