//
//  PSSettingsController.h
//  MobileBroadband
//
//  Created by Медведь on 27.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSSettingsController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
