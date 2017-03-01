//
//  WSPhotoBrowserView.m
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "WSPhotoBrowserView.h"
#import "WSIndicatorView.h"
#import "WSPhotoBrowserConfig.h"
#import "UIImageView+WebCache.h"
#import "WSBrowserToolBarView.h"

@interface WSPhotoBrowserView() <UIScrollViewDelegate>
@property (nonatomic,strong) WSIndicatorView *indicatorView;
/** 点按一下 */
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;
/** 点按两下 */
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;
/** 长按手势 */
@property (nonatomic,strong) UILongPressGestureRecognizer *longPress;
/** 捏合手势 */
@property (nonatomic,strong) UIPinchGestureRecognizer *pinchGesture;
/** 图片下载成功为YES 否则为NO */
@property (nonatomic, assign) BOOL hasLoadedImage;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) UIImage *placeHolderImage;
@property (nonatomic, strong) UIButton *reloadButton;
/** 缩放比例 */
@property (nonatomic,assign) CGFloat totalScale;

@end

@implementation WSPhotoBrowserView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollview];
        //添加单击、双击、长按、捏合事件
        [self addGestureRecognizer:self.singleTap];
        [self addGestureRecognizer:self.doubleTap];
        [self addGestureRecognizer:self.longPress];
        [self addGestureRecognizer:self.pinchGesture];
    }
    return self;
}

- (UIScrollView *)scrollview
{
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] init];
        _scrollview.frame = CGRectMake(0, 0, kAPPWidth, kAppHeight);
        [_scrollview addSubview:self.imageview];
        _scrollview.delegate = self;
        _scrollview.clipsToBounds = YES;
    }
    return _scrollview;
}

- (UIImageView *)imageview
{
    if (!_imageview) {
        _imageview = [[UIImageView alloc] init];
        _imageview.frame = CGRectMake(0, 0, kAPPWidth, kAppHeight);
        _imageview.userInteractionEnabled = YES;
    }
    return _imageview;
}

#pragma mark - 添加四个手势
- (UITapGestureRecognizer *)singleTap
{
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.numberOfTouchesRequired = 1;
        //只能有一个手势存在
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];
        
    }
    return _singleTap;
}

- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired  = 1;
    }
    return _doubleTap;
}

- (UILongPressGestureRecognizer *)longPress
{
    if (!_longPress) {
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongPress:)];
        _longPress.minimumPressDuration = 1;
        _longPress.numberOfTouchesRequired  = 1;
    }
    return _longPress;
}

- (UIPinchGestureRecognizer *)pinchGesture
{
    if (!_pinchGesture) {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    }
    return _pinchGesture;
}

#pragma mark - 四个手势的触摸事件
#pragma mark - 双击
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    //图片加载完之后才能响应双击放大
    if (!self.hasLoadedImage) {
        return;
    }
    CGPoint touchPoint = [recognizer locationInView:self];
    if (self.scrollview.zoomScale <= 1.0) {
        
        CGFloat scaleX = touchPoint.x + self.scrollview.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + self.scrollview.contentOffset.y;//需要放大的图片的Y点
        [self.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
        
    } else {
        [self.scrollview setZoomScale:1.0 animated:YES]; //还原
    }
}

#pragma mark - 单击
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.singleTapBlock) {
        self.singleTapBlock(recognizer);
    }
}

#pragma mark - 长按
- (void)handlelongPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        WSBrowserToolBarView *toolBar = [WSBrowserToolBarView defaultToolbarView];
        toolBar.frame = self.bounds;
        [toolBar show];
    }
}

#pragma mark - 捏合
#define MaxSCale 2.0  //最大缩放比例
#define MinScale 0.5  //最小缩放比例
- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGesture {
    CGFloat scale = pinchGesture.scale;
    
    //放大情况
    if(scale > 1.0){
        if(self.totalScale > MaxSCale) return;
    }
    //缩小情况
    if (scale < 1.0) {
        if (self.totalScale < MinScale) return;
    }
    self.transform = CGAffineTransformScale(self.transform, scale, scale);
    self.totalScale *=scale;
    pinchGesture.scale = 1.0;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _indicatorView.progress = progress;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    if (_reloadButton) {
        [_reloadButton removeFromSuperview];
    }
    _imageUrl = url;
    _placeHolderImage = placeholder;
    //添加进度指示器
    WSIndicatorView *indicatorView = [[WSIndicatorView alloc] init];
    indicatorView.viewMode = WSIndicatorViewModeLoopDiagram;
    indicatorView.center = CGPointMake(kAPPWidth * 0.5, kAppHeight * 0.5);
    self.indicatorView = indicatorView;
    [self addSubview:indicatorView];
    
    //SDWebImage加载图片
    __weak __typeof(self)weakSelf = self;
    [_imageview sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.indicatorView.progress = (CGFloat)receivedSize / expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [_indicatorView removeFromSuperview];

        if (error) {
            //图片加载失败的处理，此处可以自定义各种操作（...）
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            strongSelf.reloadButton = button;
            button.layer.cornerRadius = 2;
            button.clipsToBounds = YES;
            button.bounds = CGRectMake(0, 0, 200, 40);
            button.center = CGPointMake(kAPPWidth * 0.5, kAppHeight * 0.5);
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
            [button setTitle:@"原图加载失败，点击重新加载" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:strongSelf action:@selector(reloadImage) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
            return;
        }
        strongSelf.hasLoadedImage = YES;//图片加载成功
    }];
}

- (void)reloadImage
{
    [self setImageWithURL:_imageUrl placeholderImage:_placeHolderImage];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _indicatorView.center = _scrollview.center;
    _scrollview.frame = self.bounds;
    _reloadButton.center = CGPointMake(kAPPWidth * 0.5, kAppHeight * 0.5);
    [self adjustFrames];
}

- (void)adjustFrames
{
    CGRect frame = self.scrollview.frame;
    if (self.imageview.image) {
        CGSize imageSize = self.imageview.image.size;
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        if (kIsFullWidthForLandScape) {
            CGFloat ratio = frame.size.width/imageFrame.size.width;
            imageFrame.size.height = imageFrame.size.height*ratio;
            imageFrame.size.width = frame.size.width;
        } else{
            if (frame.size.width<=frame.size.height) {
           
                CGFloat ratio = frame.size.width/imageFrame.size.width;
                imageFrame.size.height = imageFrame.size.height*ratio;
                imageFrame.size.width = frame.size.width;
            }else{
                CGFloat ratio = frame.size.height/imageFrame.size.height;
                imageFrame.size.width = imageFrame.size.width*ratio;
                imageFrame.size.height = frame.size.height;
            }
        }
        
        self.imageview.frame = imageFrame;
        self.scrollview.contentSize = self.imageview.frame.size;
        self.imageview.center = [self centerOfScrollViewContent:self.scrollview];
        

        CGFloat maxScale = frame.size.height/imageFrame.size.height;
        maxScale = frame.size.width/imageFrame.size.width>maxScale?frame.size.width/imageFrame.size.width:maxScale;
        maxScale = maxScale>kMaxZoomScale?maxScale:kMaxZoomScale;

        self.scrollview.minimumZoomScale = kMinZoomScale;
        self.scrollview.maximumZoomScale = maxScale;
        self.scrollview.zoomScale = 1.0f;
    }else{
        frame.origin = CGPointZero;
        self.imageview.frame = frame;
        self.scrollview.contentSize = self.imageview.frame.size;
    }
    self.scrollview.contentOffset = CGPointZero;
    
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.imageview.center = [self centerOfScrollViewContent:scrollView];
}
@end
