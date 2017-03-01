//
//  WSStatusToolbar.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/7/21.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSStatusToolbar.h"
#import "WSStatus.h"

@interface WSStatusToolbar ()

{
    /** 评论 */
    UIButton *_commentBtn;
    /** 转发 */
    UIButton *_retweetBtn;
    /** 赞 */
    UIButton *_attitudeBtn;
}

/** 存放三个按钮 */
@property (strong, nonatomic) NSMutableArray <UIButton *> *btns;

/** 存放两个分割线 */
@property (strong, nonatomic) NSMutableArray <UIImageView *> *dividers;

@end

@implementation WSStatusToolbar

#pragma mark - 懒加载数组
- (NSMutableArray<UIButton *> *)btns {
    if (!_btns) {
        _btns = [[NSMutableArray alloc] init];
    }
    return _btns;
}

- (NSMutableArray<UIImageView *> *)dividers {
    if (!_dividers) {
        _dividers = [[NSMutableArray alloc] init];
    }
    return _dividers;
}

#pragma mark - 创建toolbar
+ (instancetype)toolbar {
    return [[self alloc] init];
}

#pragma mark - 初始化控件
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        /** 转发 */
        _retweetBtn = [self createBtnWithImageName:@"timeline_icon_retweet" title:@"转发" type:WSStatusToolbarTypeRetweet];
        
        /** 评论 */
        _commentBtn = [self createBtnWithImageName:@"timeline_icon_comment" title:@"评论" type:WSStatusToolbarTypeComment];
        
        /** 赞 */
        _attitudeBtn = [self createBtnWithImageName:@"timeline_icon_unlike" title:@"赞" type:WSStatusToolbarTypeAttitude];
        
        //创建分割线
        [self createDivider];
        [self createDivider];
        
    }
    return self;
}

#pragma mark - 创建三个button
- (UIButton *)createBtnWithImageName:(NSString *)imageName title:(NSString *)title type:(WSStatusToolbarType)type {
    
    UIButton *btn = [[UIButton alloc] init];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    btn.tag = type;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if (type == WSStatusToolbarTypeAttitude) {
        [btn setImage:[UIImage imageNamed:@"timeline_icon_unlike_selected"] forState:UIControlStateSelected];
    }
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(toolbarBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [self.btns addObject:btn];
    return btn;
}

#pragma mark - 点击toolbar的按钮
- (void)toolbarBtnDidClick:(UIButton *)button {
    button.selected = !button.selected;
    switch (button.tag) {
        case WSStatusToolbarTypeRetweet://转发
            //发一个通知,让homeViewController接受
            [WSNotificationCenter postNotificationName:WSRetweetButtonDidClickNotification object:button userInfo:@{@"status" : self.status}];
            NSLog(@"WSStatusToolbarTypeRetweet---转发");
            break;
            
        case WSStatusToolbarTypeComment://评论
            NSLog(@"WSStatusToolbarTypeComment---评论");
            break;
            
        case WSStatusToolbarTypeAttitude://赞
            if (button.selected) {
                [self setupBtnTitleWithCount:(self.status.attitudes_count+1) button:_attitudeBtn title:@"赞"];
            } else {
                [self setupBtnTitleWithCount:(self.status.attitudes_count) button:_attitudeBtn title:@"赞"];
            }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 创建两条分割线
- (void)createDivider {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:imageView];
    [self.dividers addObject:imageView];
}

#pragma mark - 部署子控件的frame
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //三个button的位置
    int btnCount = self.btns.count;
    CGFloat btnY = 0;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i < btnCount; i++) {
        UIButton *btn = self.btns[i];
        CGFloat btnX = btnW * i;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    //两条分割线的位置
    CGFloat dividerY = 0;
    CGFloat dividerW = 1;
    CGFloat dividerH = self.height;
    for (int i = 0; i < self.dividers.count; i++) {
        CGFloat dividerX = btnW * (i + 1);
        UIImageView *divider = self.dividers[i];
        divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
    }
}

#pragma mark - 重写setter方法,改变三个button显示的文字
- (void)setStatus:(WSStatus *)status {
    _status = status;
    
    //    status.reposts_count = 580456; // 58.7万
    //    status.comments_count = 100004; // 1万
    //    status.attitudes_count = 604; // 604
    
    //转发
    [self setupBtnTitleWithCount:status.reposts_count button:_retweetBtn title:@"转发"];
    
    //评论
    [self setupBtnTitleWithCount:status.comments_count button:_commentBtn title:@"评论"];
    
    //赞
    [self setupBtnTitleWithCount:status.attitudes_count button:_attitudeBtn title:@"赞"];
}

#pragma mark - 设置按钮的title
- (void)setupBtnTitleWithCount:(int)count button:(UIButton *)btn title:(NSString *)title {
    if (count) {//有值
        if (count < 10000) {
            title = [NSString stringWithFormat:@"%d",count];
        } else {
            double d = count / 10000.0;
            d = round(d);
            title = [NSString stringWithFormat:@"%.1f",d];
            //去掉.0
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }
    [btn setTitle:title forState:UIControlStateNormal];
}






@end
