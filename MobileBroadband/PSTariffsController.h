//
//  PSMasterViewController.h
//  MobileBroadband
//
//  Created by Медведь on 23.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCountryModel.h"

@class PSTariffDetailController;

@interface PSTariffsController : UITableViewController

@property (nonatomic, retain) PSCountryModel *country;

@end
