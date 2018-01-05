//
//  UserStoreInfoVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserStoreInfoVC.h"
#import "UserShopInfo.h"
@interface UserStoreInfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *storeAdd;
@property (weak, nonatomic) IBOutlet UILabel *storePhone;
@property (weak, nonatomic) IBOutlet UIButton *storeTel;
@property (weak, nonatomic) IBOutlet UILabel *storeTime;
@property (copy, nonatomic) NSString *phone;
@end

@implementation UserStoreInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"门店信息";
    [self.storeTel setLayerWithW:3 andColor:BordColor andBackW:0.0001];
    [self loadHomeData];
}

- (void)loadHomeData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *shopId;
    if ([[SaveUserInfoTool shared].shopId isKindOfClass:[NSString class]]) {
        shopId = [SaveUserInfoTool shared].shopId;
    }
    NSString *netUrl = [NSString stringWithFormat:@"%@api/shop/%@",baseNet,shopId];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            UserShopInfo *info = [UserShopInfo objectWithKeyValues:response.result];
            [self setBaseView:info];
        }else{
            NSString *str = response.msg?response.msg:@"查询失败";
            [MBProgressHUD showError:str];
        }
    } requestURL:netUrl params:params];
}

- (void)setBaseView:(UserShopInfo *)info{
    self.storeName.text = info.shopName;
    self.storeAdd.text = info.address;
    self.storePhone.text = info.tel;
    self.storePhone.hidden = !info.tel.length;
    self.storeTel.hidden = !info.tel.length;
    self.phone = info.tel;
    self.storeTime.text = [NSString stringWithFormat:@"%@-%@",info.busiStartTime,info.busiEndTime];
}

- (IBAction)telClick:(id)sender {
    if (self.phone.length==0) {
        return;
    }
    NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"tel:%@",_phone]];
    [[UIApplication sharedApplication]openURL:url];
}

@end
