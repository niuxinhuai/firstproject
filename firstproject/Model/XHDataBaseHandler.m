//
//  XHDataBaseHandler.m
//  firstproject
//
//  Created by 牛新怀 on 2017/9/25.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "XHDataBaseHandler.h"
#import <FMDatabase.h>
#import <sqlite3.h>

@interface XHDataBaseHandler()
{
    FMDatabase * _db;
}
@end

static sqlite3 * db = nil;

@implementation XHDataBaseHandler

+ (instancetype)shareInstance{
    static XHDataBaseHandler * dataBase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataBase = [self new];
       // [dataBase initWithDataBase];
        [dataBase createSqlite];
    });
    return dataBase;
}

-(void)createSqlite{
    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * fileName = [path stringByAppendingPathComponent:@"myPostsTable.sqlite"];
    NSLog(@"%@",fileName);
    if ((sqlite3_open(fileName.UTF8String, &db )== SQLITE_OK)) {
        NSLog(@"打开数据库成功");
        //blob NOT NULL
        NSString * sql = @"create table if not exists postTable_list (id integer primary key autoincrement,dictionary text,current int,idStr text);";
        char * errmsg;
        sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"建表失败 -- %s",errmsg);
        }else{
            NSLog(@"建表成功");
        }
    }else{
        NSLog(@"失败");
    }
}


- (NSMutableArray *)totalCacheArray{
    NSMutableArray * listArray = [[NSMutableArray alloc]init];
    [_db open];
    FMResultSet * set = [_db executeQuery:@"select * from postTable"];
    while ([set next]) {
        
    }
    
    return listArray;
}

- (void)saveItemDic:(NSMutableDictionary *)dic className:(NSString *)name{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    

        NSString * sql = [NSString stringWithFormat:@"insert into postTable_list(dictionary,current,idStr) values('%@','%@','%@');",str,@(1),name];
        char * errorMsg;
        sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errorMsg);
        if (errorMsg) {
            NSLog(@"失败原因 -%s",errorMsg);
        }else{
            NSLog(@"OK");
        }
    
    
}

- (void)readCacheList{
        NSString * sql = @"select * from postTable_list where id=7;";
    
        //查询的句柄,游标
        sqlite3_stmt * stmt;
    
        if (sqlite3_prepare(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
    
            //查询数据
            while (sqlite3_step(stmt) == SQLITE_ROW) {
    
                //获取表数据的内容
                //sqlite3_column_text('句柄'，字段索引值)
    
                NSString * name = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
    
                NSLog(@"name = %@",name);
    
            }
        }
}
- (void)delectAllList{
        NSString * sql = @"delete from postTable_list where id > 0 and id < 9;";
        char * errmsg;
        sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"删除失败--%s",errmsg);
        }else{
            NSLog(@"删除成功");
        }
}
#pragma mark - 数据库增加数据
//    NSString * sql = [NSString stringWithFormat:@"insert into t_text(name) values('%@');",[NSString stringWithFormat:@"小丸子--%d",arc4random_uniform(20)]];
//    char * errorMsg;
//    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errorMsg);
//    if (errorMsg) {
//        NSLog(@"失败原因 -%s",errorMsg);
//    }else{
//        NSLog(@"OK");
//    }
#pragma mark - 数据库删除数据操作
//    NSString * sql = @"delete from t_text where id > 3 and id < 6;";
//    char * errmsg;
//    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
//    if (errmsg) {
//        NSLog(@"删除失败--%s",errmsg);
//    }else{
//        NSLog(@"删除成功");
//    }
#pragma mark - 数据库更新数据操作
//    NSString * sql = @"update t_text set name = 'hello-world' where id = 9;";
//    char * errmsg;
//    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
//    if (errmsg) {
//        NSLog(@"修改失败--%s",errmsg);
//    }else{
//        NSLog(@"修改成功");
//    }
#pragma mark - 数据库查询操作
//    NSString * sql = @"select * from t_text;";
//
//    //查询的句柄,游标
//    sqlite3_stmt * stmt;
//
//    if (sqlite3_prepare(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
//
//        //查询数据
//        while (sqlite3_step(stmt) == SQLITE_ROW) {
//
//            //获取表数据的内容
//            //sqlite3_column_text('句柄'，字段索引值)
//
//            NSString * name = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
//
//            NSLog(@"name = %@",name);
//
//        }
//    }




@end
