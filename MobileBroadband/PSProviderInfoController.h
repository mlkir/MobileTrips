//
//  PSProviderInfoController.h
//  MobileBroadband
//
//  Created by Медведь on 30.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSProviderModel.h"

@interface PSProviderInfoController : UIViewController <UIWebViewDelegate>



@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, readwrite) BOOL isLoadFromString;
@property (nonatomic, retain) PSProviderModel *provider;

@end
