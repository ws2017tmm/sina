//
//  WSHomeViewController.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/3/29.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSHomeViewController.h"
#import "WSTitleButton.h"
#import "WSDropDownMenu.h"
#import "WSTitleMenuViewController.h"
#import "AFNetworking.h"
#import "WSAccountTool.h"
#import "MJExtension.h"
#import "WSStatusCell.h"
#import "WSStatus.h"
#import "WSUser.h"
#import "UIImageView+WebCache.h"
#import "WSStatusFrame.h"
#import "MJRefresh.h"
#import "WSRetweetController.h"
#import "WSNavigationController.h"
#import "WSStatusTool.h"

@interface WSHomeViewController ()<WSDropDownMenuDelegate>

@property (strong, nonatomic) NSMutableArray *statusFrameArr;

@end

@implementation WSHomeViewController

#pragma mark - 懒加载微博数组
- (NSMutableArray *)statusFrameArr {
    if (!_statusFrameArr) {
        _statusFrameArr = [NSMutableArray array];
    }
    return _statusFrameArr;
}

#pragma mark - 销毁通知
- (void)dealloc {
    [WSNotificationCenter removeObserver:self];
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = WSColor(211, 211, 211);
    
    //设置导航条
    [self setupNavigationItem];
    
    //设置用户信息(昵称)
    [self setupUserInfo];
    
    //加载微博数据
//    [self loadStatusData];
    
    //集成下拉刷新更多
    [self loadNewStatusData];
    
    //集成上拉加载以前的数据
    [self loadOldStatusData];
    
    //监听转发按钮的点击
    [WSNotificationCenter addObserver:self selector:@selector(retweetButtonDidClick:) name:WSRetweetButtonDidClickNotification object:nil];
}

#pragma mark - 设置导航条内容
- (void)setupNavigationItem {
    //左边
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(friendsearch) image:@"navigationbar_friendsearch" highlightedImage:@"navigationbar_friendsearch_highlighted"];
    
    //右边
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(pop) image:@"navigationbar_pop" highlightedImage:@"navigationbar_pop_highlighted"];
    
    //中间
    NSString *userName = [WSAccountTool account].user_name;
    WSTitleButton *titleButton = [[WSTitleButton alloc] init];
    [titleButton setTitle:userName?userName : @"首页" forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleButton;
}

#pragma mark - 设置用户信息(获得昵称)
- (void)setupUserInfo {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    //读取账号信息
    WSAccount *account = [WSAccountTool account];
    //参数
    NSDictionary *parameters = @{
                                 @"access_token" : account.access_token,
                                 @"uid" : account.uid
                                 };
    [mgr GET:@"https://api.weibo.com/2/users/show.json" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //得到用户的昵称
        NSString *userName = responseObject[@"name"];
        
        //更换标题的内容
        WSTitleButton * titleButton = (WSTitleButton *)self.navigationItem.titleView;
        [titleButton setTitle:userName forState:UIControlStateNormal];
        
        //将账户存入沙盒
        account.user_name = userName;
        [WSAccountTool saveAccount:account];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}

#pragma mark - 加载微博数据
- (void)loadStatusData {
    //https://api.weibo.com/2/statuses/friends_timeline.json
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    //请求参数
    WSAccount *account = [WSAccountTool account];
    NSDictionary *parameters = @{
                                 @"access_token" : account.access_token
                                 };
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        
        //字典转模型
        NSArray *statusArr = [WSStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        //微博模型转微博frame模型
        self.statusFrameArr = [self statusFrameArrWithStatus:statusArr];
        
        //刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}

#pragma mark - 下拉刷新更多
- (void)loadNewStatusData {
    //创建下拉刷新更多控件
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshNewStatusData:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:refreshControl];
    
    [self refreshNewStatusData:refreshControl];
}

//监听下拉刷新,获取数据
- (void)refreshNewStatusData:(UIRefreshControl *)refreshControl {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    //since_id
    WSStatus *status = [[self.statusFrameArr firstObject] status];
    //请求参数
    WSAccount *account = [WSAccountTool account];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.access_token;
    if (status) {
        parameters[@"since_id"] = status.idstr;
    }
    
    // 定义一个block处理返回的字典数据
    void(^dealingResult)(NSArray *) = ^(NSArray *statuses) {
        //字典转模型
        NSArray *statusArr = [WSStatus mj_objectArrayWithKeyValuesArray:statuses];
        
        //微博模型转微博frame模型
        NSArray *statusFrameArr = [self statusFrameArrWithStatus:statusArr];
        
        //将最新的微博数据插入到数组最前面
        NSRange range = NSMakeRange(0, statusFrameArr.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrameArr insertObjects:statusFrameArr atIndexes:set];
        
        //刷新tableView
        [self.tableView reloadData];
        
        //结束刷新
        [refreshControl endRefreshing];
        
        //显示刷新最新微博的条数
        [self showNewStatusCount:statusArr.count];
    };
    
    //先尝试从数据库中获取数据
    NSArray *statuses = [WSStatusTool statusesWithParameters:parameters];
    if (statuses.count) { //数据库中有数据
        dealingResult(statuses);
        
    } else { //数据库中没有数据
        [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject = %@",responseObject);
            dealingResult(responseObject[@"statuses"]);
            
            //存储微博数据
            [WSStatusTool saveStatuses:responseObject[@"statuses"]];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error = %@",error);
        }];
    }
}

#pragma mark - 下拉刷新更多
- (void)loadOldStatusData {
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshOldStatusData)];
    // 设置了底部inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    // 忽略掉底部inset
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
}

