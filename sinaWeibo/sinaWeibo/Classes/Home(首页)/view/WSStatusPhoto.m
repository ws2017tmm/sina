//
//  WSStatusPhoto.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/8/29.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSStatusPhoto.h"
#import "WSPhoto.h"
#import "UIImageView+WebCache.h"

@interface WSStatusPhoto ()

/** gif */
@property (weak, nonatomic) UIImageView *gifView;



@end

@implementation WSStatusPhoto



- (UIImageView *)gifView {
    if (!_gifView) {
        UIImage *image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return _gifView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        //开启交互
        self.userInteractionEnabled = YES;
        //添加点按手势
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

- (void)setPhoto:(WSPhoto *)photo {
    _photo = photo;
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gifView.x = self.width - self.gifView.width;
    self.gifView.y = self.height - self.gifView.height;
}

//图片的点击(手势)
- (void)tapImage:(UITapGestureRecognizer *)tapGesture {
    if ([self.delegate respondsToSelector:@selector(statusPhoto:didTap:)]) {
        [self.delegate statusPhoto:self didTap:tapGesture];
    }
}

@end
