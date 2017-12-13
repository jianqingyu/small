//
//  TemporaryDepVC.m
//  SmallTeaTre
//
//  Created by 余建清 on 2017/11/23.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "TemporaryDepVC.h"
#import "ShoppingListInfo.h"
#import "ShoppingSearchVC.h"
#import "CustomChWareHouse.h"
#import "CustomDatePick.h"
#import "CustomProtrlView.h"
#import "CustomBackgroundView.h"
@interface TemporaryDepVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *cangcLab;
@property (weak, nonatomic) IBOutlet UILabel *shopLab;
@property (weak, nonatomic) IBOutlet UILabel *staueLab;
@property (weak, nonatomic) IBOutlet UITextField *numFie;
@property (weak, nonatomic) IBOutlet UITextField *sPriceFie;
@property (weak, nonatomic) IBOutlet UITextField *aPriceFie;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak,  nonatomic) CustomBackgroundView *baView;
@property (assign,nonatomic) CGFloat height;
@property (weak,  nonatomic) CustomChWareHouse *chView;
@property (weak,  nonatomic) CustomDatePick *datePickView;
@property (weak,  nonatomic) CustomProtrlView *proView;
@property (strong,nonatomic) ShoppingListInfo *shopInfo;
@property (copy,  nonatomic) NSString *deportId;
@property (copy,  nonatomic) NSString *dateStr;
@property (nonatomic,  copy) NSDictionary *dic;
@end

@implementation TemporaryDepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"输入暂存信息";
    self.dic = @{@"title":@"已提交暂存申请，待审核"};
    self.height = 180;
    [self.nextBtn setLayerWithW:3 andColor:BordColor andBackW:0.0001];
    [self creatBaseView];
    [self loadDatePick];
    [self loadMainProView];
    [self loadProData];
}
#pragma mark -- 网络请求
- (void)loadProData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *netUrl = [NSString stringWithFormat:@"%@%@",baseNet,@"api/help/protocol"];
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

#pragma mark -- 选择仓库
- (void)creatBaseView{
    CustomBackgroundView *bView = [CustomBackgroundView createBackView];
    bView.hidden = YES;
    [self.view addSubview:bView];
    [bView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.baView = bView;
    
    CustomChWareHouse *infoV = [CustomChWareHouse creatCustomView];
    infoV.back = ^(int staue){
        switch (staue) {
            case 0:
                self.cangcLab.text = @"华南仓";
                self.deportId = @"0001";
                break;
            case 1:
                self.cangcLab.text = @"云南仓";
                self.deportId = @"0002";
                break;
            default:
                break;
        }
        [self changeStoreView:YES];
    };
    [self.view addSubview:infoV];
    [infoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(self.height);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(180);
    }];
    self.chView = infoV;
}

- (void)shareShopClick {
    [self changeStoreView:NO];
}

- (void)changeStoreView:(BOOL)isClose{
    BOOL isHi = YES;
    if (self.height==180) {
        if (isClose) {
            return;
        }
        self.height = 0;
        isHi = NO;
    }else{
        self.height = 180;
        isHi = YES;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.chView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(self.height);
        }];
        [self.chView layoutIfNeeded];//强制绘制
        self.baView.hidden = isHi;
    }];
}
#pragma mark -- 日历选择
- (void)loadDatePick{
    CustomDatePick *date = [CustomDatePick creatCustomView];
    [self.view addSubview:date];
    [date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    date.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd";
    date.back = ^(NSDate *date){
        self.dateStr = [formatter stringFromDate:date];
        self.dateLab.text = self.dateStr;
    };
    date.hidden = YES;
    self.datePickView = date;
}

//- (void)dateClick:(UIButton *)sender {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    // 设置时间格式
//    formatter.dateFormat = @"yyyy-MM-dd";
//    [self.datePickView.datePick setDate:[formatter dateFromString:@""] animated:YES];
//    self.datePickView.hidden = NO;
//}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.datePickView.hidden = YES;
    [self changeStoreView:YES];
    self.proView.hidden = YES;
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
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"userId"] = [SaveUserInfoTool shared].id;;
        params[@"goodsId"] = self.shopInfo.id;
        params[@"deportId"] = self.deportId;
        params[@"price"] = self.sPriceFie.text;
        params[@"quantity"] = self.numFie.text;
        params[@"endTime"] = self.dateLab.text;
        NSString *netUrl = [NSString stringWithFormat:@"%@api/store/zc/apply",baseNet];
        [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
            if ([response.code isEqualToString:@"0000"]) {
                [NewUIAlertTool show:self.dic back:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                NSString *str = response.msg?response.msg:@"查询失败";
                [MBProgressHUD showError:str];
            }
        } requestURL:netUrl params:params];
        self.proView.hidden = YES;
    };
    pView.hidden = YES;
    self.proView = pView;
}

- (IBAction)chooseCang:(id)sender {
    [self shareShopClick];
}

- (IBAction)chooseShop:(id)sender {
    ShoppingSearchVC *searchVc = [ShoppingSearchVC new];
    searchVc.isCh = YES;
    searchVc.back = ^(ShoppingListInfo *listInfo) {
        self.shopInfo = listInfo;
        self.staueLab.text = listInfo.standard;
        self.shopLab.text = listInfo.goodsName;
    };
    [self.navigationController pushViewController:searchVc animated:YES];
}

- (IBAction)chooseDate:(id)sender {
    self.datePickView.hidden = NO;
}

- (IBAction)nextClick:(id)sender {
    if (!self.shopInfo) {
        [MBProgressHUD showError:@"请选择商品"];
        return;
    }
    if (self.deportId.length==0) {
        [MBProgressHUD showError:@"请选择仓库"];
        return;
    }
    if ([self.numFie.text intValue]==0) {
        [MBProgressHUD showError:@"请输入正确数量"];
        return;
    }
    if ([self.sPriceFie.text intValue]==0) {
        [MBProgressHUD showError:@"请输入正确价格"];
        return;
    }
    if (![YQObjectBool boolForObject:self.dateStr]) {
        [MBProgressHUD showError:@"请选择时间"];
        return;
    }
    self.proView.hidden = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.numFie.text.length>0&&self.sPriceFie.text.length>0) {
        float aPrice = [self.numFie.text intValue]*[self.sPriceFie.text floatValue];
        self.aPriceFie.text = [OrderNumTool strWithPrice:aPrice];
    }
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
