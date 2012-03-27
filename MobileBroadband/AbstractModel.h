//
//  AbstractModel.h
//  LegalAdviser
//
//  Created by Медведь on 04.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "DBManager.h"



@interface AbstractModel : NSObject {
    
}

- (void)fillAttributes:(sqlite3_stmt *)stmt manager:(DBManager *)dbManager;

@end
