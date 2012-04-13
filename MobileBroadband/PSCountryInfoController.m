//
//  PSCountryInfoController.m
//  MobileBroadband
//
//  Created by Медведь on 13.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSCountryInfoController.h"
#import "Utils.h"
#import "PSCountryController.h"

@interface PSCountryInfoController ()

@end



@implementation PSCountryInfoController

@synthesize webView = _webView;
@synthesize country = _country;



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
    NSString *html = (_country.page) ? _country.page : @"<html><body style='text-align: center;'>no data</body></html>";
    [self.webView loadHTMLString:html baseURL:[Utils getBaseURL]];
    
    //Добавляем кнопку вызова менюшки
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIBarButtonItem *btnMenu = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"PSCountryController.title", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(onTouchButtonMenu:)];
        self.navigationItem.leftBarButtonItem = btnMenu;
        [btnMenu release];
    }
      
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

- (void)reloadInputViews {
    [super reloadInputViews];
    
    //Если вызов обновление данных идет из попапа - скрываем его
    UIPopoverController *popover = [PSCountryController getPopoverController];
    if (popover != nil) [popover dismissPopoverAnimated:YES];    
}

- (void)onTouchButtonMenu:(UIBarButtonItem *)sender {
    PSCountryController *menuController = [[[PSCountryController alloc] initWithNibName:@"PSCountryController" bundle:nil] autorelease];    
    menuController.detailNavigationController = self.navigationController;    
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:menuController] autorelease];    
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    popoverController.popoverContentSize = CGSizeMake(popoverController.popoverContentSize.width, COUNTRY_VIEW_HEIGHT);
    [PSCountryController setPopoverController:popoverController];
    [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


@end
