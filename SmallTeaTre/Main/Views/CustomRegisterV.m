//
//  CustomRegisterV.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/1.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "CustomRegisterV.h"
#import "ZBButten.h"
#import "MainProtocolVC.h"
#import "ChooseStoreInfoVC.h"
#import "ShowLoginViewTool.h"
#import "MainNavViewController.h"
@interface CustomRegisterV()
@property (weak, nonatomic) IBOutlet UITextField *phoneFie;
@property (weak, nonatomic) IBOutlet UITextField *codeFie;
@property (weak, nonatomic) IBOutlet ZBButten *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic, copy) NSString *biz;
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
    NSString *logUrl = [NSString stringWithFormat:@"%@api/sms/send/register",baseNet];
    [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
        if ([YQObjectBool boolForObject:response.result]&&[response.code isEqualToString:@"0000"]) {
            self.biz = response.result[@"bizId"];
        }else{
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
    if (!self.isSel) {
        [MBProgressHUD showError:@"请同意协议"];
        return;
    }
    if (self.phoneFie.text.length!=11) {
        [MBProgressHUD showError:@"手机格式不对"];
        return;
    }
    if (self.codeFie.text.length==0) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phoneNumber"] = self.phoneFie.text;
    params[@"bizId"] = self.biz;
    params[@"code"] = self.codeFie.text;
    NSString *logUrl = [NSString stringWithFormat:@"%@api/sms/verify",baseNet];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]) {
            [self presentChooseStore];
        }
        NSString *str = [YQObjectBool boolForObject:response.msg]?response.msg:@"操作成功";
        [MBProgressHUD showError:str];
    } requestURL:logUrl params:params];
}
//跳转到选择门店
- (void)presentChooseStore{
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"phone"] = self.phoneFie.text;
    params[@"biz"] = [self.biz stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    params[@"code"] = self.codeFie.text;
    
    UIViewController *vc = [ShowLoginViewTool getCurrentVC];
    ChooseStoreInfoVC *store = [ChooseStoreInfoVC new];
    store.mutDic = params;
    [vc presentViewController:store animated:YES completion:nil];
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

@end
