//
//  WSTitleButton.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/4/5.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSTitleButton.h"
#define WSMargin 5

@implementation WSTitleButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    }
    return self;
}

//重写frame，方法的目的：拦截设置按钮尺寸的过程
- (void)setFrame:(CGRect)frame {
    frame.size.width += WSMargin;
    [super setFrame:frame];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    //计算titleLabel的frame
    self.titleLabel.x = self.imageView.x;
    
    //计算imageView的frame
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + WSMargin;
    
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    
    //只要文字改变了，就重新计算按钮的尺寸
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    
    //只要图片改变了，就重新计算按钮的尺寸
    [self sizeToFit];
    
}


@end