//上拉加载
- (void)refreshOldStatusData {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    //since_id
    WSStatus *status = [[self.statusFrameArr lastObject] status];
    //请求参数
    WSAccount *account = [WSAccountTool account];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.access_token;
    if (status) {
        parameters[@"max_id"] = @(status.idstr.longLongValue - 1);
    }
    
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"responseObject = %@",responseObject);
        
        //字典转模型
        NSArray *statusArr = [WSStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        //微博模型转微博frame模型
        NSArray *statusFrameArr = [self statusFrameArrWithStatus:statusArr];
        
        //将旧的微博数据加到数组最后面
        [self.statusFrameArr addObjectsFromArray:statusFrameArr];
        
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        
        //刷新tableView
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 微博模型转微博frame模型
- (NSMutableArray *)statusFrameArrWithStatus:(NSArray *)statusArr {
    NSMutableArray *tempFrameArr = [NSMutableArray array];
    for (WSStatus *status in statusArr) {
        WSStatusFrame *f = [[WSStatusFrame alloc] init];
        f.status = status;
        [tempFrameArr addObject:f];
    }
    return tempFrameArr;
}

//显示最新微博的条数
- (void)showNewStatusCount:(NSUInteger)count {
    UILabel *lable = [[UILabel alloc] init];
    lable.width = [UIScreen mainScreen].bounds.size.width;
    lable.height = 30;
    lable.y = CGRectGetMaxY(self.navigationController.navigationBar.frame) - lable.height;
    lable.font = [UIFont systemFontOfSize:16];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    
    if (count) {
        lable.text = [NSString stringWithFormat:@"共有%d条最新的微博数据",(int)count];
    } else {
        lable.text = @"没有最新的微博数据";
    }
    
    //lable添加的位置
    [self.navigationController.view insertSubview:lable belowSubview:self.navigationController.navigationBar];
    
    //执行动画
    CGFloat duration = 1.0;
    [UIView animateWithDuration:duration animations:^{
        lable.transform = CGAffineTransformMakeTranslation(0, lable.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration delay:duration options:UIViewAnimationOptionCurveLinear animations:^{
            lable.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [lable removeFromSuperview];
        }];
    }];
}

#pragma mark - navigationItem的监听事件
- (void)friendsearch {
    NSLog(@"friendsearch");
}

- (void)pop {
    NSLog(@"pop");
}

- (void)titleClick:(UIButton *)titleButton {
    //创建下拉菜单
    WSDropDownMenu *menu = [WSDropDownMenu menu];
    menu.delegate = self;
    
    //下拉菜单里的内容
    WSTitleMenuViewController *vc = [[WSTitleMenuViewController alloc] init];
    vc.view.height = 200;
    vc.view.width = 150;
    menu.contentController = vc;
    
    //显示下拉菜单
    [menu showFrom:titleButton];
    
}

#pragma mark - WSDropDownMenuDelegate
//下拉菜单显示
-(void)dropDownMenuDidShow:(WSDropDownMenu *)menu {
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = YES;
}

//下拉菜单消失
-(void)dropDownMenuDidDismiss:(WSDropDownMenu *)menu {
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = NO;
}

#pragma mark - statusToolbar上按钮的点击事件
//转发
- (void)retweetButtonDidClick:(NSNotification *)notification {
    WSStatus *status = notification.userInfo[@"status"];
    WSRetweetController *RC = [[WSRetweetController alloc] init];
    RC.status = status;
    WSNavigationController *nav = [[WSNavigationController alloc] initWithRootViewController:RC];
    [self presentViewController:nav animated:YES completion:^{
        //
    }];
}

#pragma mark - Table view data source

//一共多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statusFrameArr.count;
}

//每行显示什么内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSStatusCell *cell = [WSStatusCell cellForTableView:tableView];
    cell.statusFrame = self.statusFrameArr[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

//返回每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSStatusFrame *statusFrame = self.statusFrameArr[indexPath.row];
    return statusFrame.cellHeight;
}


@end
