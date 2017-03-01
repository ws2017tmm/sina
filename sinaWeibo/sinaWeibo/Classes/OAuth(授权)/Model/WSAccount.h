//
//  WSAccount.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/4/11.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSAccount : NSObject <NSCoding>

/**NSString 接口获取授权后的access_token*/
@property (copy, nonatomic) NSString *access_token;

/**NSString access token的过期时间,单位时秒*/
@property (copy, nonatomic) NSString *expires_in;

/**NSString 用户的id*/
@property (copy, nonatomic) NSString *uid;

/**NSString access_token的创建时间*/
@property (copy, nonatomic) NSDate *create_time;

/**NSString 用户的昵称*/
@property (copy, nonatomic) NSString *user_name;

+ (instancetype)accountWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;


@end
