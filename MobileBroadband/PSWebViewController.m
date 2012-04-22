//
//  PSWebViewController.m
//  MobileBroadband
//
//  Created by Медведь on 22.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSWebViewController.h"
#import "Utils.h"


@interface PSWebViewController ()

@end

@implementation PSWebViewController

@synthesize webView = _webView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //Загружаем страницу
    NSString *html = @"<html><body style='text-align: center;'>no data</body></html>";
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

/* Перед тем как загрузить страницу*/
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {	
   
    return YES;  	
}

/* Перед началом загрузки страницы */
- (void)webViewDidStartLoad:(UIWebView *)webView {			
    
}

/* После загрузки страницы */
- (void)webViewDidFinishLoad:(UIWebView *)webView {			
    
}
@end
