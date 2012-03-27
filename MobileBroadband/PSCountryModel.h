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
@property (nonatomic, retain) NSString *page;          //описание общих вещей характерных для страны (в формате HTML)
@property (nonatomic, retain) NSString *currencyCode;   //код валюты (например: GBP)
@property (nonatomic, readwrite) BOOL isPageExists;     //есть страница с опичанием (чтобы не подгружать без необходимости

+ (NSMutableArray *)newList;

@end
