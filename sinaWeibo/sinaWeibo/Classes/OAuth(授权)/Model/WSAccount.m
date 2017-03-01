//
//  WSAccount.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/4/11.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSAccount.h"

@implementation WSAccount
#pragma mark - 字典转模型
- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.access_token = dict[@"access_token"];
        self.expires_in = dict[@"expires_in"];
        self.uid = dict[@"uid"];
        
        //access_token的创建时间
        NSDate *createTime = [NSDate date];
        self.create_time = createTime;
    }
    return self;
}

+ (instancetype)accountWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

//归档时调用
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.expires_in forKey:@"expires_in"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.create_time forKey:@"create_time"];
    [aCoder encodeObject:self.user_name forKey:@"user_name"];
}

//解档时调用
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.create_time = [aDecoder decodeObjectForKey:@"create_time"];
        self.user_name = [aDecoder decodeObjectForKey:@"user_name"];
    }
    return self;
}

@end
