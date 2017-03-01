//
//  UIView+Extension.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/3/30.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

//x
- (void)setX:(float)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(float)x{
    return self.frame.origin.x;
}

//y
- (void)setY:(float)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(float)y{
    return self.frame.origin.y;
}

//width
- (void)setWidth:(float)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(float)width {
    return self.frame.size.width;
}

//height
- (void)setHeight:(float)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(float)height {
    return self.frame.size.height;
}

//centerX
-(void)setCenterX:(float)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
    
}

-(float)centerX {
    return self.center.x;
}

//centerY
-(void)setCenterY:(float)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
    
}

-(float)centerY {
    return self.center.y;
}

//size
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

//origin
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

@end
