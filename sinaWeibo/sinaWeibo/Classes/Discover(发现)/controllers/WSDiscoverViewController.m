//
//  WSDiscoverViewController.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/3/29.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSDiscoverViewController.h"
#import "WSSearchBar.h"

@interface WSDiscoverViewController () <UITextFieldDelegate>

{
    WSSearchBar *_searchBar;//搜索框
}

@end

@implementation WSDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //创建搜索框
    [self createSearchBar];
}

#pragma mark - 创建搜索框
- (void)createSearchBar {
    _searchBar = [WSSearchBar searchBar];
    _searchBar.delegate = self;
    _searchBar.width = self.view.width - 20;
    _searchBar.height = 30;
    self.navigationItem.titleView = _searchBar;
}

#pragma mark - UITextField delegate
//textField开始编辑时
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldDidBeginEditing");
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

//textField正在编辑时
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"range = %@------string = %@",NSStringFromRange(range),string);
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    return YES;
}

#pragma mark - 取消按钮的点击事件
- (void)cancle {
    _searchBar.text = nil;
    [_searchBar resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_searchBar endEditing:YES];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
