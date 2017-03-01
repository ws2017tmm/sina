//
//  NSString+Extension.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/8/26.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/** 根据字体大小和数量算尺寸 */
- (CGSize)sizeWithFont:(UIFont *)font;

/** 限制宽度算高度 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat )width;

@end
