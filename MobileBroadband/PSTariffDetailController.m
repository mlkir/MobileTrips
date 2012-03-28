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
    NSString *html = [[NSString alloc] initWithFormat:@"<html><body style='text-align: center;'>%@</body></html>", self.tariff.tariffName]; 
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
