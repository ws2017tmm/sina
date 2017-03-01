//
//  NSDate+Extension.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/8/25.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

/**
 * 判断是否为今年
 */
- (BOOL)isThisYear {
    
    //当前时间
    NSDate *currentDate = [NSDate date];
    
    //日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //获得当前日期 (年月日时分秒)
    NSDateComponents *createCmps = [calendar components:NSCalendarUnitYear fromDate:currentDate];
    //获得微博创建日期的年份
    NSDateComponents *currentCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    
    return createCmps.year == currentCmps.year;
}

/**
 * 判断是否为今天
 */
- (BOOL)isToday {
    // 思路 : 去掉时分秒,比较年月日,年月日相同则为同一天
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    //当前时间
    NSDate *currentDate = [NSDate date];
    NSString *currentDateStr = [fmt stringFromDate:currentDate];
    //微博创建时间
    NSString *createDateStr = [fmt stringFromDate:self];
    
    return [currentDateStr isEqualToString:createDateStr];
}

/**
 * 判断是否为昨天
 */
- (BOOL)isYesterday {
    // 思路 : 去掉时分秒,比较年月日,年月日相差一天则为昨天
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    //当前时间
    NSDate *currentDate = [NSDate date];
    NSString *currentDateStr = [fmt stringFromDate:currentDate];
    
    //微博创建时间
    NSString *createDateStr = [fmt stringFromDate:self];
    
    //再将str转化为date
    currentDate = [fmt dateFromString:currentDateStr];
    NSDate *createDate = [fmt dateFromString:createDateStr];
    
    NSCalendarUnit uint = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //两个日期之间的比较
    NSDateComponents *cmps = [calendar components:uint fromDate:createDate toDate:currentDate options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}




@end
