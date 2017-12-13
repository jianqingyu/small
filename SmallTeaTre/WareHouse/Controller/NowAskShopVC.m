//
//  NowAskShopVC.m
//  SmallTeaTre
//
//  Created by 余建清 on 2017/11/24.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "NowAskShopVC.h"

@interface NowAskShopVC ()
@property (weak, nonatomic) IBOutlet UITextField *numfie;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic, copy) NSDictionary *dic;
@end

@implementation NowAskShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择现提数量";
    self.dic = @{@"title":@"已提交现提申请，待审核"};
    [self.nextBtn setLayerWithW:3 andColor:BordColor andBackW:0.0001];
}

- (IBAction)nextClick:(id)sender {
    int number = [self.numfie.text intValue];
    if (number<1||number>[_info.quantity intValue]) {
        [MBProgressHUD showError:@"请填写正确现提数量"];
        return;
    }
    [self.numfie resignFirstResponder];
    [self applyStoreXt];
}
//申请现提
- (void)applyStoreXt{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"goodsId"] = _info.goodsId;
    params[@"quantity"] = self.numfie.text;
    params[@"id"] = _info.id;
    NSString *netUrl = [NSString stringWithFormat:@"%@api/store/xt/apply",baseNet];
    [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
