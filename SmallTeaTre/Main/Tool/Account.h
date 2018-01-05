//
//  Account.h
//  MillenniumStar08.07
//
//  Created by yjq on 15/10/10.
//  Copyright © 2015年 qxzx.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject<NSCoding>
@property (nonatomic,copy)NSString *loginName;
@property (nonatomic,copy)NSString *password;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSNumber *isLog;
@property (nonatomic,copy)NSString *refeshKey;
+ (instancetype)accountWithDict:(NSDictionary *)dict;
@end
