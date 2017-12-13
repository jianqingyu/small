//
//  AssignmentShopVC.m
//  SmallTeaTre
//
//  Created by 余建清 on 2017/11/24.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "AssignmentShopVC.h"
#import "CustomProtrlView.h"
@interface AssignmentShopVC ()
@property (weak, nonatomic) IBOutlet UITextField *numFie;
@property (weak, nonatomic) IBOutlet UITextField *sPriceFie;
@property (weak, nonatomic) IBOutlet UITextField *bPriceFie;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) CustomProtrlView *proView;
@property (nonatomic, copy) NSArray *dicArr;
@end

@implementation AssignmentShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择转让数量";
    self.dicArr = @[@{@"title":@"已提交转让申请，待审核"},@{@"title":@"转让已取消"}];
    if (self.isEdit) {
        [self.nextBtn setTitle:@"取消转让" forState:UIControlStateNormal];
        self.numFie.text = _info.quantity;
        self.numFie.userInteractionEnabled = NO;
        NSArray *arr;
        if ([_info.expectation containsString:@"~"]) {
            arr = [_info.expectation componentsSeparatedByString:@"~"];
        }
        self.sPriceFie.text = arr[0];
        self.bPriceFie.text = arr[1];
        self.sPriceFie.userInteractionEnabled = NO;
        self.bPriceFie.userInteractionEnabled = NO;
    }
    [self.nextBtn setLayerWithW:3 andColor:BordColor andBackW:0.0001];
    [self loadMainProView];
}
#pragma mark -- 弹出协议
- (void)loadMainProView{
    CustomProtrlView *pView = [CustomProtrlView creatCustomView];
    [self.view addSubview:pView];
    [pView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    pView.back = ^(BOOL isYes){
        self.proView.hidden = YES;
        [self applyStoreZr];
    };
    pView.hidden = YES;
    self.proView = pView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.proView.hidden = YES;
}

- (IBAction)nextClick:(id)sender {
    int number = [self.numFie.text intValue];
    if (number<1||number>[_info.quantity intValue]) {
        [MBProgressHUD showError:@"请填写正确转让数量"];
        return;
    }
    float price = [self.sPriceFie.text floatValue];
    float bPrice = [self.bPriceFie.text floatValue];
    if (bPrice==0||price>bPrice) {
        [MBProgressHUD showError:@"请填写正确价格区间"];
        return;
    }
    [self.numFie resignFirstResponder];
    [self.sPriceFie resignFirstResponder];
    [self.bPriceFie resignFirstResponder];
    self.proView.hidden = NO;
}
//申请质押
- (void)applyStoreZr{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"expectation"] = [NSString stringWithFormat:@"%@~%@",self.sPriceFie.text,self.bPriceFie.text];
    params[@"quantity"] = self.numFie.text;
    params[@"id"] = _info.id;
    NSString *url = self.isEdit?@"api/store/zr/cancel":@"api/store/zr/apply";
    NSString *netUrl = [NSString stringWithFormat:@"%@%@",baseNet,url];
    [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]) {
            if (self.back) {
                self.back(YES);
            }
            [NewUIAlertTool show:self.dicArr[self.isEdit] back:^{
                if (self.isEdit) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    NSInteger idx = self.navigationController.viewControllers.count;
                    BaseViewController *vc = self.navigationController.viewControllers[idx-3];
                    [self.navigationController popToViewController:vc animated:YES];
                }
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
