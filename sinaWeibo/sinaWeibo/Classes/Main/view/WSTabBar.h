//
//  WSTabBar.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/4/6.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSTabBar;

@protocol WSTabBarDelegate <NSObject, UITabBarDelegate>

@optional
- (void)tabBarDidClickPlusBtn:(WSTabBar *)tabBar;

@end

//UITableView
@interface WSTabBar : UITabBar <NSCoding>

@property (weak, nonatomic) id <WSTabBarDelegate> delegate;

@end