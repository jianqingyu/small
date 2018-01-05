//
//  CustomLoginV.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/1.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "CustomLoginV.h"
#import "WeChatManager.h"
#import "ShowLoginViewTool.h"
#import "NetworkDetermineTool.h"
#import "UserEditPasswordVC.h"
#import "SaveUserInfoTool.h"
#import "AssociatPhoneVC.h"
#import "PackagingTool.h"
#import "LoggingWithDataTool.h"
#import "MainNavViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
@interface CustomLoginV()<TencentSessionDelegate>
{
    TencentOAuth *_tencentOAuth;
}
@property (weak,  nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation CustomLoginV

+ (CustomLoginV *)createLoginView{
    static CustomLoginV *_loginView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _loginView = [[CustomLoginV alloc]init];
    });
    return _loginView;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CustomLoginV" owner:nil options:nil][0];
        [self.loginBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
    }
    return self;
}

- (IBAction)forgotPass:(id)sender {
    UIViewController *vc = [ShowLoginViewTool getCurrentVC];
    UserEditPasswordVC *edit = [UserEditPasswordVC new];
    edit.isFir = YES;
    MainNavViewController *main = [[MainNavViewController alloc]initWithRootViewController:edit];
    [vc presentViewController:main animated:YES completion:nil];
}

- (IBAction)loginClick:(UIButton *)sender {
    if (self.phoneFie.text.length==0) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    if (self.passFie.text.length==0) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    if (![NetworkDetermineTool isExistenceNet]) {
        [MBProgressHUD showError:@"网络断开、请联网"];
        return;
    }
    [SVProgressHUD show];
    [self.phoneFie resignFirstResponder];
    [self.passFie resignFirstResponder];
    sender.enabled = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = self.phoneFie.text;
    params[@"password"] = self.passFie.text;
    NSString *logUrl = [NSString stringWithFormat:@"%@api/user/login",baseNet];
    NSMutableDictionary *dic = @{}.mutableCopy;
    dic[@"isLog"] = @1;
    [LoggingWithDataTool logData:params andUrl:logUrl andSaveDic:dic andBack:^(int type) {
        if (self.btnBack) {
            self.btnBack(type);
        }
        sender.enabled = YES;
    }];
}

- (IBAction)weixinClick:(id)sender {
    [self sendAuthRequest];
}

- (void)sendAuthRequest{
    [WeChatManager sendAuthRequest];
    WeChatManager *man = [WeChatManager sharedManager];
    man.back = ^(id model) {
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"access_token"] = model[@"access_token"];
        params[@"openid"] = model[@"openid"];
        NSMutableDictionary *dic = @{}.mutableCopy;
        dic[@"isLog"] = @2;
        dic[@"refeshKey"] = model[@"refresh_token"];
        [self loadWeinXinUserInfo:params];
        [self loadWeiXinRequest:params andDic:dic.copy];
    };
}
//获取微信用户信息
- (void)loadWeinXinUserInfo:(NSMutableDictionary *)dic{
    NSString *userUrl = @"https://api.weixin.qq.com/sns/userinfo";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",nil];
    [manager GET:userUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SaveUserInfoTool *save = [SaveUserInfoTool shared];
        save.openId = responseObject[@"openid"];
        save.isQQ = NO;
        save.imgUrl = responseObject[@"headimgurl"];
        save.nickName = [PackagingTool removeEmoji:responseObject[@"nickname"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"用refresh_token来更新accessToken时出错 = %@", error);
    }];
}

- (void)loadWeiXinRequest:(NSMutableDictionary *)params andDic:(NSDictionary *)dic{
    NSString *logUrl = [NSString stringWithFormat:@"%@api/user/wx/auth",baseNet];
    [LoggingWithDataTool logData:params andUrl:logUrl andSaveDic:dic andBack:^(int type) {
        if (self.btnBack) {
            self.btnBack(type);
        }
    }];
}

- (IBAction)qqClick:(id)sender {
    [self qqLogin];
}

- (void)qqLogin{
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1106339351" andDelegate:self];
    NSMutableArray *mutA = [NSMutableArray arrayWithObjects:kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                        nil];
    [_tencentOAuth authorize:mutA];
}
#pragma TencentSessionDelegate
/**
 * [该逻辑未实现]因token失效而需要执行重新登录授权。在用户调用某个api接口时，如果服务器返回token失效，则触发该回调协议接口，由第三方决定是否跳转到登录授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启重新登录授权流程。若需要重新登录授权请调用\ref TencentOAuth#reauthorizeWithPermissions: \n注意：重新登录授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth{
    return YES;
}

- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions{
    // incrAuthWithPermissions是增量授权时需要调用的登录接口
    // permissions是需要增量授权的权限列表
    [tencentOAuth incrAuthWithPermissions:permissions];
    return NO; // 返回NO表明不需要再回传未授权API接口的原始请求结果；
    // 否则可以返回YES
}

- (void)tencentDidLogin{
    if (_tencentOAuth.accessToken) {
        [_tencentOAuth getUserInfo];
        [self loadQQRequest];
    }
}

- (void)loadQQRequest{
    [BaseApi cancelAllOperation];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = _tencentOAuth.accessToken;
    NSString *logUrl = [NSString stringWithFormat:@"%@api/user/qq/auth",baseNet];
    NSMutableDictionary *dic = @{}.mutableCopy;
    dic[@"isLog"] = @3;
    dic[@"refeshKey"] = _tencentOAuth.accessToken;
    [LoggingWithDataTool logData:params andUrl:logUrl andSaveDic:dic andBack:^(int type) {
        if (self.btnBack) {
            self.btnBack(type);
        }
    }];
}

- (void)getUserInfoResponse:(APIResponse*) response{
    SaveUserInfoTool *save = [SaveUserInfoTool shared];
    save.openId = _tencentOAuth.openId;
    save.isQQ = YES;
    save.nickName = [PackagingTool removeEmoji:response.jsonResponse[@"nickname"]];
    save.imgUrl = response.jsonResponse[@"figureurl_qq_2"];
}

- (void)tencentDidNotLogin:(BOOL)cancelled{
//    if (cancelled) {
//        NSLog(@" 用户点击取消按键,主动退出登录");
//    }
}

-(void)tencentDidNotNetWork{
    //    NSLog(@"没有网络了， 怎么登录成功呢");
}

@end
