//
//  CustomRegisterV.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/1.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "CustomRegisterV.h"
#import "ZBButten.h"
#import "ChooseStoreInfoTool.h"
#import "MainProtocolVC.h"
#import "ShowLoginViewTool.h"
#import "MainNavViewController.h"
#import "MainTabViewController.h"
@interface CustomRegisterV()
@property (weak, nonatomic) IBOutlet UITextField *phoneFie;
@property (weak, nonatomic) IBOutlet UITextField *numCode;
@property (weak, nonatomic) IBOutlet UITextField *codeFie;
@property (weak, nonatomic) IBOutlet ZBButten *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *passFie;
@property (weak, nonatomic) IBOutlet UIView *passView;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (nonatomic, copy) NSString *biz;
@property (nonatomic, copy) NSString *uuidStr;
@property (nonatomic,assign)BOOL isSel;
@end
@implementation CustomRegisterV

+ (CustomRegisterV *)createRegisterView{
    CustomRegisterV *registerV = [[CustomRegisterV alloc]init];
    return registerV;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CustomRegisterV" owner:nil options:nil][0];
        [self.getCodeBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
        [self.nextBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
        [self.getCodeBtn setbuttenfrontTitle:@"" backtitle:@"s后获取"];
    }
    return self;
}

- (void)setLogType:(int)logType{
    if (logType) {
        _logType = logType;
        BOOL isPhone = _logType==1;
        NSString *str = isPhone?@"注册":@"登录";
        [self.nextBtn setTitle:str forState:UIControlStateNormal];
        self.passView.hidden = !isPhone;
    }
}

- (IBAction)numCodeClick:(id)sender {
    [self refreshCodeImage];
}

- (void)refreshCodeImage{
//    arc4random()%100
    self.uuidStr = [NSUUID UUID].UUIDString;
    NSString *base = @"http://www.xiaochabao.top:81/xcb/api/kaptcha/kaptcha.jpg";
    NSString *url = [NSString stringWithFormat:@"%@?uid=%@",base,self.uuidStr];
    [self.codeImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:DefaultImage];
}

- (IBAction)codeClick:(UIButton *)sender {
    [self requestCheckWord];
}

- (void)requestCheckWord{
    if (self.phoneFie.text.length<11){
        [MBProgressHUD showError:@"手机号输入有误"];
        [self.getCodeBtn resetBtn];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phoneNumber"] = self.phoneFie.text;
    params[@"kaptcha"] = self.numCode.text;
    params[@"uid"] = self.uuidStr;
    NSString *logUrl = [NSString stringWithFormat:@"%@api/sms/send",baseNet];
    [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
        if ([YQObjectBool boolForObject:response.result]&&[response.code isEqualToString:@"0000"]) {
            self.biz = response.result[@"bizId"];
        }else{
//            [self refreshCodeImage];
            [self.getCodeBtn resetBtn];
        }
        NSString *str = [YQObjectBool boolForObject:response.msg]?response.msg:@"操作成功";
        [MBProgressHUD showError:str];
    } requestURL:logUrl params:params];
}

- (IBAction)chooseClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.isSel = sender.selected;
}

- (IBAction)nextClick:(UIButton *)sender {
    [self rigisterClick:sender];
}

