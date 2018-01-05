//
//  AssociatPhoneVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "AssociatPhoneVC.h"
#import "CustomRegisterV.h"
#import "IQKeyboardManager.h"
@interface AssociatPhoneVC ()
@property (nonatomic, weak)CustomRegisterV *regisView;
@end

@implementation AssociatPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self creatRegisterView];
}

- (void)creatRegisterView{
    CustomRegisterV *regisV = [CustomRegisterV createRegisterView];
    SaveUserInfoTool *save = [SaveUserInfoTool shared];
    regisV.logType = save.isQQ?3:2;
    [self.view addSubview:regisV];
    [regisV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(160);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.regisView = regisV;
}

- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
