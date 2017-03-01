//
//  WSAccountTool.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/4/11.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSAccount.h"

@interface WSAccountTool : NSObject

//存储账号信息
+ (void)saveAccount:(WSAccount *)account;

//读取账号信息
+ (WSAccount *)account;

@end
