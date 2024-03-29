//
//  BroadbandModel.m
//  Prototype
//
//  Created by Медведь on 05.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "PSCountryModel.h"


@implementation PSCountryModel

@synthesize ID = _ID;
@synthesize name = _name;
@synthesize page = _page;
@synthesize flag = _flag;
@synthesize currencyName = _currencyName;
@synthesize isPageExists = _isPageExists;
@synthesize isTariffsExists = _isTariffsExists;

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
	[_currencyName release];
    
    [super dealloc];
}

- (NSString *)page {
    //Если страница существует и еще не подгружадась
    if (_isPageExists && !_page) {
        //Подгружаем текст
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT page FROM countries WHERE id = %d", self.ID]; 
        self.page = [[DBManager getInstance] getFieldStringByQuery:[query UTF8String]];
        [query release];
    }
    return _page;
}

/* Заполнить поля данными из выполненного запроса */
- (void)fillAttributes:(sqlite3_stmt *)stmt manager:(DBManager *)dbManager {
	int pos = -1;                
    _ID = sqlite3_column_int(stmt, ++pos);
	self.name = [dbManager getString:sqlite3_column_value(stmt, ++pos) default:@""];
    self.flag = [dbManager getString:sqlite3_column_value(stmt, ++pos) default:nil];
    self.currencyName = LocalizedString([dbManager getString:sqlite3_column_value(stmt, ++pos) default:@""]);
    int len = sqlite3_column_int(stmt, ++pos);    
	_isPageExists = (len > 0); //если длина текста больше 0 - описание существует
    self.page = nil;
    self.isTariffsExists = sqlite3_column_int(stmt, ++pos);
    
}

/* Получить список */
+ (NSArray *)newList {
    const char *sql = "SELECT id, name, flag, currency, length(page), EXISTS(SELECT id  FROM price_data WHERE price_data.country_id = countries.id )  FROM countries"; 
    NSMutableArray *list = [[DBManager getInstance] newListEntiteClass:[self class] query:sql];
    return list;    
}


@end
