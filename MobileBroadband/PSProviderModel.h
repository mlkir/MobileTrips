//
//  PSProviderModel.h
//  MobileBroadband
//
//  Created by Медведь on 30.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractModel.h"


@interface PSProviderModel : AbstractModel {

}

@property (nonatomic, readonly) int ID;
@property (nonatomic, retain) NSString *name;           //название 
@property (nonatomic, retain) NSString *page;           //описание  (в формате HTML)

+ (PSProviderModel *)newEntityByID:(int)ID;

@end
