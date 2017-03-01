//
//  WSRetweetView.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/9/1.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSRetweetView.h"
#import "WSStatus.h"
#import "WSPhoto.h"
#import "WSUser.h"
#import "UIImageView+WebCache.h"

@interface WSRetweetView ()

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UILabel *label;

@end

@implementation WSRetweetView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WSColor(200, 200, 200);
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
//        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        self.label = label;
        
    }
    return self;
}

#pragma mark - setter方法,设置图片和文字
- (void)setStatus:(WSStatus *)status {
    _status = status;
    
    WSStatus *retweeted_status = status.retweeted_status;
    if (retweeted_status) { //有转发微博
        if (retweeted_status.pic_urls.count) { //有配图
            WSPhoto *photo = [retweeted_status.pic_urls firstObject];
            [self setupImageWithURL:photo.thumbnail_pic placeholderImage:@"timeline_image_placeholder"];
        } else { //没配图
            [self setupImageWithURL:retweeted_status.user.profile_image_url placeholderImage:@"avatar_default_small"];
        }
        [self setupLabelTextWithStatus:retweeted_status];
        
    } else { //没有转发微博
        if (status.pic_urls.count) { //有配图
            WSPhoto *photo = [status.pic_urls firstObject];
            [self setupImageWithURL:photo.thumbnail_pic placeholderImage:@"timeline_image_placeholder"];
        } else { //没配图
            [self setupImageWithURL:status.user.profile_image_url placeholderImage:@"avatar_default_small"];
        }
        [self setupLabelTextWithStatus:status];
    }
}

//设置ImageView图片
- (void)setupImageWithURL:(NSString *)url placeholderImage:(NSString *)placeholderImage {
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:placeholderImage]];
}

//设置label文字
- (void)setupLabelTextWithStatus:(WSStatus *)status {
    NSString *userName = [NSString stringWithFormat:@"@%@",status.user.name];
    NSString *text = status.text;
    
    NSString *contentText = [NSString stringWithFormat:@"%@\n%@",userName,text];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentText];
    
    NSDictionary *userNameDict = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:15],
                           NSForegroundColorAttributeName : WSColor(48, 97, 156)
                           };
    [attrStr addAttributes:userNameDict range:[contentText rangeOfString:userName]];
    
    NSDictionary *textDict = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:13],
                           NSForegroundColorAttributeName : WSColor(0, 0, 0)
                           };
    [attrStr addAttributes:textDict range:[contentText rangeOfString:text]];
    self.label.attributedText = attrStr;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 10;
    
    self.imageView.x = margin;
    self.imageView.y = 0;
    self.imageView.height = self.height;
    self.imageView.width = self.height;
    
    self.label.x = CGRectGetMaxX(self.imageView.frame) + margin;
    self.label.y = 0;
    self.label.height = self.imageView.height;
    self.label.width = self.width - self.imageView.width - margin * 3;
}

@end
