//
//  NSString+Extension.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/8/26.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)


//根据字体大小和数量算尺寸
- (CGSize)sizeWithFont:(UIFont *)font{
    NSDictionary *dict = @{NSFontAttributeName : font};
    CGSize size = [self sizeWithAttributes:dict];
    return size;
}

//限制宽度算高度
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat )width {
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    NSDictionary *dict = @{NSFontAttributeName : font};
    CGSize size = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end
