//
//  WSKeyboardToolbar.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/8/31.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSKeyboardToolbar;

typedef enum {
    WSKeyboardToolbarButtonTypeCamera, // 相机
    WSKeyboardToolbarButtonTypePicture, // 相册
    WSKeyboardToolbarButtonTypeMention, // @
    WSKeyboardToolbarButtonTypeTrend, // #
    WSKeyboardToolbarButtonTypeEmotion // 表情
    
}WSKeyboardToolbarButtonType;

@protocol WSKeyboardToolbarDelegate <NSObject>

@optional
- (void)keyboardToolbar:(WSKeyboardToolbar *)toolbar didSelectButton:(WSKeyboardToolbarButtonType)type;

@end

@interface WSKeyboardToolbar : UIView
/** 创建工具条 */
+ (instancetype)toolbar;

@property (weak, nonatomic) id<WSKeyboardToolbarDelegate> delegate;

@end
