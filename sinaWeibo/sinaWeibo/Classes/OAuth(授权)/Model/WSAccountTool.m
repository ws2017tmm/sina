//
//  WSAccountTool.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/4/11.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSAccountTool.h"

@implementation WSAccountTool

//存储账号信息
+ (void)saveAccount:(WSAccount *)account {
    //获取沙盒路径
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //拼接路径
    NSString *userPath = [filePath stringByAppendingPathComponent:@"account.plist"];
    //写入沙盒
    [NSKeyedArchiver archiveRootObject:account toFile:userPath];
    
}

//读取账号信息
+ (WSAccount *)account {
    //从沙盒中获取账号
    //获取沙盒路径
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //拼接路径
    NSString *userPath = [filePath stringByAppendingPathComponent:@"account.plist"];
    
    //获取账号信息
    WSAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:userPath];
    
    /* 检测账号是否过期*/
    //过期时长
    long long expires_in = [account.expires_in longLongValue];
    //过期时间
    NSDate *expireTime = [account.create_time dateByAddingTimeInterval:expires_in];
    //当前时间
    NSDate *nowTime = [NSDate date];
    
    //比较时间
    NSComparisonResult result = [expireTime compare:nowTime];
    if (result != NSOrderedDescending) {//过期
        return nil;
    }
    return account;
}

@end
