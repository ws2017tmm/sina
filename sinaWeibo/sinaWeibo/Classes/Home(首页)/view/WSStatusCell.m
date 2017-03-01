//
//  WSStatusCell.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/7/21.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSStatusCell.h"
#import "WSStatusPhotosView.h"
#import "WSStatusToolbar.h"
#import "WSStatusFrame.h"
#import "WSStatus.h"
#import "WSUser.h"
#import "UIImageView+WebCache.h"
#import "WSPhoto.h"
#import "WSIconView.h"

@interface WSStatusCell ()

{
    /*---------------- 原创微博 ----------------*/
    /** 原创微博整体 */
    UIView *_originalView;
    
    /** 头像 */
    WSIconView *_iconView;
    
    /** 昵称 */
    UILabel *_nameLable;
    
    /** 会员图标 */
    UIImageView *_vipView;
    
    /** 时间 */
    UILabel *_timeLable;
    
    /** 来源 */
    UILabel *_sourceLable;
    
    /** 正文 */
    UILabel *_contentLable;
    
    /** 配图 */
    WSStatusPhotosView *_photosView;
    
    /*---------------- 转发微博 ------------------*/
    /** 转发微博整体 */
    UIView *_retweetView;
    
    /** 转发微博正文+昵称 */
    UILabel *_retweetContentLable;
    
    /** 转发微博的配图 */
    WSStatusPhotosView *_retweetPhotosView;
    
    /*---------------- 工具条 ----------------*/
    /** 工具条 */
    WSStatusToolbar *_toolbar;
}

@end


@implementation WSStatusCell

#pragma mark - 提供方法给外界创建cell
+ (WSStatusCell *)cellForTableView:(UITableView *)tableView {
    static NSString *ID = @"status";
    WSStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[WSStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

#pragma mark - 自定义cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //取消选中状态
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //初始化原创微博
        [self setupOriginalWeiBo];
        
        //初始化转发微博
        [self setupRetweetWeiBo];
        
        //初始化工具条
        [self setuptoolbar];
        
    }
    return self;
}

#pragma mark - 初始化原创微博
- (void)setupOriginalWeiBo {
    /** 原创微博整体 */
    _originalView = [[UIView alloc] init];
    _originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_originalView];
    
    /** 头像 */
    _iconView = [[WSIconView alloc] init];
    [_originalView addSubview:_iconView];
    
    /** 昵称 */
    _nameLable = [[UILabel alloc] init];
    _nameLable.font = WSStatusCellNameFont;
    [_originalView addSubview:_nameLable];
    
    /** 会员图标 */
    _vipView = [[UIImageView alloc] init];
    [_originalView addSubview:_vipView];
    
    /** 时间 */
    _timeLable = [[UILabel alloc] init];
    _timeLable.font = WSStatusCellTimeFont;
    [_originalView addSubview:_timeLable];
    
    /** 来源 */
    _sourceLable = [[UILabel alloc] init];
    _sourceLable.font = WSStatusCellSourceFont;
    [_originalView addSubview:_sourceLable];
    
    /** 正文 */
    _contentLable = [[UILabel alloc] init];
    _contentLable.numberOfLines = 0;
    _contentLable.font = WSStatusCellContentFont;
    [_originalView addSubview:_contentLable];
    
    /** 配图 */
    _photosView = [[WSStatusPhotosView alloc] init];
    [_originalView addSubview:_photosView];
    
    
}

#pragma mark - 初始化转发微博
- (void)setupRetweetWeiBo {
    /** 转发微博整体 */
    _retweetView = [[UIView alloc] init];
    _retweetView.backgroundColor = WSColor(247, 247, 247);
    [self.contentView addSubview:_retweetView];
    
    /** 转发微博正文+昵称 */
    _retweetContentLable = [[UILabel alloc] init];
    _retweetContentLable.numberOfLines = 0;
    _retweetContentLable.font = WSStatusCellRetweetContentFont;
    [_retweetView addSubview:_retweetContentLable];
    
    /** 转发微博的配图*/
    _retweetPhotosView = [[WSStatusPhotosView alloc] init];
    [_retweetView addSubview:_retweetPhotosView];
    
}

