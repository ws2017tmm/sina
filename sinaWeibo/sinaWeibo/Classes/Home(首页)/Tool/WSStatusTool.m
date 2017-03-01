//
//  WSStatusTool.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/9/29.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSStatusTool.h"
#import "FMDB.h"

@implementation WSStatusTool

static FMDatabase *_db;
+(void)initialize {
    //路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"statuses.sqlite"];
    
    //打开数据库
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    //创建表
    [_db executeUpdate:@"create table if not exists t_status(id interger primary key,status blob not null,idstr text not null)"];
}

//根据参数从数据库中获取数据
+ (NSArray *)statusesWithParameters:(NSDictionary *)params {
    // 根据请求参数生成对应的查询SQL语句
    NSString *sql = nil;
    if (params[@"since_id"]) {
        sql = [NSString stringWithFormat:@"select * from t_status where idstr > %@ order by idstr desc limit 20;",params[@"since_id"]];
    } else if (params[@"max_id"]) {
        sql = [NSString stringWithFormat:@"select * from t_status where idstr <= %@ order by idstr desc limit 20;",params[@"max_id"]];
    } else {
        sql = @"select * from t_status order by idstr desc limit 20;";
    }
    
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *statuses = [NSMutableArray array];
    while (set.next) {
        NSData *statusData = [set objectForColumnName:@"status"];
        NSDictionary *status = [NSKeyedUnarchiver unarchiveObjectWithData:statusData];
        [statuses addObject:status];
    }
    return statuses;
}

//存数据
+ (void)saveStatuses:(NSArray *)statuses {
    // 要将一个对象存进数据库的blob字段,最好先转为NSData
    for (NSDictionary *status in statuses) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:status];
        
        [_db executeUpdateWithFormat:@"insert into t_status(status,idstr) values (%@,%@);",data,status[@"idstr"]];
        
    }
}

@end
