//
//  LoggingWithDataTool.h
//  SmallTeaTre
//
//  Created by 余建清 on 2017/12/20.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoggingWithDataTool : NSObject
+ (void)logData:(NSMutableDictionary *)params andUrl:(NSString *)logUrl
     andSaveDic:(NSDictionary *)dic andBack:(void (^)(int type))callBack;
@end
