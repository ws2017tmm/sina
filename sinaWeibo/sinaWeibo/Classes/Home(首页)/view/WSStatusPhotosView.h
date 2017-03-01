//
//  WSStatusPhotosView.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/7/21.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSPhoto;
@class WSStatus;

@interface WSStatusPhotosView : UIView

/** 根据图片个数算view的大小 */
+ (CGSize)sizeWithPhotoCount:(int)count;

@property (strong, nonatomic) NSArray <WSPhoto *> *photosArr;

@property (strong, nonatomic) WSStatus *status;


@end
