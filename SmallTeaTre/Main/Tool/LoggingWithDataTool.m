//
//  LoggingWithDataTool.m
//  SmallTeaTre
//
//  Created by 余建清 on 2017/12/20.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "LoggingWithDataTool.h"

@implementation LoggingWithDataTool

+ (void)logData:(NSMutableDictionary *)params andUrl:(NSString *)logUrl
     andSaveDic:(NSDictionary *)dic andBack:(void (^)(int type))callBack{
    [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"3000"]&&[params[@"isLog"]intValue]!=1) {
            params[@"isLog"] = dic[@"isLog"];
            params[@"refeshKey"] = dic[@"refeshKey"];
            Account *account = [Account accountWithDict:params];
            //自定义类型存储用NSKeyedArchiver
            [AccountTool saveAccount:account];
            if (callBack) {
                callBack(2);
            }
            return;
        }
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            params[@"mobile"] = response.result[@"mobile"];
            params[@"isLog"] = dic[@"isLog"];
            params[@"refeshKey"] = dic[@"refeshKey"];
            Account *account = [Account accountWithDict:params];
            //自定义类型存储用NSKeyedArchiver
            [AccountTool saveAccount:account];
            SaveUserInfoTool *save = [SaveUserInfoTool shared];
            save.haveLog = YES;
            save.id = response.result[@"id"];
            save.nickName = response.result[@"nickName"];
            save.shopId = response.result[@"shopId"];
            save.imgUrl = response.result[@"imgUrl"];
            if (callBack) {
                callBack(1);
            }
        }else{
            NSString *str = response.msg?response.msg:@"登录失败";
            [MBProgressHUD showError:str];
            if (callBack) {
                callBack(3);
            }
        }
    } requestURL:logUrl params:params];
}

@end
