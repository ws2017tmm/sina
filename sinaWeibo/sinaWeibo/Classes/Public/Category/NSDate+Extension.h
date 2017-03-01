//
//  NSDate+Extension.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/8/25.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/** 判断是否为今年 */
- (BOOL)isThisYear;

/** 判断是否为今天 */
- (BOOL)isToday;

/** 判断是否为昨天 */
- (BOOL)isYesterday;

@end
