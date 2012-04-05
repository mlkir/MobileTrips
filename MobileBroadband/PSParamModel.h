//
//  PSParamModel.h
//  MobileBroadband
//
//  Created by Медведь on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbstractModel.h"

#define PARAM_VERSION @"VERSION"
#define PARAM_LAST_UPDATE @"DOWNLOAD_DATE"

@interface PSParamModel : AbstractModel

@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *value;


+ (NSString *)getValueByKey:(NSString *)key;
+ (void)insertValue:(NSString *)value withKey:(NSString *)key;

@end
