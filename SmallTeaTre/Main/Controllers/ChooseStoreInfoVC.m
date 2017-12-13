//
//  ChooseStoreInfoVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "ChooseStoreInfoVC.h"
#import "MainNavViewController.h"
#import "ChooseStoreInfoView.h"
#import "RigisterUserInfoVc.h"
#import "IQKeyboardManager.h"
#import "ChooseAddInfoView.h"
#import "ShowLoginViewTool.h"
@interface ChooseStoreInfoVC ()
@property (weak,  nonatomic) IBOutlet UIButton *nextBtn;
@property (weak,  nonatomic) UIView *baView;
@property (weak,  nonatomic) ChooseAddInfoView *addView;
@property (weak,  nonatomic) ChooseStoreInfoView *infoView;
@property (weak,  nonatomic) IBOutlet UILabel *addLab;
@property (weak,  nonatomic) IBOutlet UILabel *storeLab;
@property (nonatomic,  copy) NSString *areaCode;
@property (assign,nonatomic) CGFloat height;
@property (assign,nonatomic) CGFloat addHeight;
@end

@implementation ChooseStoreInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.mutDic) {
        self.mutDic = @{}.mutableCopy;
    }
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self.nextBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
    self.height = 270;
    self.addHeight = 270;
    [self creatAddressView];
    [self creatBaseView];
}

- (void)creatAddressView{
    UIView *bView = [UIView new];
    bView.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
    bView.hidden = YES;
    [self.view addSubview:bView];
    [bView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.baView = bView;
    
    ChooseAddInfoView *infoV = [ChooseAddInfoView createAddPickView];
    [self.view addSubview:infoV];
    infoV.popBack = ^(NSDictionary *store,BOOL isYes){
        if (isYes) {
            self.areaCode = store[@"code"];
            self.addLab.text = store[@"name"];
        }
        [self changeAddView:YES];
    };
    [infoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(self.height);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(270);
    }];
    self.addView = infoV;
}

- (void)creatBaseView{
    ChooseStoreInfoView *infoV = [ChooseStoreInfoView createLoginView];
    [self.view addSubview:infoV];
    infoV.storeBack = ^(NSDictionary *store,BOOL isYes){
        if (isYes) {
            self.mutDic[@"shopId"] = store[@"id"];
            self.storeLab.text = store[@"shopName"];
        }
        [self changeStoreView:YES];
    };
    [infoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(self.height);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(270);
    }];
    self.infoView = infoV;
}

- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)chooseAddress:(id)sender {
    [self changeAddView:NO];
}

- (IBAction)changeStore:(id)sender {
    if (_areaCode.length==0) {
        [MBProgressHUD showError:@"请先选择地区"];
        return;
    }
    self.infoView.areaCode = _areaCode;
    [self changeStoreView:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self changeStoreView:YES];
    [self changeAddView:YES];
}

- (void)changeAddView:(BOOL)isClose{
    BOOL isHi = YES;
    if (self.addHeight==270) {
        if (isClose) {
            return;
        }
        self.addHeight = 0;
        isHi = NO;
    }else{
        self.addHeight = 270;
        isHi = YES;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.addView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(self.addHeight);
        }];
        [self.addView layoutIfNeeded];//强制绘制
        self.baView.hidden = isHi;
    }];
}

- (void)changeStoreView:(BOOL)isClose{
    BOOL isHi = YES;
    if (self.height==270) {
        if (isClose) {
            return;
        }
        self.height = 0;
        isHi = NO;
    }else{
        self.height = 270;
        isHi = YES;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.infoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(self.height);
        }];
        [self.infoView layoutIfNeeded];//强制绘制
        self.baView.hidden = isHi;
    }];
}

- (IBAction)nextClick:(id)sender {
    if (![YQObjectBool boolForObject:self.mutDic[@"shopId"]]) {
        [MBProgressHUD showError:@"请选择门店"];
        return;
    }
    SaveUserInfoTool *save = [SaveUserInfoTool shared];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"userId"] = save.id;
    params[@"shopId"] = self.mutDic[@"shopId"];
    save.shopId = self.mutDic[@"shopId"];
    NSString *netUrl = [NSString stringWithFormat:@"%@api/user/shop/bind",baseNet];
    [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]) {
            if (self.back) {
                self.back(YES);
            }
            return;
        }
        NSString *str = [YQObjectBool boolForObject:response.msg]?response.msg:@"操作失败";
        [MBProgressHUD showError:str];
    } requestURL:netUrl params:params];
//    RigisterUserInfoVc *infoVc = [RigisterUserInfoVc new];
//    infoVc.dic = self.mutDic.copy;
//    infoVc.isFir = YES;
//    MainNavViewController *naviVC = [[MainNavViewController alloc]initWithRootViewController:infoVc];
//    [self presentViewController:naviVC animated:YES completion:nil];
}

@end
