//
//  OrderNumTool.h
//  MillenniumStarERP
//
//  Created by yjq on 16/12/16.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderNumTool : NSObject
+ (NSString *)strWithPrice:(float)price;
+ (NSString *)strWithTime:(NSString *)time;
+ (void)orderWithNum:(int)number andView:(UILabel *)sLab;
+ (void)NSLoginWithStr:(NSString *)str andDic:(NSDictionary *)dic;

@end
