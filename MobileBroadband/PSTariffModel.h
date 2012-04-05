//
//  BroadbandModel.h
//  Prototype
//
//  Created by Медведь on 05.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractModel.h"
#import "PSCountryModel.h"


@interface PSTariffModel : AbstractModel {
    
}

@property (nonatomic, readonly) int ID;
@property (nonatomic, retain) NSString *trafficType;    //Стандарт (SIM 3G, USB 3G, USB CDMA и т.д.)
@property (nonatomic, retain) NSString *tariffName;     //Название тарифа

@property (nonatomic, readwrite) int provaderId;        //ИД провайдера
@property (nonatomic, retain) NSString *provaderName;   //Название провайдера

@property (nonatomic, retain) NSString *price;          //Стоимости
@property (nonatomic) double priceForSort;              //Стоимость, привеленнаяч к одним единицам измерения

@property (nonatomic, retain) NSString *speed;          //Скорость передачи данных 
@property (nonatomic) double speedForSort;              //Стоимость, привеленнаяч к одним единицам измерения

@property (nonatomic, retain) NSString *dataLimit;      //Ограничение



@property (nonatomic, retain) NSString *tariffOption;
@property (nonatomic, retain) NSNumber *connectionFee;
@property (nonatomic, retain) NSString *initialPayment;
@property (nonatomic, retain) NSString *equipment;
@property (nonatomic, retain) NSString *whatAfter;
@property (nonatomic, retain) NSString *bonus;          //Бонус
@property (nonatomic, retain) NSString *linkToTarif;    //Cсылка на сайт
@property (nonatomic, retain) NSString *coverage;       //Зона покрытия


+ (NSMutableArray *)newListByCountry:(PSCountryModel *)country;

- (id)initById:(int)Id;

@end

