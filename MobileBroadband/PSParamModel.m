//
//  PSParamModel.m
//  MobileBroadband
//
//  Created by Медведь on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PSParamModel.h"
#import "DBManager.h"


@implementation PSParamModel

@synthesize key = _key;
@synthesize value = _value;



/* Конструктор */
- (id)init {
    if (self = [super init]) {	   
        
        
        
    }
    return self;
}

/* Деструктор */
- (void)dealloc {
    
	[_key release];
    [_value release];
    
    [super dealloc];
}

/* Заполнить поля данными из выполненного запроса */
- (void)fillAttributes:(sqlite3_stmt *)stmt manager:(DBManager *)dbManager {
	int pos = -1;                    
	self.key = [dbManager getString:sqlite3_column_value(stmt, ++pos) default:@""];
    self.value = [dbManager getString:sqlite3_column_value(stmt, ++pos) default:@""];
}

/* Получить значение переменной */
+ (NSString *)getValueByKey:(NSString *)key {
    NSString *quert = [NSString stringWithFormat:@"SELECT value FROM params WHERE key = '%@'", key];    
    return [[DBManager getInstance] getFieldStringByQuery:[quert UTF8String]];
}


/* Создать запись */
+ (void)insertValue:(NSString *)value withKey:(NSString *)key {
    DBManager *dbManager = [DBManager getInstance];
	sqlite3_stmt *stmt = [dbManager prepareStatement:"INSERT INTO params (key, value) VALUES (?, ?)"];
            
    @try {
        //Указываем параметры
        int pos = 0;        
		[dbManager sqlite3BindText:key forStatement:stmt withPosition:++pos];
        [dbManager sqlite3BindText:value forStatement:stmt withPosition:++pos];        
        
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            printf("Failed to execute query with message '%s'.\n", [dbManager getErrorMessage]);
        }
        
    } @finally {
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);    
    }  
}


@end

