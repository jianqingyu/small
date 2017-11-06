//
//  WareChooseNumVc.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/11.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "WareChooseNumVc.h"

@interface WareChooseNumVc ()
@property (weak, nonatomic) IBOutlet UITextField *numFie;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, copy) NSDictionary *dic;
@end

@implementation WareChooseNumVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择质押数量";
    self.dic = @{@"title":@"已提交质押申请，待审核"};
    [self.sureBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
    if (self.isSel) {
        [NewUIAlertTool show:self.dic back:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (IBAction)sureClick:(id)sender {
    [self applyStoreZy];
}

- (void)applyStoreZy{
    int number = [self.numFie.text intValue];
    if (number<1||number>[_info.quantity intValue]) {
        [MBProgressHUD showError:@"请填写正确质押数量"];
        return;
    }
    [self.numFie resignFirstResponder];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"goodsId"] = _info.goodsId;
    params[@"quantity"] = self.numFie.text;
    params[@"id"] = _info.id;
    NSString *netUrl = [NSString stringWithFormat:@"%@api/store/zy/apply",baseNet];
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]) {
            if (self.back) {
                self.back(YES);
            }
            [NewUIAlertTool show:self.dic back:^{
                NSInteger idx = self.navigationController.viewControllers.count;
                BaseViewController *vc = self.navigationController.viewControllers[idx-3];
                [self.navigationController popToViewController:vc animated:YES];
            }];
            return;
        }
        NSString *str = [YQObjectBool boolForObject:response.msg]?response.msg:@"操作失败";
        [MBProgressHUD showError:str];
    } requestURL:netUrl params:params];
}

@end
