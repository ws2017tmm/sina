//
//  WSDropDownMenu.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/4/5.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSDropDownMenu;

@protocol WSDropDownMenuDelegate <NSObject>

@optional
- (void)dropDownMenuDidShow:(WSDropDownMenu *)menu;
- (void)dropDownMenuDidDismiss:(WSDropDownMenu *)menu;

@end

@interface WSDropDownMenu : UIView

+ (instancetype)menu;

- (void)showFrom:(UIView *)view;

- (void)dismiss;

/** 内容控制器 */
@property (strong, nonatomic) UIViewController *contentController;

/** 内容 */
@property (strong, nonatomic) UIView *contentView;

@property (weak, nonatomic) id<WSDropDownMenuDelegate>delegate;

@end
