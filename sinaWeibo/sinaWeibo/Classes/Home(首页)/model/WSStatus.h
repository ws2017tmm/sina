//
//  WSStatus.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/4/12.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSUser;

@interface WSStatus : NSObject

/**idstr	string	字符串型的微博ID*/
@property (copy, nonatomic) NSString *idstr;

/**text	string	微博信息内容*/
@property (copy, nonatomic) NSString *text;

/**created_at	string	微博创建时间*/
@property (nonatomic, copy) NSString *created_at;

/**source	string	微博来源*/
@property (copy, nonatomic) NSString *source;

/** 微博配图地址。多图时返回多图链接。无配图返回“[]” */
@property (nonatomic, strong) NSArray *pic_urls;

/**since_id int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博）*/
@property (assign, nonatomic) long long since_id;

/*max_id int64	若指定此参数，则返回ID小于或等于max_id的微博*/
@property (assign, nonatomic) long long max_id;

/**user	object	微博作者的用户信息字段 */
@property (strong, nonatomic) WSUser *user;

/**	object	被转发的原微博信息字段，当该微博为转发微博时返回 详细*/
@property (strong, nonatomic) WSStatus *retweeted_status;


/**	int	转发数*/
@property (assign, nonatomic) int reposts_count;

/**	int	评论数*/
@property (assign, nonatomic) int comments_count;

/**	int	表态数*/
@property (assign, nonatomic) int attitudes_count;



@end
