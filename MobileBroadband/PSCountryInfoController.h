//
//  PSCountryInfoController.h
//  MobileBroadband
//
//  Created by Медведь on 13.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCountryModel.h"


@interface PSCountryInfoController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, retain) PSCountryModel *country;

@end
