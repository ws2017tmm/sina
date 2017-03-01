//
//  WSStatusTool.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/9/29.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSStatusTool : NSObject

//根据参数从数据库中获取数据
+ (NSArray *)statusesWithParameters:(NSDictionary *)params;

//存储微博数据
+ (void)saveStatuses:(NSArray *)statuses;

@end
