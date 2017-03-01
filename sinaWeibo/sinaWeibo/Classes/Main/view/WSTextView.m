//
//  WSTextView.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/8/31.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSTextView.h"
#import "NSString+Extension.h"

@interface WSTextView ()

@property (weak, nonatomic) UILabel *placeholderLabel;

@end

@implementation WSTextView

#pragma mark - 销毁通知
- (void)dealloc {
    [WSNotificationCenter removeObserver:self];
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //添加label
        [self createPlaceholderLabel];
        
        //默认字体
        self.font = [UIFont systemFontOfSize:15];
        
        // 可以拖曳
        self.scrollEnabled = YES;
        self.alwaysBounceVertical = YES;
        
        //TextDidChange的通知
        [WSNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

#pragma mark - 创建label
//创建Label
- (void)createPlaceholderLabel {
    //添加一个label
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.font = [UIFont systemFontOfSize:15];
    placeholderLabel.userInteractionEnabled = NO;
    placeholderLabel.textAlignment = NSTextAlignmentLeft;
    placeholderLabel.numberOfLines = 0;
    placeholderLabel.backgroundColor = [UIColor clearColor];
    //默认的占位文字
    placeholderLabel.text = @"请输入占位文字...";
    //占位文字默认颜色
    placeholderLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:placeholderLabel];
    self.placeholderLabel = placeholderLabel;
}

#pragma mark -监测textView文本发生变化
//根据是否有文本输入判断是否隐藏placeholderLable
- (void)textDidChange {
    self.placeholderLabel.hidden = self.hasText;
}


#pragma mark - 重新setter方法
//placeholder
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    self.placeholderLabel.text = placeholder;
    // 重新计算frame，可能不会立即调用layoutSubviews
    [self setNeedsLayout];
}

//placeholderColor
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
    [self setNeedsLayout];
}

/** 重写setFont，更改正文font的时候也更改placeHolder的font */
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
    
    [self setNeedsLayout];
}

//text
- (void)setText:(NSString *)text {
    [super setText:text];
//    self.placeholderLabel.hidden = self.hasText;
    [self textDidChange];
}

//attributedText
- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self textDidChange];
}

#pragma mark - 算label的位置
//布局placeholderLable的位置和尺寸
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.placeholderLabel.x = 5;
    self.placeholderLabel.y = 8;
    CGFloat maxW = self.width - self.placeholderLabel.x * 2;
    CGSize placeholderLableSize = [self.placeholderLabel.text sizeWithFont:self.placeholderLabel.font maxW:maxW];
    self.placeholderLabel.size = placeholderLableSize;
}



@end
