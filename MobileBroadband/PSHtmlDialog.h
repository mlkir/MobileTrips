//
//  PSCountryInfoDialog.h
//  MobileBroadband
//
//  Created by Медведь on 28.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSHtmlDialog : UIActionSheet <UIActionSheetDelegate>

@property (nonatomic, retain) NSString *text;


- (id)initWithTitle:(NSString *)title;

@end
