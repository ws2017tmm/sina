//
//  WSTabBar.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/4/6.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSTabBar.h"

@interface WSTabBar ()

@property (strong, nonatomic) UIButton *plusBtn;

@end

@implementation WSTabBar

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //添加一个加号按钮
        UIButton *plusBtn = [[UIButton alloc] init];
        
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        
        [plusBtn addTarget:self action:@selector(plusBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        plusBtn.size = plusBtn.currentBackgroundImage.size;
        
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
        
    }
    return self;
}

//加号按钮的点击事件
- (void)plusBtnDidClick {
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusBtn:)]) {
        [self.delegate tabBarDidClickPlusBtn:self];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // 加号按钮的位置
    self.plusBtn.centerX = self.width * 0.5;
    self.plusBtn.centerY = self.height * 0.5;
    
    //其他按钮的尺寸
    CGFloat tabbarButtonW = self.width / 5;
    
    Class class = NSClassFromString(@"UITabBarButton");
    int tabbarButtonIndex = 0;
    //其他按钮的位置
    for (UIView *child in self.subviews) {
        if ([child isKindOfClass:class]) {
            //x
            child.x = tabbarButtonIndex * tabbarButtonW;
            //宽度
            child.width = tabbarButtonW;
            //索引＋1
            tabbarButtonIndex ++;
            
            //中间加号按钮跳过
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex ++;
            }
        }
    }
//    NSLog(@"-----%@",self.subviews);
}


@end
