//
//  WSStatusFrame.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/8/23.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSStatus;

@interface WSStatusFrame : NSObject

/** 微博模型 */
@property (strong, nonatomic) WSStatus *status;

/*---------------- 原创微博 ----------------*/
/** 原创微博整体 */
@property (assign, nonatomic) CGRect originalViewF;

/** 头像 */
@property (assign, nonatomic) CGRect iconViewF;

/** 昵称 */
@property (assign, nonatomic) CGRect nameLableF;

/** 会员图标 */
@property (assign, nonatomic) CGRect vipViewF;

/** 时间 */
@property (assign, nonatomic) CGRect timeLableF;

/** 来源 */
@property (assign, nonatomic) CGRect sourceLableF;

/** 正文 */
@property (assign, nonatomic) CGRect contentLableF;

/** 配图 */
@property (assign, nonatomic) CGRect photosViewF;

/*---------------- 转发微博 ------------------*/
/** 转发微博整体 */
@property (assign, nonatomic) CGRect retweetViewF;

/** 转发微博正文+昵称 */
@property (assign, nonatomic) CGRect retweetContentLableF;

/** 转发微博的配图 */
@property (assign, nonatomic) CGRect retweetPhotosViewF;

/*---------------- 工具条 ----------------*/
/** 工具条 */
@property (assign, nonatomic) CGRect toolbarF;

/** 每个cell的高度 */
@property (assign, nonatomic) CGFloat cellHeight;

@end
