//
//  UIWindow+Extension.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/4/11.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "WSTabBarController.h"
#import "WSNewFeatureViewController.h"

@implementation UIWindow (Extension)

//切换根控制器
- (void)swichToRootViewController {
    
    NSString *key = @"CFBundleVersion";
    //取出上一次的版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    //当前版本号
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    NSString *currentVersion = dict[key];
//    NSLog(@"dict = %@",dict);
    
    if ([lastVersion isEqualToString:currentVersion]) {//不是新版本,直接进去主界面
        //创建一个tabBarController
        WSTabBarController *tabBarVc = [[WSTabBarController alloc] init];
        //设置根控制器为tabBarController
        
        self.rootViewController = tabBarVc;
        
    } else {//是新版本,显示新特性
        self.rootViewController = [[WSNewFeatureViewController alloc] init];
        
        //将版本号存放在沙盒
        [[NSUserDefaults standardUserDefaults] setObject:dict[key] forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
