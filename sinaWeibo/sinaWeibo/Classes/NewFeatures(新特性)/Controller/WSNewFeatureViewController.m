//
//  WSNewFeatureViewController.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/4/7.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSNewFeatureViewController.h"
#import "WSTabBarController.h"

#define WSImageCount 4

@interface WSNewFeatureViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) UIPageControl *pageControl;

@end

@implementation WSNewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建一个scrollView
    [self createScrollView];
    
    //创建imageView
    [self createImageView];
    
    //创建pageControll
    [self createPageControl];
}

#pragma mark - 创建scrollview
- (void)createScrollView {
    
    //创建scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    //设置scrollView的一些属性
    scrollView.delegate = self;//代理
    scrollView.contentSize = CGSizeMake(self.view.width * WSImageCount, 0);//滚动范围
    scrollView.bounces = NO;//弹簧效果
    scrollView.showsHorizontalScrollIndicator = NO;//隐藏水平滚动条
    scrollView.pagingEnabled = YES;//分页效果
    
    self.scrollView = scrollView;
}

#pragma mark - 创建imageView
- (void)createImageView {
    CGFloat scrollViewW = self.scrollView.width;
    CGFloat scrollViewH = self.scrollView.height;
    //四张图片
    for (int i = 0; i < WSImageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.x = scrollViewW * i;
        imageView.width = scrollViewW;
        imageView.height = scrollViewH;
        
        NSString *imageName = [NSString stringWithFormat:@"new_feature_%d",i+1];
        imageView.image = [UIImage imageNamed:imageName];
        
        //如果是最后一张,就添加按钮
        if (i == WSImageCount -1) {
            //开始微博和分享给大家按钮
            [self addStartSharedButton:imageView];
        }
        
        [self.scrollView addSubview:imageView];
    }
}

#pragma mark - 创建pageControl
- (void)createPageControl {
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    //位置
    pageControl.centerX = self.view.centerX;
    pageControl.centerY = self.view.height - 50;
    
    pageControl.numberOfPages = WSImageCount;//页码数
    pageControl.pageIndicatorTintColor = WSColor(189, 189, 189);//未选中时的颜色
    pageControl.currentPageIndicatorTintColor = WSColor(253, 98, 42);//选中时的颜色
    
    self.pageControl = pageControl;
    [self.view addSubview:pageControl];
}

#pragma mark - 添加开始和分享按钮
- (void)addStartSharedButton:(UIImageView *)imageView {
    //开启交互
    imageView.userInteractionEnabled = YES;
    
    //分享按钮
    UIButton *shareBtn = [[UIButton alloc] init];
    shareBtn.width  = 200;
    shareBtn.height  = 30;
    shareBtn.centerX = imageView.width * 0.5;
    shareBtn.centerY = imageView.height * 0.65;
    
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [shareBtn addTarget:self action:@selector(sharedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:shareBtn];
    // contentEdgeInsets:会影响按钮内部的所有内容(里面的imageView和titleLabel)
    //图片和按钮之间空隙增加一点(titleEdgeInsets只影响titleLable)
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    
    //开始按钮
    UIButton *startBtn = [[UIButton alloc] init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    startBtn.size = startBtn.currentBackgroundImage.size;
    startBtn.centerX = shareBtn.centerX;
    startBtn.centerY = imageView.height * 0.75;
    [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
    
}

//分享按钮的点击事件
- (void)sharedBtnClick:(UIButton *)sharedBtn {
    //状态取反
    sharedBtn.selected = !sharedBtn.selected;
}

//开始按钮的点击事件
- (void)startClick {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[WSTabBarController alloc] init];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = (int)scrollView.contentOffset.x / scrollView.width + 0.5;
    self.pageControl.currentPage = page;
}


@end
