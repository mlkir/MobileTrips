//
//  BroadbandModel.m
//  Prototype
//
//  Created by Медведь on 05.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//




#import "PSTariffModel.h"

@implementation PSTariffModel

@synthesize ID = _ID;
@synthesize tariffType = _tariffType;
@synthesize tariffName = _tariffName;
@synthesize provaderId = _provaderId;
@synthesize provaderName = _provaderName;
@synthesize price = _price;
@synthesize priceUnit = _priceUnit;
@synthesize priceForSort = _priceForSort;
@synthesize speed = _speed;
@synthesize speedUnit = _speedUnit;
@synthesize speedForSort = _speedForSort;
@synthesize dataLimit = _dataLimit;

/* Конструктор */
- (id)init {
    if (self = [super init]) {	   
        
	
    }
    return self;
}

/* Конструктор для получения из БД записи с указанным ИД */
- (id)initById:(int)Id {
    if ([self init]) {  

       // NSString *query = [[NSString alloc] initWithFormat:@"SELECT id, traf_type_name, tariff, provider_id, provider_name, price, price_unit_id, price_unit_name, data_limit, speed, speed_unit_id, speed_unit_name FROM price_data WHERE id = %d", Id]; 
       // [[DBManager getInstance] fillAttributesEntity:self query:[query UTF8String]];
       // [query release];
	}	
	return self;
}

/* Деструктор */
- (void)dealloc {
    
    [_tariffType release];
	[_tariffName release];
    [_provaderName release];
    [_priceUnit release];
    [_speedUnit release];
    [_dataLimit release];
	
    [super dealloc];
}

- (double)convertPrice:(double)price withUnitId:(int)unitId {
    return price;
}


- (double)convertSpeed:(double)speed withUnitId:(int)unitId {
    int x = 1;
    switch (unitId) {
        case 1: x = 1000;   break;      //Kbps
        case 2: x = 1;      break;      //Mbps
    }
    return speed * x;    
}

/* Заполнить поля данными из выполненного запроса */
- (void)fillAttributes:(sqlite3_stmt *)stmt manager:(DBManager *)dbManager {
	int pos = -1;                
    _ID = sqlite3_column_int(stmt, ++pos);    
    self.tariffType = [dbManager getString:sqlite3_column_value(stmt, ++pos) default:@""];
    self.tariffName = [dbManager getString:sqlite3_column_value(stmt, ++pos) default:@""];
    
    self.provaderId = sqlite3_column_int(stmt, ++pos);	
    self.provaderName = [dbManager getString:sqlite3_column_value(stmt, ++pos) default:@""];
    
    self.price = sqlite3_column_double(stmt, ++pos);
    int priceUnitId = sqlite3_column_int(stmt, ++pos);
    self.priceUnit = [dbManager getString:sqlite3_column_value(stmt, ++pos) default:@""];
    self.priceForSort = [self convertPrice:self.price withUnitId:priceUnitId];
    
	self.dataLimit = [dbManager getString:sqlite3_column_value(stmt, ++pos) default:@""];
    
    self.speed = sqlite3_column_double(stmt, ++pos);
    int speedUnitId = sqlite3_column_int(stmt, ++pos);
    self.speedUnit = [dbManager getString:sqlite3_column_value(stmt, ++pos) default:@""];    
	self.speedForSort = [self convertSpeed:self.speed withUnitId:speedUnitId];
}



/* Получить список */
+ (NSArray *)newListByCountryId:(int)countryId {
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT id, traf_type_name, tariff, provider_id, provider_name, price, price_unit_id, price_unit_name, data_limit, speed, speed_unit_id, speed_unit_name FROM price_data WHERE country_id = %d", countryId]; 
    NSMutableArray *list = [[DBManager getInstance] newListEntiteClass:[self class] query:[query UTF8String]];
    [query release];
    return list;
}


@end
