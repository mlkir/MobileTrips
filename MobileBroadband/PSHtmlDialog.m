//
//  PSCountryInfoDialog.m
//  MobileBroadband
//
//  Created by Медведь on 28.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSHtmlDialog.h"

@implementation PSHtmlDialog

@synthesize text  = _text;

- (id)initWithTitle:(NSString *)title 
{
    self = [super initWithTitle:title delegate:self cancelButtonTitle:NSLocalizedString(@"button.cancel", @"") destructiveButtonTitle:nil otherButtonTitles:@"A", @"B", @"C", nil];
    if (self) {
        [self setActionSheetStyle:UIActionSheetStyleAutomatic];    
                
    }
    return self;
}

#pragma mark - Action sheet delegate

/* Событие перед выводом на экран */
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    
    //Определям верхнюю и нижнюю кнопки, поверх которых будет выведен WebView    
    UIView *btnFirst = [self.subviews objectAtIndex:1];    
    UIView *btnLast = [self.subviews objectAtIndex:(self.subviews.count - 2)];
        
    //Определяем размеры для вывода WebView    
    CGRect rect = btnFirst.frame;
    rect.size.height = btnLast.frame.origin.y + btnLast.frame.size.height - btnFirst.frame.origin.y; 
    
    //Выводим WebView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:rect];    
    [webView loadHTMLString:self.text baseURL:nil];
    [self addSubview:webView];
    [webView release];
    
}

@end
