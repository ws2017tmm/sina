//
//  WSRetweetController.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/9/1.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSRetweetController.h"
#import "WSTextView.h"
#import "WSRetweetView.h"
#import "WSKeyboardToolbar.h"
#import "WSAccountTool.h"
#import "WSStatus.h"
#import "WSUser.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "WSNavigationController.h"


@interface WSRetweetController () <WSKeyboardToolbarDelegate,UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) WSTextView *textView;

@property (weak, nonatomic) WSRetweetView *retweetView;

@property (weak, nonatomic) WSKeyboardToolbar *toolbar;

@end


@implementation WSRetweetController

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
    
    //添加显示原来微博的view
    [self setupPhotosView];
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
    
    NSString *headTitle = @"转发微博";
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
    if (self.status.retweeted_status) { //有转发微博,显示微博内容
        WSUser *user = self.status.retweeted_status.user;
        WSStatus *status = self.status;
        NSString *text = [NSString stringWithFormat:@"//%@:%@",user.name,status.text];
        textView.text = text;
    } else { //没有转发微博,显示占位文字
        textView.placeholder = @"说说分享心得...";
    }
    [self.view addSubview:textView];
    self.textView = textView;
    
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
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
}

//添加显示原来微博的view
- (void)setupPhotosView {
    WSRetweetView *retweetView = [[WSRetweetView alloc] init];
    retweetView.y = 100;
    retweetView.width = self.view.width;
    retweetView.height = 64;
    retweetView.status = self.status;
    [self.textView addSubview:retweetView];
    self.retweetView = retweetView;
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
    /* 
     https://api.weibo.com/2/statuses/repost.json
     POST
     access_token	true	string
     id	true	int64	要转发的微博ID
     */
    
    // 1.请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    long long statusId = [self.status.idstr longLongValue];
    parameters[@"id"] = @(statusId);
    parameters[@"access_token"] = [WSAccountTool account].access_token;
    parameters[@"status"] = self.textView.text;
    
    [mgr POST:@"https://api.weibo.com/2/statuses/repost.json" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        //结束刷新
        [MBProgressHUD showError:@"发送失败"];
    }];
    [self cancel];
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
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

//相册
- (void)openAlbum
{
    // UIImagePickerControllerSourceTypePhotoLibrary > UIImagePickerControllerSourceTypeSavedPhotosAlbum
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    
//    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
//    imagePickerController.delegate = self;
//    imagePickerController.showsCancelButton = YES;
//    imagePickerController.allowsMultipleSelection = YES;
//    imagePickerController.minimumNumberOfSelection = 1;
//    imagePickerController.maximumNumberOfSelection = 9;
//    imagePickerController.selectedAssetArray = self.assetsArray;
//    WSNavigationController *navigationController = [[WSNavigationController alloc] initWithRootViewController:imagePickerController];
//    [self presentViewController:navigationController animated:YES completion:NULL];
//    
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
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
////    [self.retweetView addPhoto:image];
//}

#pragma mark - UITextViewDelegate
//退出键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.textView resignFirstResponder];
}


@end
