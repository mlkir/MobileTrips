//
//  PSMasterViewController.h
//  MobileBroadband
//
//  Created by Медведь on 23.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSDetailViewController;

@interface PSMasterViewController : UITableViewController

@property (strong, nonatomic) PSDetailViewController *detailViewController;

@end
