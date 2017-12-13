//
//  AdaptationShopVC.m
//  SmallTeaTre
//
//  Created by 余建清 on 2017/11/24.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "AdaptationShopVC.h"
#import "CustomDatePick.h"
@interface AdaptationShopVC ()
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) CustomDatePick *datePickView;
@property (nonatomic, copy) NSDictionary *dic;
@property (nonatomic, copy) NSString *dateStr;
@end

@implementation AdaptationShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择续存日期";
    self.dic = @{@"title":@"已提交续存申请，待审核"};
    [self.nextBtn setLayerWithW:3 andColor:BordColor andBackW:0.0001];
    [self loadDatePick];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.datePickView.hidden = YES;
}

- (IBAction)dateClick:(id)sender {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    // 设置时间格式
//    formatter.dateFormat = @"yyyy-MM-dd";
//    [self.datePickView.datePick setDate:[formatter dateFromString:@""] animated:YES];
    self.datePickView.hidden = NO;
}

- (IBAction)nextClick:(id)sender {
    if (![YQObjectBool boolForObject:self.dateStr]) {
        [MBProgressHUD showError:@"请选择时间"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"goodsId"] = _info.goodsId;
    params[@"date"] = self.dateLab.text;
    params[@"id"] = _info.id;
    NSString *netUrl = [NSString stringWithFormat:@"%@api/store/xc/apply",baseNet];
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
