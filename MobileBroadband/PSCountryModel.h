//
//  BroadbandModel.h
//  Prototype
//
//  Created by Медведь on 05.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractModel.h"

@interface PSCountryModel : AbstractModel  {

}

@property (nonatomic, readonly) int ID;
@property (nonatomic, retain) NSString *name;           //название страны (например: United Kingdom)
@property (nonatomic, retain) NSString *page;           //описание общих вещей характерных для страны (в формате HTML)
@property (nonatomic, retain) NSString *flag;           //название файла с флагом
@property (nonatomic, retain) NSString *currencyName;   //код валюты
@property (nonatomic, readwrite) BOOL isPageExists;     //есть страница с описанием (чтобы не подгружать без необходимости
@property (nonatomic, readwrite) BOOL isTariffsExists;  //есть список с тарифами (чтобы поазывать или не показывать кнопку перехода к тарифам)

+ (NSMutableArray *)newList;

@end
