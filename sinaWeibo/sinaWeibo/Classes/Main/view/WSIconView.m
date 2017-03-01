//
//  WSIconView.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/8/29.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSIconView.h"
#import "UIImageView+WebCache.h"
#import "WSUser.h"

@interface WSIconView ()

@property (weak, nonatomic) UIImageView *verifiedView;

@end

@implementation WSIconView

- (UIImageView *)verifiedView {
    if (!_verifiedView) {
        UIImageView *verifiedView = [[UIImageView alloc] init];
        [self addSubview:verifiedView];
        self.verifiedView = verifiedView;
    }
    return _verifiedView;
}

- (void)setUser:(WSUser *)user {
    _user = user;
    
    //下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    switch (user.verified_type) {
        case WSUserVerifiedTypeNone: // 没有任何认证
            self.verifiedView.hidden = YES;
            break;
            
        case HWUserVerifiedPersonal: // 个人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
            
        case HWUserVerifiedOrgEnterprice: // 企业官方
        case HWUserVerifiedOrgMedia: // 媒体官方
        case HWUserVerifiedOrgWebsite: // 网站官方
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
            
        case HWUserVerifiedDaren: // 微博达人
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
            
        default:
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.verifiedView.size = self.verifiedView.image.size;
    CGFloat scale = 0.6;
    self.verifiedView.x = self.width - self.verifiedView.width * scale;
    self.verifiedView.y = self.height - self.verifiedView.height * scale;
}

@end
