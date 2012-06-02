//
//  PSDetailViewController.m
//  MobileBroadband
//
//  Created by Медведь on 23.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSTariffDetailController.h"
#import "Utils.h"
#import "PSProviderModel.h"



@implementation PSTariffDetailController

@synthesize tariff = _tariff;
@synthesize webView = _webView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)dealloc
{
    [_tariff release];
    
    [super dealloc];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Указываем заголовок
    self.title = NSLocalizedString(@"PSTariffDetailController.title", nil);
    
    //Подгружаем данные тарифа (впервую очередь при смене локали чтобы переподгрузились данные)
    //self.tariff = [PSTariffModel initById:]
    
    //Загружаем страницу
    NSMutableString *html = [[NSMutableString alloc] initWithString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendString:@"   <meta http-equiv='Content-Type' content='text/html; charset=utf8'>"];
    [html appendString:@"   <link rel='stylesheet' type='text/css' href='common.css' />"];
    [html appendString:@"</head>"];
    [html appendString:@"<body>"];
    //[html appendFormat:@"<p>recordId: <font color='red'>%d</font>",self.tariff.ID];
    [html appendFormat:@"<p class='details_section'>%@</p>", NSLocalizedString(@"PSTariffDetailController.page.about_sel_plan", nil)];
    [html appendString:@"<table width=100% border=0 cellspacing=0 cellpadding=4>"];
    //Основные параметры тарифа
    [html appendString:@"<tr><td>&nbsp;</td></tr>"];
    [html appendFormat:@"<tr><td><b>%@</b></td></tr>", NSLocalizedString(@"PSTariffDetailController.page.main_details", nil)];
    [html appendFormat:@"<tr><td><li>%@</td><td>%@</td></tr>", NSLocalizedString(@"PSTariffDetailController.page.plan_name", nil), self.tariff.tariffName];
    [html appendFormat:@"<tr><td><li>%@</td><td>%@</td></tr>", NSLocalizedString(@"PSTariffDetailController.page.option_name", nil), self.tariff.tariffOption];        
    [html appendFormat:@"<tr><td><li>%@</td><td>%@</td></tr>", NSLocalizedString(@"PSTariffDetailController.page.connection_type", nil), self.tariff.trafficType];
    [html appendFormat:@"<tr><td><li>%@</td><td>%@</td></tr>", NSLocalizedString(@"PSTariffDetailController.page.price", nil), self.tariff.price];
    [html appendFormat:@"<tr><td><li>%@</td><td>%@</td></tr>", NSLocalizedString(@"PSTariffDetailController.page.data_limit", nil), self.tariff.dataLimit];
    [html appendFormat:@"<tr><td><li>%@</td><td>%@</td></tr>", NSLocalizedString(@"PSTariffDetailController.page.max_speed", nil), self.tariff.speed];
    [html appendFormat:@"<tr><td><li>%@</td><td>%@</td></tr>", NSLocalizedString(@"PSTariffDetailController.page.bonus", nil), self.tariff.bonus];
    //Дополнительные параметры
    [html appendString:@"<tr><td>&nbsp;</td></tr>"];
    [html appendFormat:@"<tr><td><b>%@</b></td></tr>", NSLocalizedString(@"PSTariffDetailController.page.additinonal_details", nil)];
    [html appendFormat:@"<tr><td><li>%@</td><td>%@</td></tr>", NSLocalizedString(@"PSTariffDetailController.page.connection_fee", nil), self.tariff.connectionFee];
    [html appendFormat:@"<tr><td><li>%@</td><td>%@</td></tr>", NSLocalizedString(@"PSTariffDetailController.page.init_payment", nil), self.tariff.initialPayment];
    [html appendFormat:@"<tr><td><li>%@</td><td>%@</td></tr>", NSLocalizedString(@"PSTariffDetailController.page.equipment", nil), self.tariff.equipment];
    [html appendFormat:@"<tr><td><li>%@</td><td>%@</td></tr>", NSLocalizedString(@"PSTariffDetailController.page.what_after", nil), self.tariff.whatAfter];
    
    //Как спросить в салоне, чтобы купить этот тариф
    [html appendString:@"<tr><td>&nbsp;</td></tr>"];
    [html appendFormat:@"<tr><td><b>%@</b></td></tr>", NSLocalizedString(@"PSTariffDetailController.page.how_order_plan", nil)];
    [html appendFormat:@"<tr><td><li>%@</td><td>%@</td></tr>", NSLocalizedString(@"PSTariffDetailController.page.plan_name_local", nil), @"<font color='red'>???</font>"];
    [html appendFormat:@"<tr><td><li>%@</td><td>%@</td></tr>", NSLocalizedString(@"PSTariffDetailController.page.option_name_loocal", nil), @"<font color='red'>???</font>"];
    [html appendFormat:@"<tr><td><li><a href='%@'>%@</a></td></tr>", self.tariff.linkToTarif, NSLocalizedString(@"PSTariffDetailController.page.link", nil)];
    [html appendString:@"</table>"];
    
    //Получаем описагие оператар
    PSProviderModel *provider = [PSProviderModel newEntityByID:self.tariff.provaderId];
    
    //Выводим инфу по оператору
    [html appendString:@"<br>"];
    [html appendFormat:@"<p class='details_section'>%@ %@</p>", NSLocalizedString(@"PSTariffDetailController.page.about", nil), self.tariff.provaderName];
    [html appendString:@"<br>"];
    [html appendString:provider.page];
    
    [provider release];
    
    [html appendString:@"</body>"];
    [html appendString:@"</html>"]; 
    [self.webView loadHTMLString:html baseURL:[Utils getBaseURL]];
    [html release];
    
        
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

/* Перед тем как загрузить страницу*/
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {	
    //Если первая загрузка (не гиперссылка)
    if (navigationType != UIWebViewNavigationTypeLinkClicked) return YES;
	
    
    //Переходим в сафари
    [[UIApplication sharedApplication] openURL:[request URL]];    
    return NO;    
}

/* Перед началом загрузки страницы */
- (void)webViewDidStartLoad:(UIWebView *)webView {			
    
}

/* После загрузки страницы */
- (void)webViewDidFinishLoad:(UIWebView *)webView {			
    
}	
@end
