//
//  WareListInfo.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/20.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WareListInfo : NSObject
@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *goodsId;
@property (nonatomic, copy)NSString *goodsName;
@property (nonatomic, copy)NSString *typeName;
@property (nonatomic, copy)NSString *transType;
@property (nonatomic, copy)NSString *deportName;
@property (nonatomic, copy)NSString *imgUrl;
@property (nonatomic, copy)NSString *unit;
@property (nonatomic, copy)NSString *unitName;
@property (nonatomic, copy)NSString *transStatusName;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *updateTime;
@property (nonatomic, copy)NSString *endTime;
@property (nonatomic, copy)NSString *quantity;
@property (nonatomic, copy)NSString *expectation;
@property (nonatomic,assign)int transStatus;
@property (nonatomic,assign)float price;
@property (nonatomic,assign)float total;
@property (nonatomic,assign)float assessment;
@property (nonatomic,assign)float redeem;
@end
