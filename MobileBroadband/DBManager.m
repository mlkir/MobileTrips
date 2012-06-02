//
//  DBManager.m
//  LegalAdviser
//
//  Created by Медведь on 04.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBManager.h"
#import "Utils.h"
#import "AbstractModel.h"


@implementation DBManager



@synthesize databasePath = _databasePath;



/* Возвращает экземпляр класса */
+ (id)getInstance {	
    static DBManager *instance = nil;	
	if (instance == nil) instance = [[DBManager alloc] initWithDatabaseName:DATABASE_FILENAME];	
	return instance;
}

/* Конструктор */
- (id)initWithDatabasePath:(NSString *)databasePath {
	if ((self = [super init])) {        
				
        //Получаем путь к файлу с БД		
		_databasePath = [databasePath retain];
		
	}  
	return self;
}

/* Конструктор */
- (id)initWithDatabaseName:(NSString *)databaseName  {
	NSString *databasePath = [[Utils getPathInDocument:PATH_RESOURCE] stringByAppendingPathComponent:databaseName];
	self = [self initWithDatabasePath:databasePath];
	return self;
}


/* Установить соединение с БД */
- (BOOL)openDB {
	if (database != nil) return YES;    
	if (sqlite3_open([_databasePath UTF8String], &database) != SQLITE_OK) {
		printf("Error: Failed to open database with message '%s'.\n", sqlite3_errmsg(database));
		[self closeDB];
		return NO;
	}
	return YES;
}

/* Закрыть соединение с БД */
- (void)closeDB {	
	if (database != nil) {        
		if (sqlite3_close(database) != SQLITE_OK) {
			printf("Error: failed to close database with message '%s'.\n", sqlite3_errmsg(database));
		}
		database = nil;
	}
}

/* Деструктор */
- (void)dealloc {	
	
    [self closeDB];	
    [_databasePath	release];
    
    [super dealloc];
}

/* Получить последнее сообщение об ошибке */
- (const char *)getErrorMessage {
    return (database != nil) ? nil : sqlite3_errmsg(database);
}

/* Выполнение нескольких скриптов (каждый скрипт на новой строке) */
- (void)execSQLBatch:(NSString *)batchQueries {
    if (batchQueries == nil) return;
    NSUInteger length = [batchQueries length];
    if (length == 0) return;
    
    NSString *linefeed = @"\n";
    NSUInteger linefeedLength = 1;
    //printf("%s\nlength = %d\n", [batchQueries UTF8String], length);
    
    //Пробегаемся по строкам 
    NSUInteger posStart = 0;
    NSRange rangeLinefeed = [batchQueries rangeOfString:linefeed];
    while (YES) {     
        //Если дошли до конца текста
        if (rangeLinefeed.location == NSNotFound && posStart >= length) break;
        
        //Определяем конечное положение
        NSUInteger posFinal = (rangeLinefeed.location == NSNotFound) ? length : rangeLinefeed.location;        
        NSRange rangeSubstring = NSMakeRange(posStart, posFinal  - posStart);        
        //printf("posStart: %d; posFinal: %d; len: %d\n", posStart , posFinal, posFinal - posStart);
        NSString *query = [batchQueries substringWithRange:rangeSubstring]; 
        if (![Utils isEmptyString:query]) {            
            //printf("%s\n", [query UTF8String]);
            [self execSQL:[query UTF8String]];
        }
        posStart = posFinal + linefeedLength;
        if (posStart >= length) break;
        rangeLinefeed = [batchQueries rangeOfString:linefeed options:NSCaseInsensitiveSearch range:NSMakeRange(posStart, length - posStart)];
    }
}

/* Выполнить скрипты из файла */
- (void)execSQLFromFile:(NSString *)fileName {
    [self execSQLBatch:[Utils loadFromFile:fileName]];
}

/* Выполнение переданной SQL команды (INSERT, UPDATE, DELETE, ALTER TABLE и т.п.) */
- (void)execSQL:(const char *)sql {
	if (![self openDB]) return;
	
	sqlite3_stmt *statement = [self prepareStatement:sql];
    if (statement == nil) return;		
	
    
	if (sqlite3_step(statement) != SQLITE_DONE) {
		printf("Error: Failed to execute query with message '%s'.\n", sqlite3_errmsg(database));
	}
	
	sqlite3_reset(statement);
	sqlite3_finalize(statement);
}

/* Создание sqlite3 statement для передданного запроса */
- (sqlite3_stmt *)prepareStatement:(const char *)sql {
	if (![self openDB]) return nil;
	
	sqlite3_stmt *statement = nil;
	if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
		printf("Error: Failed to prepare statement with message '%s' for sql \n'%s'.\n", sqlite3_errmsg(database), sql);
		return nil;		
	}
	
    return statement;
}

