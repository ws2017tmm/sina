//
//  WSBrowserToolBarView.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/9/5.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSBrowserToolBarView.h"
#import "WSPhotoBrowserConfig.h"
#import "MBProgressHUD+MJ.h"

@interface WSBrowserToolBarView ()

@property (strong, nonatomic) UIView *containerView;

@end

@implementation WSBrowserToolBarView

//全局唯一的变量
static id _instance;

#pragma mark - 利用GCD实现单例

//重写alloc方法,alloc方法底层是调用--allocWithZone:
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

//提供方法供外界方便访问---一般以 share + (类名去掉前缀)
+ (instancetype)defaultToolbarView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

//重写copyWithZone:方法,防止外界利用copy创建对象
- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

#if __has_feature(objc_arc)//ARC

#else//MRC

-(NSUInteger)retainCount { return 1; }
-(instancetype)retain { return self; }
-(oneway void)release {}
-(instancetype)autorelease {return self; }

#endif


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.2;
        
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        UIView *containerView = [[UIView alloc] init];
        containerView.backgroundColor = [UIColor lightGrayColor];
        [window addSubview:containerView];
        self.containerView = containerView;
        
        //四个button
        [self createBtnWithTitle:@"保存图片" btnType:WSBrowserToolBarViewBtnTypeSaveImage];
        [self createBtnWithTitle:@"转发微博" btnType:WSBrowserToolBarViewBtnTypeRetweetStatus];
        [self createBtnWithTitle:@"赞" btnType:WSBrowserToolBarViewBtnTypeAttitude];
        [self createBtnWithTitle:@"取消" btnType:WSBrowserToolBarViewBtnTypeCancle];
        
    }
    return self;
}

- (void)createBtnWithTitle:(NSString *)title btnType:(WSBrowserToolBarViewBtnType)btnType {
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_image_placeholder"] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    if (btnType == WSBrowserToolBarViewBtnTypeAttitude) {
        [btn setTitle:@"取消赞" forState:UIControlStateSelected];
    }
    btn.tag = btnType;
    [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:btn];
}

- (void)btnDidClick:(UIButton *)button {
    button.selected = !button.selected;
    switch (button.tag) {
        case WSBrowserToolBarViewBtnTypeSaveImage: //保存图片
            [WSNotificationCenter postNotificationName:WSBrowserToolBarViewSaveImageButtonDidClickNotification object:button];
            [self removeSelf];
            break;
            
        case WSBrowserToolBarViewBtnTypeRetweetStatus: //转发微博
            [WSNotificationCenter postNotificationName:WSBrowserToolBarViewRetweetButtonDidClickNotification object:button];
            [self removeSelf];
            break;
            
        case WSBrowserToolBarViewBtnTypeAttitude: //赞
            if (button.selected) { //赞
                [WSNotificationCenter postNotificationName:WSBrowserToolBarViewAttitudeButtonDidClickNotification object:button];
                [self removeSelf];
                [MBProgressHUD showSuccess:@"已赞"];
            } else { //取消赞
                [WSNotificationCenter postNotificationName:WSBrowserToolBarViewAttitudeButtonDidClickNotification object:button];
                [self removeSelf];
                [MBProgressHUD showSuccess:@"已取消"];
            }
            break;
            
        case WSBrowserToolBarViewBtnTypeCancle: //取消
            [self removeSelf];
            break;
            
        default:
            break;
            
    }
}

- (void)show {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self setupFrame];
    NSLog(@"self.height = %.f",self.height);
    NSLog(@"self.containerView.height = %.f",self.containerView.height);
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.y = self.height - self.containerView.height;
    }];
}

- (void)setupFrame {
    CGFloat containerViewX = 0;
    CGFloat containerViewY = kAppHeight;
    CGFloat containerViewW = kAPPWidth;
    CGFloat containerViewH = 140;
    self.containerView.frame = CGRectMake(containerViewX, containerViewY, containerViewW, containerViewH);
    
    NSUInteger count = self.containerView.subviews.count;
    CGFloat btnX = 0;
    CGFloat btnW = self.containerView.width;
    CGFloat btnH = (self.containerView.height - 3) / count;//3为button之间的间距(0.5+0.5+2)
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.containerView.subviews[i];
        btn.x = btnX;
        btn.width = btnW;
        btn.height = btnH;
        btn.y = (btnH + 0.5) * i;
        if (i == count - 1) {
            btn.y = (btnH + 0.5) * i + 2;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self removeSelf];
}

- (void)removeSelf {
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.y = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
//        [self.containerView removeFromSuperview];
    }];
}


@end
