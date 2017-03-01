//
//  WSStatus.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/4/12.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//  微博模型

#import "WSStatus.h"
#import "WSPhoto.h"
#import "MJExtension.h"
#import "NSDate+Extension.h"

@implementation WSStatus

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"pic_urls" : [WSPhoto class]};
}

/**
 1.今年
 1> 今天
 * 1分内： 刚刚
 * 1分~59分内：xx分钟前
 * 大于60分钟：xx小时前
 
 2> 昨天
 * 昨天 xx:xx
 
 3> 其他
 * xx-xx xx:xx
 
 2.非今年
 1> xxxx-xx-xx xx:xx
 */

    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年

- (NSString *)created_at {
    //当前时间
    NSDate *currentDate = [NSDate date];
    
    //微博创建时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    NSDate *createDate = [fmt dateFromString:_created_at];
    
    //日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //需要获得的参数(年月日时分秒)
    NSCalendarUnit uint = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //两个日期之间的比较(相差--年月日时分秒)
    NSDateComponents *cmps = [calendar components:uint fromDate:createDate toDate:currentDate options:0];
    
    if ([createDate isThisYear]) { //今年
        if ([createDate isToday]) { //今天
            if (cmps.hour >= 1) { //xx小时前
                return [NSString stringWithFormat:@"%d小时前",cmps.hour];
            } else if (cmps.minute > 1) { //xx分钟前
                return [NSString stringWithFormat:@"%d分钟前",cmps.minute];
            } else{
                return @"刚刚";
            }
        }else if ([createDate isYesterday]) { //昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        } else { //其他
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    } else { //非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
}

//source = <a href="http://app.weibo.com/t/feed/6vtZb0" rel="nofollow">微博 weibo.com</a>
- (void)setSource:(NSString *)source {
    //source为空
    if (!source.length) {
        _source = source;
        return;
    }
    
    NSRange range;
    NSUInteger loc1 = [source rangeOfString:@">"].location;
    NSUInteger loc2 = [source rangeOfString:@"</"].location;
    
    range.location = loc1 + 1;
    range.length = loc2 - (loc1 + 1);
    NSString *str = [source substringWithRange:range];
    _source = [NSString stringWithFormat:@"来自%@",str];
}

@end
