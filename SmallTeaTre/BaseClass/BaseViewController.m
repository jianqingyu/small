//
//  BaseViewController.m
//  MillenniumStar08.07
//
//  Created by rogers on 15-8-13.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import "BaseViewController.h"
#import "NetworkDetermineTool.h"
#import "NetworkView.h"
#import "NearbyNetworkView.h"
#import "Reachability.h"
#import "HomePageVC.h"
#import "IQKeyboardManager.h"
@interface BaseViewController ()
@property (nonatomic,assign)BOOL isSel;
@property (nonatomic,strong)NetworkDetermineTool *netTool;
@property (nonatomic,strong)NetworkView *networkView;
@property (nonatomic,strong)NearbyNetworkView *netBigworkView;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    App;
    app.loadBack = ^(BOOL isYes){
        [NetworkDetermineTool isSView:isYes andNav:self.navigationController];
        [self.delegate netBack:self andNet:isYes];
    };
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)creatNearNetView:(void (^)(BOOL isWifi))wifiBack{
    if ([NetworkDetermineTool isExistenceNet]) {
        return;
    }
    NearbyNetworkView *netBigView = [NearbyNetworkView creatBigNetView];
    [self.view addSubview:netBigView];
    [netBigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(44);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    netBigView.loadBack = ^(BOOL isYes){
        wifiBack(isYes);
    };
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
