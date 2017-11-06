//
//  UserOrderListInfo.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/21.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserOrderListInfo : NSObject
@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *goodsId;
@property (nonatomic, copy)NSString *goodsName;
@property (nonatomic, copy)NSString *orderStatus;
@property (nonatomic, copy)NSString *deportName;
@property (nonatomic, copy)NSString *typeName;
@property (nonatomic, copy)NSString *orderStatusName;
@property (nonatomic, copy)NSString *orderType;
@property (nonatomic, copy)NSString *orderTypeName;
@property (nonatomic, copy)NSString *imgUrl;
@property (nonatomic, copy)NSString *unit;
@property (nonatomic, copy)NSString *unitName;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *updateTime;
@property (nonatomic, copy)NSString *endTime;
@property (nonatomic, copy)NSString *quantity;
@property (nonatomic,assign)float price;
@property (nonatomic,assign)float total;

@end
