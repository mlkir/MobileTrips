//
//  PSDetailViewController.h
//  MobileBroadband
//
//  Created by Медведь on 23.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTariffModel.h"


@interface PSTariffDetailController : UIViewController <UIWebViewDelegate>


@property (nonatomic, retain) PSTariffModel *tariff;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
