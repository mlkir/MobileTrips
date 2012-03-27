//
//  DBManager.h
//  LegalAdviser
//
//  Created by Медведь on 04.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface DBManager : NSObject {
    sqlite3 *database;
}

@property (nonatomic, readonly) NSString *databasePath;

+ (id)getInstance;

- (id)initWithDatabasePath:(NSString *)databasePath;
- (id)initWithDatabaseName:(NSString *)databaseName;
	
- (BOOL)openDB;
- (void)closeDB;

- (const char *)getErrorMessage;

- (void)execSQL:(const char *)sql;
- (void)execSQLFromFile:(NSString *)fileName;
- (void)execSQLBatch:(NSString *)batchQueries;
- (int)getLastIdForTable:(const char *)tableName;
- (sqlite3_value *)getFieldValueByQuery:(const char *)sql;
- (NSString *)getFieldStringByQuery:(const char *)sql;
- (sqlite3_stmt *)prepareStatement:(const char *)sql;
- (NSMutableArray *)newListEntiteClass:(Class)clazz query:(const char *)sql;
//- (BOOL)fillAttributesEntity:(AbstractModel *)entity query:(const char *)sql;


- (void)sqlite3BindPointerInt:(int *)valueInt forStatement:(sqlite3_stmt *)stmt withPosition:(int)pos;
- (void)sqlite3BindText:(NSString *)text forStatement:(sqlite3_stmt *)stmt withPosition:(int)pos;

- (int *)getPointerInt:(sqlite3_value *)intValue;
- (NSString *)getString:(sqlite3_value *)value default:(NSString *)def;
- (NSDate *)getDate:(sqlite3_value *)value;




@end


@protocol DBManagerProtocol <NSObject>

- (void)fillAttributes:(sqlite3_stmt *)stmt manager:(DBManager *)dbManager;

@end
