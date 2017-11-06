//
//  BaseApi.m
//  MillenniumStar08.07
//
//  Created by rogers on 15-8-13.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import "BaseApi.h"
#import "RequestClient.h"
#import "LoginViewController.h"
#import "ShowLoginViewTool.h"
@implementation BaseApi

+ (void)getNoLogGeneralData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
                params:(NSMutableDictionary*)params{
    [[RequestClient sharedClient] GET:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BaseResponse *result = [self setValue:responseObject];
        if ([result.code isEqualToString:@"1000"]) {
            [self backToLoginView];
            return ;
        }
        callback(result,nil);
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}
//更新数据接口
+ (void)upData:(REQUEST_CALLBACK)callback URL:(NSString*)URL params:(NSMutableDictionary*)params{
    [[RequestClient sharedClient] GET:URL parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BaseResponse *result = [self setValue:responseObject];
        callback(result,nil);
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}
/*通用GET接口弹出登录
 */
+ (void)getGeneralData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
                                             params:(NSMutableDictionary*)params{
    [[RequestClient sharedClient] GET:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BaseResponse *result = [self setValue:responseObject];
        if ([result.code isEqualToString:@"1000"]) {
            [self backToLoginView];
            return ;
        }
        callback(result,nil);
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}
/*默认POST接口
 */
+ (void)postGeneralData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
                                            params:(NSMutableDictionary*)params{
    [[RequestClient sharedClient] POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BaseResponse *result = [self setValue:responseObject];
        if ([result.code isEqualToString:@"1000"]) {
            [self backToLoginView];
            return ;
        }
        callback(result,nil);
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}
/*json格式POST接口
 */
+ (void)postJsonData:(REQUEST_CALLBACK)callback requestURL:(NSString*)requestURL
                 params:(NSMutableDictionary*)params{
    [[RequestClient sharedPostClient] POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BaseResponse *result = [self setValue:responseObject];
        if ([result.code isEqualToString:@"1000"]) {
            [self backToLoginView];
            return ;
        }
        callback(result,nil);
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [SVProgressHUD dismiss];
        if(callback){
            callback(nil,error);
        }
    }];
}

+ (void)backToLoginView{
    [MBProgressHUD showError:@"需要登录"];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[LoginViewController alloc]init];
    [SVProgressHUD dismiss];
}

+ (BaseResponse *)setValue:(NSDictionary *)dic{
    BaseResponse*result = [[BaseResponse alloc]init];
    result.code = dic[@"code"];
    result.result = dic[@"result"];
    result.msg = dic[@"msg"];
    result.jsessionid = dic[@"jsessionid"];
    return result;
}

//清楚队列
+ (void)cancelAllOperation{
    [[RequestClient sharedClient].operationQueue cancelAllOperations];
}

@end
