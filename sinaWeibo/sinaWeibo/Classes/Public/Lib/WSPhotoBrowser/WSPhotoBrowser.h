//
//  WSPhotoBrowser.h
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSPhotoBrowserView.h"

@class WSPhotoBrowser;
@class WSStatus;

@protocol WSPhotoBrowserDelegate <NSObject>

- (UIImage *)photoBrowser:(WSPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;
- (NSURL *)photoBrowser:(WSPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;
@end

@interface WSPhotoBrowser : UIViewController

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;//图片总数

@property (strong, nonatomic) WSStatus *status;


@property (nonatomic, weak) id<WSPhotoBrowserDelegate> delegate;

- (void)show;
@end
