//
//  WSStatusPhoto.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/8/29.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSPhoto,WSStatusPhoto;
//@class WSStatusPhoto;

@protocol WSBrowserImageViewDelegate <NSObject>

@optional
- (void)statusPhoto:(WSStatusPhoto *)imageView didTap:(UITapGestureRecognizer *)tapGesture;

@end

@interface WSStatusPhoto : UIImageView

@property (strong, nonatomic) WSPhoto *photo;

@property (weak, nonatomic) id<WSBrowserImageViewDelegate> delegate;

@end
