//
//  WSDropDownMenu.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/4/5.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSDropDownMenu.h"

@interface WSDropDownMenu ()
/**用来显示具体内容的容器*/
@property (strong, nonatomic) UIImageView *containerImageView;

@end


@implementation WSDropDownMenu

//懒加载containerImageView
- (UIImageView *)containerImageView {
    if (!_containerImageView) {
        _containerImageView = [[UIImageView alloc] init];
        _containerImageView.userInteractionEnabled = YES;
        _containerImageView.image = [UIImage imageNamed:@"popover_background"];
        [self addSubview:_containerImageView];
    }
    return _containerImageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (instancetype)menu{
    return [[self alloc] init];
}

- (void)setContentController:(UIViewController *)contentController {
    _contentController = contentController;
    
    self.contentView = contentController.view;
}

- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    contentView.x = 10;
    contentView.y = 15;
    
    self.containerImageView.height = CGRectGetMaxY(contentView.frame) + 10;
    self.containerImageView.width = CGRectGetMaxX(contentView.frame) + 10;
    
    [self.containerImageView addSubview:_contentView];
}

//显示下拉菜单
- (void)showFrom:(UIView *)view {
    
    //获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    //设置dropdown尺寸
    self.frame = window.bounds;
    
    //添加到窗口
    [window addSubview:self];
    
    //转换坐标系(传进来的view的frame以window作为参考系)
    CGRect newFrame = [view convertRect:view.bounds toView:window];
    self.containerImageView.centerX = CGRectGetMidX(newFrame);
    self.containerImageView.y = CGRectGetMaxY(newFrame);
    
    if ([_delegate respondsToSelector:@selector(dropDownMenuDidShow:)]) {
        [_delegate dropDownMenuDidShow:self];
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

//销毁下拉菜单
- (void)dismiss {
    [self removeFromSuperview];
    
    if ([_delegate respondsToSelector:@selector(dropDownMenuDidDismiss:)]) {
        [_delegate dropDownMenuDidDismiss:self];
    }
}










/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
