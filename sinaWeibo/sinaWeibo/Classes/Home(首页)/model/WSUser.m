//
//  WSUser.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/4/12.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//  用户模型

#import "WSUser.h"

@implementation WSUser

- (void)setMbtype:(int)mbtype {
    
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}

@end
