//
//  WSComposeViewController.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/8/30.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSComposeViewController.h"
#import "WSAccountTool.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "WSTextView.h"
#import "WSComposeView.h"
#import "WSKeyboardToolbar.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "WSNavigationController.h"

@interface WSComposeViewController () <WSKeyboardToolbarDelegate,UITextViewDelegate, UICollectionViewDataSource,UICollectionViewDelegate,JKImagePickerControllerDelegate>

@property (weak, nonatomic) WSTextView *textView;

@property (weak, nonatomic) WSComposeView *photosView;

@property (weak, nonatomic) WSKeyboardToolbar *toolbar;

/** 选择图片后，存放图片的array */
@property (nonatomic, strong) NSMutableArray *assetsArray;

@property (nonatomic, retain) UICollectionView *collectionView;

@end

@implementation WSComposeViewController

#pragma mark - 销毁通知
- (void)dealloc {
    [WSNotificationCenter removeObserver:self];
}

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置状态栏
    [self setupNav];
    
    //设置textView
    [self setupTextView];
    
    //添加keyboardToolbar
    [self setupKeyboardToorbar];
    
    //添加相册
    [self setupPhotosView];
}

/** 在这里设置发送按钮不可点才好使,不知道为什么 */
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

#pragma mark - 初始化和设置的方法
//设置状态栏
- (void)setupNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    NSString *headTitle = @"发微博";
    NSString *userName = [WSAccountTool account].user_name;
    if (userName) {
        UILabel *titleView = [[UILabel alloc] init];
        titleView.font = [UIFont systemFontOfSize:14];
        titleView.width = 200;
        titleView.height = 44;
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.numberOfLines = 0;
        
        NSString *title = [NSString stringWithFormat:@"%@\n%@",headTitle,userName];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:title];
        [attrStr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} range:[title rangeOfString:headTitle]];
        NSDictionary *dict = @{
                               NSFontAttributeName : [UIFont systemFontOfSize:13],
                               NSForegroundColorAttributeName : WSColor(111, 111, 111)
                               };
        [attrStr addAttributes:dict range:[title rangeOfString:userName]];
        titleView.attributedText = attrStr;
        
        self.navigationItem.titleView = titleView;
    } else {
        self.title = headTitle;
    }
}

//设置textView
- (void)setupTextView {
    WSTextView *textView = [[WSTextView alloc] init];
    textView.delegate = self;
    textView.frame = self.view.bounds;
    textView.placeholder = @"分享新鲜事...";
    [self.view addSubview:textView];
    self.textView = textView;
    
    //检测文本改变的通知
    [WSNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
    //检测键盘frame改变的通知
    [WSNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//添加keyboardToolbar
- (void)setupKeyboardToorbar {
    WSKeyboardToolbar *toolbar = [WSKeyboardToolbar toolbar];
    toolbar.delegate = self;
    toolbar.height = 44;
    toolbar.width = self.view.width;
    toolbar.x = 0;
    toolbar.y = self.view.height - toolbar.height;
    [[UIApplication sharedApplication].keyWindow addSubview:toolbar];
//    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
}

//添加相册
- (void)setupPhotosView {
    WSComposeView *photosView = [[WSComposeView alloc] init];
    
    photosView.y = 100;
    photosView.width = self.view.width;
    // 随便写的
    photosView.height = self.view.height;
    [self.textView addSubview:photosView];
    self.photosView = photosView;
}

#pragma mark - 监听方法
//取消按钮的点击
- (void)cancel {
    //先退出键盘
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        //...
    }];
}

//发送微博按钮的点击
- (void)send {
    if (self.assetsArray.count) { //发送有图片的微博
        [self sendStatusWithImage];
    } else { //发送没有图片的微博
        [self sendStatusWithoutImage];
    }
    [self cancel];
}

//文本框文字的变化
- (void)textDidChange {
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

//检测键盘frame改变的通知
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
//    NSLog(@"notification.userInfo = %@",notification.userInfo);
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            self.toolbar.y = self.view.height - self.toolbar.height;
        } else {
            self.toolbar.y = keyboardF.origin.y - self.toolbar.height;
        }
    }];
}

#pragma mark - 发送微博
//发送有图的微博
- (void)sendStatusWithImage {
    // URL: https://upload.api.weibo.com/2/statuses/upload.json
    // 参数:
    /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**	access_token true string*/
    /**	pic true binary 微博的配图。*/
    
    // 1.请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"status"] = self.textView.text;
    parameters[@"access_token"] = [WSAccountTool account].access_token;
    
    [mgr POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 拼接文件数据
        UIImage *image = [self.assetsArray firstObject];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        //结束刷新
        [MBProgressHUD showError:@"发送失败"];
    }];
}

//发送无图的微博
- (void)sendStatusWithoutImage {
    
    // 参数:
    /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**	access_token true string*/
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"status"] = self.textView.text;
    parameters[@"access_token"] = [WSAccountTool account].access_token;
    
    [mgr POST:@"https://api.weibo.com/2/statuses/update.json" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        //结束刷新
        [MBProgressHUD showError:@"发送失败"];
    }];
}

#pragma mark - WSKeyboardToolbarDelegate
- (void)keyboardToolbar:(WSKeyboardToolbar *)toolbar didSelectButton:(WSKeyboardToolbarButtonType)type {
    switch (type) {
        case WSKeyboardToolbarButtonTypeCamera: //相机
            [self openCamera];
            break;
            
        case WSKeyboardToolbarButtonTypePicture: //相册
            [self openAlbum];
            break;
            
        case WSKeyboardToolbarButtonTypeMention: //@
            NSLog(@"----@");
            break;
            
        case WSKeyboardToolbarButtonTypeTrend: //#
            NSLog(@"----#");
            break;
            
        case WSKeyboardToolbarButtonTypeEmotion: //表情
            NSLog(@"----表情");
            break;
            
            
        default:
            break;
    }
}

#pragma mark - toolbar上的按钮点击事件

//相机
- (void)openCamera
{
//    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

//相册
- (void)openAlbum
{
    // UIImagePickerControllerSourceTypePhotoLibrary > UIImagePickerControllerSourceTypeSavedPhotosAlbum
    //    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
//    imagePickerController.selectedAssetArray = self.assetsArray;
    WSNavigationController *navigationController = [[WSNavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
    
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    
    self.assetsArray = [NSMutableArray arrayWithArray:assets];
    
    [self.collectionView reloadData];
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

static NSString *kPhotoCellIdentifier = @"kPhotoCellIdentifier";

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WSComposeView *cell = (WSComposeView *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    
    cell.asset = self.assetsArray[indexPath.row];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 60);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)[indexPath row]);
    
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5.0;
        layout.minimumInteritemSpacing = 5.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 200, CGRectGetWidth(self.view.frame)-30, 200) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[WSComposeView class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [self.view addSubview:_collectionView];
        
    }
    return _collectionView;
}

#pragma mark - UIImagePickerControllerDelegate
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    
//    // info中就包含了选择的图片
//    UIImage *image = info[UIImagePickerControllerOriginalImage];
//    
//    // 添加图片到photosView中
//    [self.photosView addPhoto:image];
//}

//- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
//{
//    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
//    
//    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
//    ipc.sourceType = type;
//    ipc.delegate = self;
//    [self presentViewController:ipc animated:YES completion:nil];
//}

#pragma mark - UITextViewDelegate
//退出键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.textView resignFirstResponder];
}

@end
