//
//  WSRetweetController.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/9/1.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSStatus;

@interface WSRetweetController : UIViewController

/** 微博模型 */
@property (strong, nonatomic) WSStatus *status;

@end
