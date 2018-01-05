//
//  UserEditNameVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/7.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserEditNameVC.h"

@interface UserEditNameVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameFie;
@end

@implementation UserEditNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置昵称";
    [self setRightNaviBar];
    [self.nameFie setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setRightNaviBar{
    UIButton *bar = [UIButton buttonWithType:UIButtonTypeCustom];
    bar.frame = CGRectMake(0, 0, 30, 30);
    [bar setTitle:@"保存" forState:UIControlStateNormal];
    bar.titleLabel.font = [UIFont systemFontOfSize:15];
    [bar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bar addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bar];
}

- (void)btnClick:(id)sender{
    if (self.nameFie.text.length==0) {
        [MBProgressHUD showError:@"请输入昵称"];
        return;
    }
    if (self.nameFie.text.length>20) {
        [MBProgressHUD showError:@"昵称不能大于20字符"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([[SaveUserInfoTool shared].id isKindOfClass:[NSString class]]) {
        params[@"userId"] = [SaveUserInfoTool shared].id;
    }
    params[@"nickName"] = self.nameFie.text;
    NSString *netUrl = [NSString stringWithFormat:@"%@api/user/nick_update",baseNet];
    [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]) {
            SaveUserInfoTool *save = [SaveUserInfoTool shared];
            save.nickName = params[@"nickName"];
            if (self.back) {
                self.back(YES);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        NSString *str = [YQObjectBool boolForObject:response.msg]?response.msg:@"操作成功";
        [MBProgressHUD showError:str];
    } requestURL:netUrl params:params];
}

@end
