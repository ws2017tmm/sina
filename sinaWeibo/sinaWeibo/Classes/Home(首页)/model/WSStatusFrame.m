//
//  WSStatusFrame.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/8/23.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSStatusFrame.h"
#import "WSStatus.h"
#import "WSUser.h"
#import "WSStatusPhotosView.h"

@interface WSStatusFrame ()


@end


@implementation WSStatusFrame

- (void)setStatus:(WSStatus *)status {
    _status = status;
    
    //用户
    WSUser *user = status.user;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /*---------------- 原创微博 ----------------*/
    // 头像
    CGFloat iconViewWH = 40;
    CGFloat iconViewX = WSStatusCellBorderW;
    CGFloat iconViewY = WSStatusCellBorderW;
    _iconViewF = CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH);
    
    // 昵称
    CGFloat nameViewX = CGRectGetMaxX(_iconViewF) + WSStatusCellBorderW;
    CGFloat nameViewY = iconViewY;
    CGSize nameLableSize = [user.name sizeWithFont:WSStatusCellNameFont];
    _nameLableF = (CGRect){{nameViewX,nameViewY},nameLableSize};
    
    // 会员图标
    if (user.vip) {// 是会员
        CGFloat vipViewWH = 15;
        CGFloat vipViewX = CGRectGetMaxX(_nameLableF) + WSStatusCellBorderW;
        CGFloat vipViewY = nameViewY;
        _vipViewF = CGRectMake(vipViewX, vipViewY, vipViewWH, vipViewWH);
    }
    
    // 时间
    CGFloat timeLableX = nameViewX;
    CGFloat timeLableY = CGRectGetMaxY(_nameLableF) + WSStatusCellBorderW;
    CGSize timeSize = [status.created_at sizeWithFont:WSStatusCellTimeFont];
    _timeLableF = (CGRect){{timeLableX,timeLableY},timeSize};
    
    // 来源
    CGFloat sourceLableX = CGRectGetMaxX(_timeLableF) + WSStatusCellBorderW;
    CGFloat sourceLableY = timeLableY;
    CGSize sourceSize = [status.source sizeWithFont:WSStatusCellSourceFont];
    _sourceLableF = (CGRect){{sourceLableX,sourceLableY},sourceSize};
    
    // 正文
    CGFloat contentLableX = iconViewX;
    CGFloat contentLableY = MAX(CGRectGetMaxY(_iconViewF), CGRectGetMaxY(_timeLableF)) + WSStatusCellBorderW;
    CGFloat maxW = cellW - 2 * contentLableX;
    CGSize contentSize = [status.text sizeWithFont:WSStatusCellContentFont maxW:maxW];
    _contentLableF = (CGRect){{contentLableX,contentLableY},contentSize};
    
    //原创微博整体的高度
    CGFloat originalViewH;
    // 配图
    if (status.pic_urls.count) {// 有配图
        CGFloat photosViewX = contentLableX;
        CGFloat photosViewY = CGRectGetMaxY(_contentLableF) + WSStatusCellBorderW;
        CGSize photosSize = [WSStatusPhotosView sizeWithPhotoCount:status.pic_urls.count];
        _photosViewF = (CGRect){{photosViewX, photosViewY}, photosSize};
        
        originalViewH = CGRectGetMaxY(_photosViewF);
    } else {// 无配图
        originalViewH = CGRectGetMaxY(_contentLableF);
    }
    
    // 原创微博整体
    CGFloat originalViewX = 0;
    CGFloat originalViewY = WSStatusCellMargin;
    CGFloat originalViewW = cellW;
    _originalViewF = CGRectMake(originalViewX, originalViewY, originalViewW, originalViewH);
    
    CGFloat toolbarY;
    
    
    /*---------------- 转发微博 ------------------*/
    if (status.retweeted_status) {// 有转发微博
        WSStatus *retweetStatus = status.retweeted_status;
        WSUser *retweetUser = retweetStatus.user;
        
        // 转发微博正文+昵称
        CGFloat retweetContentLableX = WSStatusCellBorderW;
        CGFloat retweetContentLableY = WSStatusCellBorderW;
        NSString *retweetText = [NSString stringWithFormat:@"@%@ : %@",retweetUser.name,retweetStatus.text];
        CGSize retweetContentSize = [retweetText sizeWithFont:WSStatusCellRetweetContentFont maxW:maxW];
        _retweetContentLableF = (CGRect){{retweetContentLableX,retweetContentLableY},retweetContentSize};
        
        //转发微博整体的高度
        CGFloat retweetH;
        /** 转发微博的配图 */
        if (retweetStatus.pic_urls.count) {// 有配图
            CGFloat retweetPhotosViewX = retweetContentLableX;
            CGFloat retweetPhotosViewY = CGRectGetMaxY(_retweetContentLableF) + WSStatusCellBorderW;
            CGSize retweetPhotosSize = [WSStatusPhotosView sizeWithPhotoCount:retweetStatus.pic_urls.count];
            _retweetPhotosViewF = (CGRect){{retweetPhotosViewX, retweetPhotosViewY}, retweetPhotosSize};
            
            retweetH = CGRectGetMaxY(_retweetPhotosViewF);
        } else {// 没配图
            retweetH = CGRectGetMaxY(_retweetContentLableF);
        }
        
        /** 被转发微博整体 */
        CGFloat retweetX = 0;
        CGFloat retweetY = CGRectGetMaxY(self.originalViewF);
        CGFloat retweetW = cellW;
        _retweetViewF = CGRectMake(retweetX, retweetY, retweetW, retweetH);
        
        toolbarY = CGRectGetMaxY(_retweetViewF);
    } else {
        toolbarY = CGRectGetMaxY(_originalViewF);
    }
    
    
    /*---------------- 工具条 ----------------*/
    /** 工具条 */
    CGFloat toolbarX = 0;
    CGFloat toolbarW = cellW;
    CGFloat toolbarH = 35;
    self.toolbarF = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
    
    /* cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.toolbarF);
    
}

@end
