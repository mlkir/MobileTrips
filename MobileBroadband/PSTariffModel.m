//
//  BroadbandModel.m
//  Prototype
//
//  Created by Медведь on 05.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//




#import "PSTariffModel.h"

@implementation PSTariffModel

NSString *CURRENCY_NAME;


@synthesize ID = _ID;
@synthesize trafficType = _trafficType;
@synthesize tariffName = _tariffName;
@synthesize provaderId = _provaderId;
@synthesize provaderName = _provaderName;
@synthesize price = _price;
@synthesize priceForSort = _priceForSort;
@synthesize speed = _speed;
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
    
    [_trafficType release];
	[_tariffName release];
    [_provaderName release];
    [_price release];
    [_speed release];
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
    self.trafficType = [dbManager getString:sqlite3_column_value(stmt, ++pos) default:@""];
    self.tariffName = [dbManager getString:sqlite3_column_value(stmt, ++pos) default:@""];
    
    self.provaderId = sqlite3_column_int(stmt, ++pos);	
    self.provaderName = [dbManager getString:sqlite3_column_value(stmt, ++pos) default:@""];
    
    double priceDouble = sqlite3_column_double(stmt, ++pos);
    NSNumber *price = [NSNumber numberWithDouble:priceDouble];
    int priceUnitId = sqlite3_column_int(stmt, ++pos);
    NSString *priceUnit = [dbManager getString:sqlite3_column_value(stmt, ++pos) default:@""];    
    self.priceForSort = [self convertPrice:priceDouble withUnitId:priceUnitId];
    self.price = [NSString stringWithFormat:@"%@%@/%@", price, CURRENCY_NAME, priceUnit];
    
    
	self.dataLimit = [dbManager getString:sqlite3_column_value(stmt, ++pos) default:@""];
    
    double speedDouble = sqlite3_column_double(stmt, ++pos);
    NSNumber *speed = [NSNumber numberWithDouble:speedDouble];
    int speedUnitId = sqlite3_column_int(stmt, ++pos);
    NSString *speedUnit = [dbManager getString:sqlite3_column_value(stmt, ++pos) default:@""];    
	self.speedForSort = [self convertSpeed:speedDouble withUnitId:speedUnitId];
    self.speed = [NSString stringWithFormat:@"%@ %@", speed, speedUnit];
                  
}



/* Получить список */
+ (NSArray *)newListByCountry:(PSCountryModel *)country {
    CURRENCY_NAME = country.currencyName;
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT id, traf_type_name, tariff, provider_id, provider_name, price, price_unit_id, price_unit_name, data_limit, speed, speed_unit_id, speed_unit_name FROM price_data WHERE country_id = %d", country.ID]; 
    NSMutableArray *list = [[DBManager getInstance] newListEntiteClass:[self class] query:[query UTF8String]];
    [query release];
    return list;
}


@end