#pragma mark - 初始化工具条
- (void)setuptoolbar {
    _toolbar = [[WSStatusToolbar alloc] init];
    [self.contentView addSubview:_toolbar];
}

#pragma mark - 设置frame
- (void)setStatusFrame:(WSStatusFrame *)statusFrame {
    _statusFrame = statusFrame;
    
    WSStatus *status = statusFrame.status;
    WSUser *user = status.user;
    
    /** 原创微博整体 */
    _originalView.frame = statusFrame.originalViewF;
    
    /** 头像 */
    _iconView.frame = statusFrame.iconViewF;
    _iconView.user = user;
    
    /** 昵称 */
    _nameLable.frame = statusFrame.nameLableF;
    _nameLable.text = user.name;
    
    /** 会员图标 */
    if (user.vip) { // 是会员
        _vipView.hidden = NO;
        _nameLable.textColor = [UIColor orangeColor];
        
        _vipView.frame = statusFrame.vipViewF;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        _vipView.image = [UIImage imageNamed:vipName];
    } else {// 非会员
        _nameLable.textColor = [UIColor blackColor];
        _vipView.hidden = YES;
    }
    
    /** 时间 */
    NSString *created_at = status.created_at;
    _timeLable.text = created_at;
    CGFloat timeLableX = _nameLable.x;
    CGFloat timeLableY = CGRectGetMaxY(_nameLable.frame) + WSStatusCellBorderW;
    CGSize timeSize = [created_at sizeWithFont:WSStatusCellTimeFont];
    _timeLable.frame = (CGRect){{timeLableX,timeLableY},timeSize};
    
    /** 来源 */
    CGFloat sourceLableX = CGRectGetMaxX(_timeLable.frame) + WSStatusCellBorderW;
    CGFloat sourceLableY = timeLableY;
    CGSize sourceSize = [status.source sizeWithFont:WSStatusCellSourceFont];
    _sourceLable.frame = (CGRect){{sourceLableX,sourceLableY},sourceSize};
    _sourceLable.text = status.source;
    
    /** 正文 */
    _contentLable.frame = statusFrame.contentLableF;
    _contentLable.text = status.text;
    
    /** 配图 */
    if (status.pic_urls.count) {// 有配图
        _photosView.hidden = NO;
//        _photosView.photosArr = status.pic_urls;
        _photosView.status = status;
        _photosView.frame = statusFrame.photosViewF;
        
    } else {// 无配图
        _photosView.hidden = YES;
    }
    
    
    /*---------------- 转发微博 ------------------*/
    /** 转发微博整体 */
    _retweetView.frame = statusFrame.retweetViewF;
    
    //转发微博
    WSStatus *retweeted_status = status.retweeted_status;
    
    /** 转发微博正文+昵称 */
    _retweetContentLable.frame = statusFrame.retweetContentLableF;
    NSString *text = [NSString stringWithFormat:@"@%@ : %@",retweeted_status.user.name,retweeted_status.text];
    _retweetContentLable.text = text;
    
    /** 转发微博的配图 */
    if (retweeted_status.pic_urls.count) {// 有配图
        _retweetPhotosView.hidden = NO;
//        _retweetPhotosView.photosArr = retweeted_status.pic_urls;
        _retweetPhotosView.status = retweeted_status;
        _retweetPhotosView.frame = statusFrame.retweetPhotosViewF;
        
    } else {// 无配图
        _retweetPhotosView.hidden = YES;
    }
    
    
    /*---------------- 工具条 ----------------*/
    /** 工具条 */
    _toolbar.frame = statusFrame.toolbarF;
    _toolbar.status = status;
}


@end
