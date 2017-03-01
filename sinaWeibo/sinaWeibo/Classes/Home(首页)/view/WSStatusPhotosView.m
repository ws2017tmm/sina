//
//  WSStatusPhotosView.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/7/21.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSStatusPhotosView.h"
#import "WSPhoto.h"
#import "WSStatusPhoto.h"
#import "WSPhotoBrowser.h"
#import "WSStatus.h"

#define WSStatusPhotoWH 70 //每张图片的大小
#define WSStatusPhotoMaxCol(count) (count==4) ? 2:3 //最大列数
#define WSStatusPhotoMargin 10 //每张图片的间距

@interface WSStatusPhotosView ()<WSBrowserImageViewDelegate,WSPhotoBrowserDelegate>

@end

@implementation WSStatusPhotosView

/*
- (void)setPhotosArr:(NSArray<WSPhoto *> *)photosArr {
    _photosArr = photosArr;
    
    int photoCount = photosArr.count;
    
    //创建足够多的imageView
    while (self.subviews.count < photoCount) {
        WSStatusPhoto *imageView = [[WSStatusPhoto alloc] init];
        imageView.delegate = self;
        [self addSubview:imageView];
    }
    
    //遍历图片控件,设置图片
    for (int i = 0; i < self.subviews.count; i++) {
        WSStatusPhoto *imageView = self.subviews[i];
        if (i < photoCount) { // 显示
            imageView.hidden = NO;
            //设置tag,显示在图片游览器上第几张
            imageView.tag = i;
            imageView.photo = photosArr[i];
        } else { //隐藏
            imageView.hidden = YES;
        }
    }
}
*/
- (void)setStatus:(WSStatus *)status {
    _status = status;
    NSArray *photosArr = status.pic_urls;
    
    int photoCount = photosArr.count;
    
    //创建足够多的imageView
    while (self.subviews.count < photoCount) {
        WSStatusPhoto *imageView = [[WSStatusPhoto alloc] init];
        imageView.delegate = self;
        [self addSubview:imageView];
    }
    
    //遍历图片控件,设置图片
    for (int i = 0; i < self.subviews.count; i++) {
        WSStatusPhoto *imageView = self.subviews[i];
        if (i < photoCount) { // 显示
            imageView.hidden = NO;
            //设置tag,显示在图片游览器上第几张
            imageView.tag = i;
            imageView.photo = photosArr[i];
        } else { //隐藏
            imageView.hidden = YES;
        }
    }
}

/**
 *  根据图片个数算view的大小
 */
+ (CGSize)sizeWithPhotoCount:(int)count {
    //列数
    NSUInteger maxCol = WSStatusPhotoMaxCol(count);
    CGFloat photoListW = WSStatusPhotoWH * maxCol + WSStatusPhotoMargin * (maxCol - 1);
    
    //行数
    NSUInteger rows = (count + maxCol - 1) / maxCol;
    CGFloat photoListH = WSStatusPhotoWH  * rows + WSStatusPhotoMargin * (rows - 1);
    
    return (CGSize){photoListW,photoListH};
}

//布局图片的尺寸和位置
- (void)layoutSubviews {
    [super layoutSubviews];
    //图片个数
    int photoCount = self.status.pic_urls.count;
    //最大列数
    int maxCol = WSStatusPhotoMaxCol(photoCount);
    CGFloat photoW = WSStatusPhotoWH;
    CGFloat photoH = WSStatusPhotoWH;
    for (int i = 0; i < photoCount; i++) {
        WSStatusPhoto *imageView = self.subviews[i];
        //列数
        int col = i % maxCol;
        //x
        CGFloat photoX = (photoW + WSStatusPhotoMargin) * col;
        //行数
        int row = i / maxCol;
        //y
        CGFloat photoY = (photoH + WSStatusPhotoMargin) * row;
        imageView.frame = CGRectMake(photoX, photoY, photoW, photoH);
    }
}

- (void)statusPhoto:(WSStatusPhoto *)imageView didTap:(UITapGestureRecognizer *)tapGesture {
    //启动图片浏览器
    WSPhotoBrowser *browserVc = [[WSPhotoBrowser alloc] init];
    browserVc.status = self.status;
    browserVc.sourceImagesContainerView = self; // 原图的父控件
    browserVc.imageCount = self.status.pic_urls.count; // 图片总数
    browserVc.currentImageIndex = tapGesture.view.tag;
    browserVc.delegate = self;
    [browserVc show];
}

#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(WSPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
//    return [self.subviews[index] currentImage];
    WSStatusPhoto *photo = self.subviews[index];
    return photo.image;
}

- (NSURL *)photoBrowser:(WSPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [[self.status.pic_urls[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}

@end