- (void)rigisterClick:(UIButton *)sender {
    [self.phoneFie resignFirstResponder];
    [self.passFie resignFirstResponder];
    [self.codeFie resignFirstResponder];
    if (!self.isSel) {
        [MBProgressHUD showError:@"请同意协议"];
        return;
    }
    if (self.phoneFie.text.length!=11) {
        [MBProgressHUD showError:@"手机格式不对"];
        return;
    }
    if (self.biz.length==0) {
        [MBProgressHUD showError:@"未获取验证码"];
        return;
    }
    if (self.codeFie.text.length==0) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = self.phoneFie.text;
    params[@"mobile"] = self.phoneFie.text;
    NSString *str;
    if (self.logType!=1) {
        str = @"bind";
        SaveUserInfoTool *save = [SaveUserInfoTool shared];
        NSString *qq = save.isQQ?@"qq":@"wx";
        params[qq] = save.openId;
        params[@"nickName"] = save.nickName;
        params[@"imgUrl"] = save.imgUrl;
    }else{
        if (self.passFie.text.length<6) {
            [MBProgressHUD showError:@"密码少于6位"];
            return;
        }else{
            params[@"password"] = self.passFie.text;
            str = @"register";
        }
    }
    sender.enabled = NO;
    NSString *bizS = [self.biz stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *netUrl = [NSString stringWithFormat:@"%@api/user/%@/%@/%@",baseNet,str,bizS,self.codeFie.text];
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            [self saveUserInfo:params and:response];
        }
        NSString *str = [YQObjectBool boolForObject:response.msg]?response.msg:@"操作成功";
        [MBProgressHUD showError:str];
        sender.enabled = YES;
    } requestURL:netUrl params:params];
}
//跳转到首页
- (void)saveUserInfo:(NSMutableDictionary *)params and:(BaseResponse *)response{
    params[@"isLog"] = @(self.logType);
    params[@"refeshKey"] = [AccountTool account].refeshKey;
    Account *account = [Account accountWithDict:params];
    //自定义类型存储用NSKeyedArchiver
    [AccountTool saveAccount:account];
    SaveUserInfoTool *save = [SaveUserInfoTool shared];
    save.haveLog = YES;
    save.id = response.result[@"id"];
    save.nickName = response.result[@"nickName"];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = [[MainTabViewController alloc]init];
    });
}

- (IBAction)proClick:(id)sender {
    UIViewController *vc = [ShowLoginViewTool getCurrentVC];
    MainProtocolVC *pro = [MainProtocolVC new];
    pro.typeId = @"0001";
    pro.title = @"用户注册协议";
    pro.isFir = YES;
    MainNavViewController *main = [[MainNavViewController alloc]initWithRootViewController:pro];
    [vc presentViewController:main animated:YES completion:nil];
}

- (IBAction)saveClick:(id)sender {
    UIViewController *vc = [ShowLoginViewTool getCurrentVC];
    MainProtocolVC *pro = [MainProtocolVC new];
    pro.typeId = @"0002";
    pro.title = @"仓储管理协议";
    pro.isFir = YES;
    MainNavViewController *main = [[MainNavViewController alloc]initWithRootViewController:pro];
    [vc presentViewController:main animated:YES completion:nil];
}
//- (void)oldNet{
//    if (!self.isSel) {
//        [MBProgressHUD showError:@"请同意协议"];
//        return;
//    }
//    if (self.phoneFie.text.length!=11) {
//        [MBProgressHUD showError:@"手机格式不对"];
//        return;
//    }
//    if (self.codeFie.text.length==0) {
//        [MBProgressHUD showError:@"请输入验证码"];
//        return;
//    }
//    if (self.codeFie.text.length<6) {
//        [MBProgressHUD showError:@"请输入密码"];
//        return;
//    }
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"phoneNumber"] = self.phoneFie.text;
//    params[@"bizId"] = self.biz;
//    params[@"code"] = self.codeFie.text;
//    NSString *logUrl = [NSString stringWithFormat:@"%@api/sms/verify",baseNet];
//    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
//        if ([response.code isEqualToString:@"0000"]) {
//            [self presentChooseStore];
//        }
//        NSString *str = [YQObjectBool boolForObject:response.msg]?response.msg:@"操作成功";
//        [MBProgressHUD showError:str];
//    } requestURL:logUrl params:params];
//}
////跳转到选择门店
//- (void)presentChooseStore{
//    NSMutableDictionary *params = [NSMutableDictionary new];
//    params[@"phone"] = self.phoneFie.text;
//    params[@"biz"] = [self.biz stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    params[@"code"] = self.codeFie.text;
//
//    UIViewController *vc = [ShowLoginViewTool getCurrentVC];
//    ChooseStoreInfoVC *store = [ChooseStoreInfoVC new];
//    store.mutDic = params;
//    [vc presentViewController:store animated:YES completion:nil];
//}
@end
