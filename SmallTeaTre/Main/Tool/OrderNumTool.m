//
//  OrderNumTool.m
//  MillenniumStarERP
//
//  Created by yjq on 16/12/16.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "OrderNumTool.h"
#import "StrWithIntTool.h"
@implementation OrderNumTool

+ (void)orderWithNum:(int)number andView:(UILabel *)sLab{
    if (number>0&&number<=99) {
        sLab.text = [NSString stringWithFormat:@"%d",number];
        sLab.hidden = NO;
    }else if(number>99){
        sLab.text = @"99+";
        sLab.hidden = NO;
    }else{
        sLab.hidden = YES;
    }
}

+ (NSString *)strWithPrice:(float)price{
    //价格取整
    return [NSString stringWithFormat:@"￥%0.0f",price];
}

+ (NSString *)strWithTime:(NSString *)time{
    NSTimeInterval second = time.longLongValue / 1000.0;
    // 时间戳 -> NSDate *
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *string = [fmt stringFromDate:date];
    return string;
}

+ (void)NSLoginWithStr:(NSString *)str andDic:(NSDictionary *)dic{
    //打印请求链接
    NSMutableArray *mutA = @[].mutableCopy;
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,obj];
        [mutA addObject:str];
    }];
    NSString *mes = [StrWithIntTool strWithArr:mutA With:@"&"];
    NSLog(@"%@?%@",str,mes);
}

@end
