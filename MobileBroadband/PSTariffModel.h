//
//  BroadbandModel.h
//  Prototype
//
//  Created by Медведь on 05.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractModel.h"

@interface PSTariffModel : AbstractModel {
    
}

@property (nonatomic, readonly) int ID;
@property (nonatomic, retain) NSString *tariffType;     //Стандарт (SIM 3G, USB 3G, USB CDMA и т.д.)
@property (nonatomic, retain) NSString *tariffName;     //Название тарифа

@property (nonatomic, readwrite) int provaderId;        //ИД провайдера
@property (nonatomic, retain) NSString *provaderName;   //Название провайдера

@property (nonatomic) double price;                     //Стоимость передачи данных 
@property (nonatomic, retain) NSString *priceUnit;      //Единица измерения стоимости (В день, месяц, за MB) 
@property (nonatomic) double priceForSort;              //Стоимость, привеленнаяч к одним единицам измерения

@property (nonatomic) double speed;                     //Скорость передачи данных 
@property (nonatomic, retain) NSString *speedUnit;      //Единица измерения скорости (Kbps, Mbps и т.п.) 
@property (nonatomic) double speedForSort;              //Стоимость, привеленнаяч к одним единицам измерения

@property (nonatomic, retain) NSString *dataLimit;      //Ограничение


+ (NSArray *)newListByCountryId:(int)countryId;

- (id)initById:(int)Id;

@end
