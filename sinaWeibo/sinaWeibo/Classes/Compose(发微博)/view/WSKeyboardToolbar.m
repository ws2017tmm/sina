//
//  WSKeyboardToolbar.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/8/31.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSKeyboardToolbar.h"

@interface WSKeyboardToolbar ()

@property (nonatomic, weak) UIButton *emotionButton;

@end

@implementation WSKeyboardToolbar

+ (instancetype)toolbar {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        // 初始化按钮
        [self setupBtnWithImage:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted" btnType:WSKeyboardToolbarButtonTypeCamera];
        
        [self setupBtnWithImage:@"compose_toolbar_picture" highImage:@"compose_toolbar_picture_highlighted" btnType:WSKeyboardToolbarButtonTypePicture];
        
        [self setupBtnWithImage:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" btnType:WSKeyboardToolbarButtonTypeMention];
        
        [self setupBtnWithImage:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted" btnType:WSKeyboardToolbarButtonTypeTrend];
        
        self.emotionButton = [self setupBtnWithImage:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" btnType:WSKeyboardToolbarButtonTypeEmotion];
    }
    return self;
}

- (UIButton *)setupBtnWithImage:(NSString *)image highImage:(NSString *)highImage btnType:(WSKeyboardToolbarButtonType)type {
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = type;
    [self addSubview:btn];
    return btn;
}

- (void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(keyboardToolbar:didSelectButton:)]) {
        [self.delegate keyboardToolbar:self didSelectButton:btn.tag];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSUInteger count = self.subviews.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        btn.x = btnW * i;
        btn.y = 0;
        btn.width = btnW;
        btn.height = btnH;
    }
}

@end
