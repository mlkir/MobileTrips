//
//  PSSortDialog.h
//  MobileBroadband
//
//  Created by Медведь on 30.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface PSSortDialog : UIActionSheet <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>


- (id)initWithTitle:(NSString *)title;

- (void)addTarget:(id)target action:(SEL)action;

@end
