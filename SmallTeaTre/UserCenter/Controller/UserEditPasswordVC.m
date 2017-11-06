//
//  UserEditPasswordVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/7.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserEditPasswordVC.h"
#import "ZBButten.h"
#import "LoginViewController.h"
@interface UserEditPasswordVC ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UITextField *codeFie;
@property (weak, nonatomic) IBOutlet ZBButten *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordFie;
@property (weak, nonatomic) IBOutlet UITextField *surePassFie;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic, copy) NSString *biz;
@end

@implementation UserEditPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    NSString *phone = [AccountTool account].mobile;
    NSString *str4 = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"xxxx"];
    self.phoneLab.text = str4;
    [self.loginBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
    if (self.isFir) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    [self.codeBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
    [self.loginBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
    [self.codeBtn setbuttenfrontTitle:@"" backtitle:@"s后获取"];
}

- (void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getCodeClick:(id)sender {
    [self requestCheckWord];
}

- (void)requestCheckWord{
    NSString *phone = [AccountTool account].mobile;
    if (phone.length<11){
        [MBProgressHUD showError:@"手机号有误"];
        [self.codeBtn resetBtn];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phoneNumber"] = phone;
    NSString *logUrl = [NSString stringWithFormat:@"%@api/sms/send/password",baseNet];
    [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
        if ([YQObjectBool boolForObject:response.result[@"bizId"]]&&[response.code isEqualToString:@"0000"]) {
            self.biz = response.result[@"bizId"];
        }else{
            [self.codeBtn resetBtn];
        }
        NSString *str = [YQObjectBool boolForObject:response.msg]?response.msg:@"操作成功";
        [MBProgressHUD showError:str];
    } requestURL:logUrl params:params];
}

- (IBAction)sureClick:(UIButton *)sender {
    if (self.codeFie.text.length==0) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    if (self.passwordFie.text.length<6){
        [MBProgressHUD showError:@"密码不足6位"];
        return;
    }
    if (![self.passwordFie.text isEqualToString:self.surePassFie.text]) {
        [MBProgressHUD showError:@"两次密码不符"];
        return;
    }
    sender.enabled = NO;
    NSString *bizCode = [self.biz stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phoneNumber"] = [AccountTool account].mobile;
    params[@"password"] = self.passwordFie.text;
    params[@"rePassword"] = self.surePassFie.text;
    NSString *netUrl = [NSString stringWithFormat:@"%@api/user/reset_password/%@/%@",baseNet,bizCode,self.codeFie.text];
    [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]) {
            NSString *url = [NSString stringWithFormat:@"%@api/user/logout",baseNet];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
                if ([response.code isEqualToString:@"0000"]) {
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    window.rootViewController = [[LoginViewController alloc]init];
                    SaveUserInfoTool *save = [SaveUserInfoTool shared];
                    [save clearAllData];
                }
            } requestURL:url params:params];
            params[@"loginName"] = [AccountTool account].mobile;
            params[@"password"] = @"";
            Account *account = [Account accountWithDict:params];
            //自定义类型存储用NSKeyedArchiver
            [AccountTool saveAccount:account];
        }
        NSString *str = [YQObjectBool boolForObject:response.msg]?response.msg:@"操作成功";
        [MBProgressHUD showError:str];
        sender.enabled = YES;
    } requestURL:netUrl params:params];
}

@end
