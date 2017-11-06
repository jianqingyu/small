//
//  WareConfirmRedeemVc.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/11.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "WareConfirmRedeemVc.h"

@interface WareConfirmRedeemVc ()
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *staueLabs;
@property (weak, nonatomic) IBOutlet UILabel *reNum;
@property (weak, nonatomic) IBOutlet UILabel *ordPrice;
@property (weak, nonatomic) IBOutlet UILabel *ordPic;
@property (weak, nonatomic) IBOutlet UILabel *redeemPic;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, copy) NSArray *urlArr;
@property (nonatomic, copy) NSArray *staueArr;
@property (nonatomic, copy) NSString *message;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
@end

@implementation WareConfirmRedeemVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.message = @"操作成功，请等待客服联系办理或拨打客服电话";
    for (UIButton *btn in self.btns) {
        [btn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
    }
    [self setBaseData];
    [self setBaseWareView];
}

- (void)setBaseData{
    self.reNum.text = [NSString stringWithFormat:@"%@%@",_info.quantity,_info.unitName];
    self.ordPrice.text = [NSString stringWithFormat:@"%0.2f元",_info.total];
    self.ordPic.text = [NSString stringWithFormat:@"%0.2f元",_info.assessment];
    self.redeemPic.text = [NSString stringWithFormat:@"%0.2f元",_info.redeem];
}

- (void)setBaseWareView{
    int staue = _info.transStatus;
    UIButton *btn = self.btns[0];
    UIButton *btn2 = self.btns[1];
    switch (staue) {
        case 1:{
            self.title = @"确认估价金额";
            self.urlArr = @[@"api/store/zy/confirm",@"api/store/zy/cancel"];
            self.staueArr = @[@"质押数量：",@"原成交金额：",@"评估金额：",@"赎回："];
            self.bottomView.hidden = YES;
            [btn setTitle:@"确认质押" forState:UIControlStateNormal];
            [btn2 setTitle:@"取消质押" forState:UIControlStateNormal];
        }
            break;
        case 3:{
            self.title = @"已质押茶叶";
            self.urlArr = @[@"api/store/sh/apply",@"api/store/zy/cancel"];
            self.staueArr = @[@"质押数量：",@"原成交金额：",@"评估金额：",@"赎回："];
            self.bottomView.hidden = YES;
            [btn setTitle:@"申请赎回" forState:UIControlStateNormal];
            btn2.hidden = YES;
        }
            break;
        case 6:{
            self.title = @"确认赎回";
            self.urlArr = @[@"api/store/sh/confirm",@"api/store/sh/cancel"];
            self.staueArr = @[@"原质押数量：",@"原成交金额：",@"原评估金额：",@"赎回金额："];
            [btn setTitle:@"确认赎回" forState:UIControlStateNormal];
            [btn2 setTitle:@"取消赎回" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    for (int i=0; i<self.staueArr.count; i++) {
        UILabel *lab = self.staueLabs[i];
        lab.text = self.staueArr[i];
    }
}

- (IBAction)btnClick:(UIButton *)sender {
    NSInteger idex = [self.btns indexOfObject:sender];
    NSString *url = self.urlArr[idex];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = _info.id;
    NSString *netUrl = [NSString stringWithFormat:@"%@%@",baseNet,url];
    if (_info.transStatus==3) {
        [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
            [self changeBackWith:response];
        } requestURL:netUrl params:params];
    }else{
        [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
            [self changeBackWith:response];
        } requestURL:netUrl params:params];
    }
}

- (void)changeBackWith:(BaseResponse *)response{
    NSString *str = [YQObjectBool boolForObject:response.msg]?response.msg:@"操作失败";
    if ([response.code isEqualToString:@"0000"]) {
        NSString *title = [YQObjectBool boolForObject:response.result]?response.result:self.message;
        NSDictionary *dic = @{@"title":title};
        [NewUIAlertTool show:dic back:^{
            if (self.back) {
                self.back(YES);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return;
    }
    [MBProgressHUD showError:str];
}

@end
