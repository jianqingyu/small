//
//  Account.m
//  MillenniumStar08.07
//
//  Created by yjq on 15/10/10.
//  Copyright © 2015年 qxzx.com. All rights reserved.
//

#import "Account.h"

@implementation Account

+ (instancetype)accountWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithAccountDict:dict];
}

- (id)initWithAccountDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.loginName = dict[@"loginName"];
        self.password  = dict[@"password"];
        self.mobile    = dict[@"mobile"];
        self.isLog     = dict[@"isLog"];
        self.refeshKey = dict[@"refeshKey"];
    }
    return self;
}
/**
 *当一个对象要归档进沙盒时，就会调用这个方法
 */
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.loginName forKey:@"loginName"];
    [aCoder encodeObject:self.password  forKey:@"password"];
    [aCoder encodeObject:self.mobile    forKey:@"mobile"];
    [aCoder encodeObject:self.isLog     forKey:@"isLog"];
    [aCoder encodeObject:self.refeshKey forKey:@"refeshKey"];
}
/**
 *当从沙盒中解当时，就会调用这个方法
 */
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.loginName = [aDecoder decodeObjectForKey:@"loginName"];
        self.password  = [aDecoder decodeObjectForKey:@"password"];
        self.mobile    = [aDecoder decodeObjectForKey:@"mobile"];
        self.isLog     = [aDecoder decodeObjectForKey:@"isLog"];
        self.refeshKey = [aDecoder decodeObjectForKey:@"refeshKey"];
    }
    return self;
}

@end
