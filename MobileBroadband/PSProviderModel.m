//
//  PSProviderModel.m
//  MobileBroadband
//
//  Created by Медведь on 30.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSProviderModel.h"

@implementation PSProviderModel

@synthesize ID = _ID;
@synthesize name = _name;
@synthesize page = _page;

+ (PSProviderModel *)newEntityByID:(int)ID {
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT id, name, page FROM providers WHERE id = %d", ID]; 
    PSProviderModel *entity = [[DBManager getInstance] newEntite:self.class query:[query UTF8String]];
    [query release];
    return entity;
}

/* Конструктор */
- (id)init {
    if (self = [super init]) {	   
        
        
        
    }
    return self;
}

/* Деструктор */
- (void)dealloc {
        
	[_name release];
    [_page release];
    
    [super dealloc];
}

/* Заполнить поля данными из выполненного запроса */
- (void)fillAttributes:(sqlite3_stmt *)stmt manager:(DBManager *)dbManager {
	int pos = -1;                
    _ID = sqlite3_column_int(stmt, ++pos);
	self.name = [dbManager getString:sqlite3_column_value(stmt, ++pos) default:@""];
    self.page = [dbManager getString:sqlite3_column_value(stmt, ++pos) default:@""];    
}


@end
