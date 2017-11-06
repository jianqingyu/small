//
//  BaseResponse.h
//  MillenniumStar08.07
//
//  Created by rogers on 15-8-13.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseResponse : NSObject
@property(copy, nonatomic) NSString *msg;
@property(copy, nonatomic) NSString *code;
@property(copy, nonatomic) NSString *jsessionid;
@property(strong, nonatomic) id result;
@end
