//
//  PSDetailViewController.m
//  MobileBroadband
//
//  Created by Медведь on 23.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSTariffDetailController.h"
#import "Utils.h"

@interface PSTariffDetailController ()


@end

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
    [html appendString:@"   <style type ='text/css'>"];
    [html appendString:@"       html {-webkit-text-size-adjust: none;}"];
    [html appendString:@"       body {margin:0 0 0 0; padding:10 10 10 10; color:black; font-family:Arial; background-color:white;}"];
    [html appendString:@"       p {margin:0 0 0 0; padding:10 10 0 10; font-weight:normal; text-align:left;}"];
    [html appendString:@"   </style>"];
    [html appendString:@"</head>"];
    [html appendString:@"<body>"];
    [html appendFormat:@"<p>recordId: <font color='red'>%d</font>",self.tariff.ID];
    [html appendFormat:@"<p>provaderName: <font color='blue'>%@</font>",self.tariff.provaderName];
    [html appendFormat:@"<p>trafficType: <font color='blue'>%@</font>",self.tariff.trafficType];
    [html appendFormat:@"<p>tariffName: <font color='blue'>%@</font>",self.tariff.tariffName];    
    [html appendFormat:@"<p>tariffOption: <font color='blue'>%@</font>",self.tariff.tariffOption];
    [html appendFormat:@"<p>speed: <font color='blue'>%@</font>",self.tariff.speed];
    [html appendFormat:@"<p>price: <font color='blue'>%@</font>",self.tariff.price];
    [html appendFormat:@"<p>dataLimit: <font color='blue'>%@</font>",self.tariff.dataLimit];
    [html appendFormat:@"<p>connectionFee: <font color='blue'>%@</font>",self.tariff.connectionFee];
    [html appendFormat:@"<p>initialPayment: <font color='blue'>%@</font>",self.tariff.initialPayment];
    [html appendFormat:@"<p>equipment: <font color='blue'>%@</font>",self.tariff.equipment];
    [html appendFormat:@"<p>whatAfter: <font color='blue'>%@</font>",self.tariff.whatAfter];
    [html appendFormat:@"<p>bonus: <font color='blue'>%@</font>",self.tariff.bonus];
    [html appendFormat:@"<p>linkToTarif: <font color='blue'>%@</font>",self.tariff.linkToTarif];
    [html appendFormat:@"<p>coverage: <font color='blue'>%@</font>",self.tariff.coverage];
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

	
@end
