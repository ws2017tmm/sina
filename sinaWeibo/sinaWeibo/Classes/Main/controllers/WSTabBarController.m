//
//  WSTabBarController.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/3/29.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSTabBarController.h"
#import "WSNavigationController.h"
#import "WSHomeViewController.h"
#import "WSMessageViewController.h"
#import "WSDiscoverViewController.h"
#import "WSProfileViewController.h"
#import "WSTabBar.h"
#import "WSComposeViewController.h"

@interface WSTabBarController ()<WSTabBarDelegate>

@end

@implementation WSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 四个主要的控制器 */
    WSHomeViewController *home = [[WSHomeViewController alloc] init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    WSMessageViewController *message = [[WSMessageViewController alloc] init];
    [self addChildVc:message title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
    WSDiscoverViewController *discover = [[WSDiscoverViewController alloc] init];
    [self addChildVc:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    WSProfileViewController *profile = [[WSProfileViewController alloc] init];
    [self addChildVc:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    //更换系统自带的tabBar
    WSTabBar *tabBar = [[WSTabBar alloc] init];
    tabBar.delegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
    
}

#pragma mark - 添加四个主要的控制器
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectImage {
    
//    childVc.title = title;
    childVc.navigationItem.title = title;
//    childVc.tabBarItem.title = title;
//    childVc.view.backgroundColor = WSRandomColor;
    
    //用导航控制器包装
    WSNavigationController *navVC = [[WSNavigationController alloc] initWithRootViewController:childVc];
    navVC.tabBarItem.title = title;
    //设置tabBar上的图片
    navVC.tabBarItem.image = [UIImage imageNamed:image];
    navVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置tabBar上的文字样式
    //非选中
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : WSColor(123, 123, 123)
                                 };
    [navVC.tabBarItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    //选中
    NSDictionary *selectAttributes = @{
                                       NSForegroundColorAttributeName : [UIColor orangeColor]
                                       };
    [navVC.tabBarItem setTitleTextAttributes:selectAttributes forState:UIControlStateSelected];
    
    //添加为子控制器
    [self addChildViewController:navVC];
}

#pragma mark - 加号按钮的代理
-(void)tabBarDidClickPlusBtn:(WSTabBar *)tabBar {
    WSComposeViewController *vc = [[WSComposeViewController alloc] init];
    
    WSNavigationController *nav = [[WSNavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:^{
        NSLog(@"presentViewController");
    }];
}




@end
