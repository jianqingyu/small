//
//  HomePageHeadSView.m
//  SmallTeaTre
//
//  Created by 余建清 on 2017/11/23.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "HomePageHeadSView.h"
#import "MainTabViewController.h"
#import "ChooseStoreInfoTool.h"
#import "LoginViewController.h"
@implementation HomePageHeadSView
+ (HomePageHeadSView *)createHeadSView{
    HomePageHeadSView *headView = [[HomePageHeadSView alloc]init];
    return headView;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HomePageHeadSView" owner:nil options:nil][0];
    }
    return self;
}

- (IBAction)buyTea:(id)sender {
    if (![AccountTool account].isLog) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = [[LoginViewController alloc]init];
        return;
    }
    [ChooseStoreInfoTool chooseInfo:6];
}

- (IBAction)saveTea:(id)sender {
    if (![AccountTool account].isLog) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = [[LoginViewController alloc]init];
        return;
    }
    [ChooseStoreInfoTool chooseInfo:5];
}

- (IBAction)changeTea:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"transType"] = @"0001";
    NSString *netUrl = [NSString stringWithFormat:@"%@api/store/count",baseNet];
    [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]) {
            int num = [response.result intValue];
            if (num==0) {
                NSDictionary *dic = @{@"title":@"请先存储茶品"};
                [NewUIAlertTool show:dic back:nil];
            }else{
                [ChooseStoreInfoTool chooseInfo:1];
            }
        }else{
            NSString *str = [YQObjectBool boolForObject:response.msg]?response.msg:@"操作失败";
            [MBProgressHUD showError:str];
        }
    } requestURL:netUrl params:params];
}

@end
