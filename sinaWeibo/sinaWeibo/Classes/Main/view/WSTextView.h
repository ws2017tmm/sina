//
//  WSTextView.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/8/31.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSTextView : UITextView

/** 占位文字 */
@property (copy, nonatomic) NSString *placeholder;

/** 占位文字的颜色 */
@property (strong, nonatomic) UIColor *placeholderColor;

@end
