//
//  WSStatusToolbar.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/7/21.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WSStatusToolbar;

typedef enum {
    WSStatusToolbarTypeRetweet = 111, // 转发
    WSStatusToolbarTypeComment, // 评论
    WSStatusToolbarTypeAttitude // 赞
} WSStatusToolbarType;

@class WSStatus;

@interface WSStatusToolbar : UIView

+ (instancetype)toolbar;

@property (strong, nonatomic) WSStatus *status;

@end
