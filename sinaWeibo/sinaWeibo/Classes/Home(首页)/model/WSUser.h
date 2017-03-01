//
//  WSUser.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/4/12.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WSUserVerifiedTypeNone = -1, // 没有任何认证
    
    HWUserVerifiedPersonal = 0,  // 个人认证
    
    HWUserVerifiedOrgEnterprice = 2, // 企业官方：CSDN、EOE、搜狐新闻客户端
    HWUserVerifiedOrgMedia = 3, // 媒体官方：程序员杂志、苹果汇
    HWUserVerifiedOrgWebsite = 5, // 网站官方：猫扑
    
    HWUserVerifiedDaren = 220 // 微博达人
    
}WSUserVerifiedType;

@interface WSUser : NSObject

/**idstr string	字符串型的用户UID*/
@property (copy, nonatomic) NSString *idstr;

/** 会员类型 > 2代表是会员 */
@property (nonatomic, assign) int mbtype;

/** 会员等级 */
@property (nonatomic, assign) int mbrank;

/** 是否为会员 */
@property (assign, nonatomic, getter=isVip) BOOL vip;

/**name	string 友好显示名称*/
@property (copy, nonatomic) NSString *name;

/**profile_image_url string	用户头像地址（中图），50×50像素*/
@property (copy, nonatomic) NSString *profile_image_url;

/** 用户的认证类型 */
@property (assign, nonatomic) WSUserVerifiedType verified_type;

@end
