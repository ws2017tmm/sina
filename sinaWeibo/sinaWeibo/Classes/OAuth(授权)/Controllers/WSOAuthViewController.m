//
//  WSOAuthViewController.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/4/8.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSOAuthViewController.h"
#import "AFNetworking.h"
#import "WSAccount.h"
#import "WSAccountTool.h"
#import "UIWindow+Extension.h"


#define WSAppKey @"978930168"
#define WSRedirectURI @"https://www.baidu.com"
#define WSAppSecret @"dfa5ee18eb980f32b60143ce3660eadb"

@interface WSOAuthViewController ()<UIWebViewDelegate>

@end

@implementation WSOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建一个webView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    //拼接url
    NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",WSAppKey,WSRedirectURI];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //webView发送请求
    [webView loadRequest:request];
    
}

#pragma mark - UIWebView代理方法

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    //获得url地址
    NSString *url = request.URL.absoluteString;
    
    NSRange range = [url rangeOfString:@"code="];
    
    if (range.length) {//是回调地址
        //截取code的参数值
        NSUInteger index = range.location + range.length;
        NSString *code = [url substringFromIndex:index];
        
        //用code换取accessToken
        [self accessTokenWithCode:code];
        
        //禁止加载回调地址
        return NO;
    }
    
    
    NSLog(@"request = %@",request.URL.absoluteString);
    
    return YES;
}

//用用服务器返回的code换取access_token
- (void)accessTokenWithCode:(NSString *)code {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 1.拼接请求参数
    params[@"client_id"] = WSAppKey;
    params[@"client_secret"] = WSAppSecret;
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri"] = WSRedirectURI;
    params[@"code"] = code;
    
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"uploadProgress = %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        //这个用户的信息,字典转模型对象
        WSAccount *account = [WSAccount accountWithDict:responseObject];
        
        // 存储用户信息
        [WSAccountTool saveAccount:account];
        
        // 切换窗口的根控制器
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window swichToRootViewController];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error = %@",error);
    }];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
@end