/* Возвращает последний ID для таблицы */
- (int)getLastIdForTable:(const char *)tableName {
    return sqlite3_last_insert_rowid(database);
}
/* Получить значение поля из запроса */
- (NSString *)getFieldStringByQuery:(const char *)sql {    
	
	sqlite3_stmt *stmt = [self prepareStatement:sql];
    if (stmt == nil) return nil;
	
	@try {
        
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            sqlite3_value *value = sqlite3_column_value(stmt, 0);
            return (sqlite3_value_type(value) == SQLITE_NULL) ? nil : [self getString:value default:nil];
        }
        
    } @finally {        
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);
    }
    
	return nil;
    
}

/* Получить значение поля из запроса */
- (sqlite3_value *)getFieldValueByQuery:(const char *)sql {    
	
	sqlite3_stmt *stmt = [self prepareStatement:sql];
    if (stmt == nil) return nil;
	
	@try {
        
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            sqlite3_value *value = sqlite3_column_value(stmt, 0);
            return (sqlite3_value_type(value) == SQLITE_NULL) ? nil : value;
        }
        
    } @finally {        
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);
    }
    
	return nil;
    
}

/* Получить сущность */
- (id)newEntite:(Class)clazz query:(const char *)sql {
    //Выполняем запрос
    sqlite3_stmt *stmt = [self prepareStatement:sql];
    if (stmt == nil) return nil;
    
    //Получаем запись
    @try {
        if (sqlite3_step(stmt) == SQLITE_ROW) {                       
            AbstractModel *entity = [[clazz alloc] init];
            [entity fillAttributes:stmt manager:self];
            return entity;
        }
    } @finally {        
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);
    }
    
    return nil;
}

/* Получить список сущностей */
- (NSMutableArray *)newListEntiteClass:(Class)clazz query:(const char *)sql {
    //Выполняем запрос
    sqlite3_stmt *stmt = [self prepareStatement:sql];
    if (stmt == nil) return nil;
    
    //Получаем записи
    NSMutableArray *list = [[NSMutableArray alloc] init];
    @try {
        while (sqlite3_step(stmt) == SQLITE_ROW) {                       
            AbstractModel *entity = [[clazz alloc] init];            
            [entity fillAttributes:stmt manager:self];
            [list addObject:entity];
            [entity release];		
        }
    } @finally {        
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);
    }
    
    return list;
}

/* Получить данные для сущности и заполнить (если сущность не найдена вернет NO)*/
- (BOOL)fillAttributesEntity:(AbstractModel *)entity query:(const char *)sql {
	//Создаем запрос
    sqlite3_stmt *stmt = [self prepareStatement:sql];
    if (stmt == nil) return NO;
	
	//Выполняем запрос
	@try {
		//Заполняем поля
		if (sqlite3_step(stmt) == SQLITE_ROW) {
			[entity fillAttributes:stmt manager:self];
			return YES;                    
		} 
	} @finally {            
		sqlite3_reset(stmt);
		sqlite3_finalize(stmt); 
	}    
	
	return NO;
}


/* Получаем указатель на целое для значания из базы */
- (int *)getPointerInt:(sqlite3_value *)value {	
    if (sqlite3_value_type(value) == SQLITE_NULL) return nil;
    static int i = 0;
    i = sqlite3_value_int(value);
    return &i;
}

/* Получаем строку из базы */
- (NSString *)getString:(sqlite3_value *)value default:(NSString *)def {	
	if (value == nil) return def;
    if (sqlite3_value_type(value) == SQLITE_NULL) return def;   
	const unsigned char *text = sqlite3_value_text(value);
	if (text == nil) return def;
    NSString *str = [[NSString alloc] initWithUTF8String:(const char *)text];
    return [str autorelease]; 
}

/* Получаем Дату из базы */
- (NSDate *)getDate:(sqlite3_value *)value {	
    if (sqlite3_value_type(value) == SQLITE_NULL) return nil;            
    NSString *str = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_value_text(value)];
    NSDate *date = [Utils dateFromString:str];
    [str release];
    return date;    
}


/* Устанавдиваем значение SQL-выражения для целого числа */
- (void)sqlite3BindPointerInt:(int *)valueInt forStatement:(sqlite3_stmt *)stmt withPosition:(int)pos {	
	if (valueInt == nil) {
		sqlite3_bind_null(stmt, pos);
	} else {	
		sqlite3_bind_int(stmt, pos, *valueInt);
	}
}

/* Устанавдиваем значение SQL-выражения для целого числа */
- (void)sqlite3BindText:(NSString *)text forStatement:(sqlite3_stmt *)stmt withPosition:(int)pos {	
	if (text == nil) {
		sqlite3_bind_null(stmt, pos);
	} else {	
		sqlite3_bind_text(stmt, pos, [text UTF8String], -1, SQLITE_TRANSIENT);
	}
}

@end
