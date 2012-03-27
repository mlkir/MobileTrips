//
//  AbstractModel.m
//  LegalAdviser
//
//  Created by Медведь on 04.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbstractModel.h"


@implementation AbstractModel

/* Конструктор */
- (id)init {
    if ((self = [super init])) {	   
		        
		
    }
    return self;
}


/* Деструктор */
- (void)dealloc {
	    
    [super dealloc];
}


/* Заполнение полей значениями из выполненного запроса к БД */
- (void)fillAttributes:(sqlite3_stmt *)stmt manager:(DBManager *)dbManager {
    //переопределяется в наследниках
}

@end
