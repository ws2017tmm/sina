//
//  WSBrowserToolBarView.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/9/5.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WSBrowserToolBarViewBtnTypeSaveImage, // 保存图片
    WSBrowserToolBarViewBtnTypeRetweetStatus, // 转发微博
    WSBrowserToolBarViewBtnTypeAttitude, // 赞
    WSBrowserToolBarViewBtnTypeCancle //取消
} WSBrowserToolBarViewBtnType;

@interface WSBrowserToolBarView : UIView

+ (instancetype)defaultToolbarView;

- (void)show;

@end
