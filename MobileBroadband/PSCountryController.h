//
//  PSCountryController.h
//  MobileBroadband
//
//  Created by Медведь on 27.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTariffsController.h"



@interface PSCountryController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *countryTableView;
@property (strong, nonatomic) IBOutlet UILabel *lastUpdateLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UIButton *downloadButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *downloadSegmentedControl;

@property (strong, nonatomic) PSTariffsController *detailViewController;

- (IBAction)onDownload:(id)sender;

@end
