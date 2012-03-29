//
//  PSTariffsTableViewCell.h
//  MobileBroadband
//
//  Created by Медведь on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTariffModel.h"



@interface PSTariffsTableViewCell : UITableViewCell

@property (nonatomic, retain) PSTariffModel *object;


+ (CGRect)getFrameForColumn:(int)column withRowContentFrame:(CGRect)contentRect;

@end
