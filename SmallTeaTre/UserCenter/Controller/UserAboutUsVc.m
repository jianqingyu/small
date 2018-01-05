//
//  UserAboutUsVc.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserAboutUsVc.h"
#import "UserAboutInfo.h"
@interface UserAboutUsVc ()
@property (weak, nonatomic) IBOutlet UILabel *aboutLab;
@property (weak, nonatomic) IBOutlet UILabel *verLab;
@property (weak, nonatomic) IBOutlet UILabel *telLab;
@property (weak, nonatomic) IBOutlet UIButton *telBtn;
@property (nonatomic, copy)NSString *phone;
@end

@implementation UserAboutUsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.telBtn setLayerWithW:3 andColor:BordColor andBackW:0.0001];
    [self loadHomeData];
}

- (void)loadHomeData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *userId;
    if ([[SaveUserInfoTool shared].id isKindOfClass:[NSString class]]) {
        userId = [SaveUserInfoTool shared].id;
    }
    NSString *netUrl = [NSString stringWithFormat:@"%@api/app/info",baseNet];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            UserAboutInfo *info = [UserAboutInfo objectWithKeyValues:response.result];
            [self setBaseView:info];
        }else{
            NSString *str = response.msg?response.msg:@"查询失败";
            [MBProgressHUD showError:str];
        }
    } requestURL:netUrl params:params];
}

- (void)setBaseView:(UserAboutInfo *)info{
    self.aboutLab.text = info.app_introduction;
    self.verLab.text = [NSString stringWithFormat:@"版本号:%@",info.app_ios_version];
    self.phone = info.customer_service_phone;
    self.telLab.text = [NSString stringWithFormat:@"客服电话:%@",info.customer_service_phone];
}

- (IBAction)clickTel:(id)sender {
    if (self.phone.length==0) {
        return;
    }
    NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"tel:%@",self.phone]];
    [[UIApplication sharedApplication]openURL:url];
}

@end
