//
//  SaveUserInfoTool.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/19.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "SaveUserInfoTool.h"

@implementation SaveUserInfoTool
//单例
+ (instancetype)shared
{
    static dispatch_once_t once = 0;
    static SaveUserInfoTool *alert;
    dispatch_once(&once, ^{
        alert = [[SaveUserInfoTool alloc]init];
    });
    return alert;
}

- (void)clearAllData{
    self.id = @"";
    self.haveLog = NO;
    self.isQQ = NO;
    self.mobile = @"";
    self.nickName = @"";
    self.shopId = @"";
    self.imgUrl = @"";
    self.openId = @"";
}

@end
