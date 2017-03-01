//
//  WSComposeView.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/8/31.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSComposeView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface WSComposeView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation WSComposeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a image view
        self.backgroundColor = [UIColor clearColor];
        [self imageView];
        
    }
    
    return self;
}

- (void)setAsset:(JKAssets *)asset{
    if (_asset != asset) {
        _asset = asset;
        
        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:_asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                self.imageView.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }
    
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.clipsToBounds = YES;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.layer.cornerRadius = 6.0f;
        _imageView.layer.borderColor = [UIColor clearColor].CGColor;
        _imageView.layer.borderWidth = 0.5;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

@end
