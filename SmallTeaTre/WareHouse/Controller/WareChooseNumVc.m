//
//  WareChooseNumVc.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/11.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "WareChooseNumVc.h"
#import "CustomProtrlView.h"
@interface WareChooseNumVc ()
@property (weak, nonatomic) IBOutlet UITextField *numFie;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, copy) NSDictionary *dic;
@property (weak,  nonatomic) CustomProtrlView *proView;
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
    [self loadMainProView];
    [self loadProData];
}
#pragma mark -- 网络请求
- (void)loadProData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *netUrl = [NSString stringWithFormat:@"%@api/help/type/0003",baseNet];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            NSDictionary *dic = response.result[0];
            self.proView.str = dic[@"content"];
        }else{
            NSString *str = response.msg?response.msg:@"查询失败";
            [MBProgressHUD showError:str];
        }
    } requestURL:netUrl params:params];
}

#pragma mark -- 弹出协议
- (void)loadMainProView{
    CustomProtrlView *pView = [CustomProtrlView creatCustomView];
    pView.titleStr = @"茶叶质押协议";
    [self.view addSubview:pView];
    [pView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    pView.back = ^(BOOL isYes){
        self.proView.hidden = YES;
        [self applyStoreZy];
    };
    pView.hidden = YES;
    self.proView = pView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.proView.hidden = YES;
}

- (IBAction)sureClick:(id)sender {
    int number = [self.numFie.text intValue];
    if (number<1||number>[_info.quantity intValue]) {
        [MBProgressHUD showError:@"请填写正确质押数量"];
        return;
    }
    [self.numFie resignFirstResponder];
    self.proView.hidden = NO;
}
//申请质押
- (void)applyStoreZy{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"goodsId"] = _info.goodsId;
    params[@"quantity"] = self.numFie.text;
    params[@"id"] = _info.id;
    NSString *netUrl = [NSString stringWithFormat:@"%@api/store/zy/apply",baseNet];
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

@end
