//
//  WSStatusCell.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/7/21.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSStatusFrame;

@interface WSStatusCell : UITableViewCell

+ (WSStatusCell *)cellForTableView:(UITableView *)tableView;


@property (strong, nonatomic) WSStatusFrame *statusFrame;


@end
