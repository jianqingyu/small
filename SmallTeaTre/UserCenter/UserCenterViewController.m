//
//  UserCenterViewController.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/20.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserCenterListCell.h"
#import "UserCenterHeadView.h"
#import "LoginViewController.h"
#import "ShowHidenTabBar.h"
#import "CustomBackgroundView.h"
#import "ShopShareCustomView.h"
#import <ShareSDK/ShareSDK.h>
#import "MainTabViewController.h"
#import "ChooseStoreInfoTool.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
@interface UserCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
@property(strong, nonatomic) UITableView *tableView;
@property(nonatomic,   copy) NSArray *list;
@property (assign,nonatomic) CGFloat height;
@property (nonatomic,assign) BOOL isNewVer;
@property (weak,  nonatomic) UserCenterHeadView *userHV;
@property (weak,  nonatomic) CustomBackgroundView *baView;
@property (weak,  nonatomic) ShopShareCustomView *shareView;
@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.list = @[@{@"image":@"icon_store_info",@"title":@"门店信息",@"vc":@"UserStoreInfoVC"},
                  @{@"image":@"icon_fav",@"title":@"我的收藏",@"vc":@"UserMyCollection"},
                  @{@"image":@"icon_order",@"title":@"我的订单",@"vc":@"UserMyOrderListVC"},
                  @{@"image":@"icon_share_2",@"title":@"分享小茶宝",@"vc":@"UserShare"},
                  @{@"image":@"icon_help",@"title":@"使用帮助及协议",
                    @"vc":@"UserHelpViewController"},
                  @{@"image":@"icon_me",@"title":@"关于我们",@"vc":@"UserAboutUsVc"},
                  @{@"image":@"icon_set",@"title":@"设置",@"vc":@"UserReSetViewC"}];
    [self setupTableView];
    self.height = 190;
    [self creatBaseView];
}

- (NSDictionary *)shareDic{
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"title"] = @"小茶宝";
    params[@"des"] = @"下载地址";
    params[@"image"] = [UIImage imageNamed:@"logo"];
    params[@"url"] = [@"http://appurl.me/17720737"stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return params.copy;
}

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
    
    ShopShareCustomView *infoV = [ShopShareCustomView creatCustomView];
    [self.view addSubview:infoV];
    infoV.back = ^(BOOL isYes){
        if (self.height == 48) {
            [self changeStoreView:YES];
        }
    };
    [infoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(self.height);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(190);
    }];
    self.shareView = infoV;
    self.shareView.isApp = YES;
    self.shareView.shareDic = [self shareDic];
}

- (void)shareShopClick {
    [self changeStoreView:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self changeStoreView:YES];
}

- (void)changeStoreView:(BOOL)isClose{
    BOOL isHi = YES;
    if (self.height==190) {
        if (isClose) {
            return;
        }
        self.height = 48;
        isHi = NO;
        [ShowHidenTabBar hideTabBar:self];
    }else{
        self.height = 190;
        isHi = YES;
        [ShowHidenTabBar showTabBar:self];
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(self.height);
        }];
        [self.shareView layoutIfNeeded];//强制绘制
        self.baView.hidden = isHi;
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    if (self.userHV) {
        [self.userHV setUserInfo];
    }
    [self loadMessCountData];
    [self loadAboutUsVersion];
}

- (void)loadMessCountData{
    NSString *str = @"api/msg/zc";
    NSString *url = [NSString stringWithFormat:@"%@%@",baseNet,str];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = @(1);
    params[@"userId"] = [SaveUserInfoTool shared].id;
    params[@"pageSize"] = @(10);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]) {
            int number = [response.result[@"totalRows"]intValue];
            NSString *messCount = [[NSUserDefaults standardUserDefaults]objectForKey:@"messCount"];
            BOOL isNew = number>[messCount intValue];
            if (self.userHV) {
                [self.userHV changeBtnNew:isNew];
            }
        }
    } requestURL:url params:params];
}

- (void)loadAboutUsVersion{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *netUrl = [NSString stringWithFormat:@"%@api/app/info",baseNet];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            NSString *newVer = response.result[@"app_ios_version"];
            NSString *ver = [[NSUserDefaults standardUserDefaults]objectForKey:@"iOSVer"];
            self.isNewVer = ![newVer isEqualToString:ver];
            [self.tableView reloadData];
        }else{
            NSString *str = response.msg?response.msg:@"查询失败";
            [MBProgressHUD showError:str];
        }
    } requestURL:netUrl params:params];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = DefaultColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self setupHeadView];
    [self setupFootView];
}

- (void)setupHeadView{
    UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, SDevWidth*0.71+10)];
    hView.backgroundColor = DefaultColor;
    UserCenterHeadView *headV = [UserCenterHeadView createHeadView];
    [hView addSubview:headV];
    [headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hView).offset(0);
        make.left.equalTo(hView).offset(0);
        make.right.equalTo(hView).offset(0);
        make.bottom.equalTo(hView).offset(-10);
    }];
    [headV setUserInfo];
    self.userHV = headV;
    self.tableView.tableHeaderView = hView;
}

- (void)setupFootView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 65)];
    footView.backgroundColor = DefaultColor;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:
                                                   UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [footView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(0);
        make.top.equalTo(footView).offset(10);
        make.right.equalTo(footView).offset(0);
        make.height.mas_equalTo(@45);
    }];
    self.tableView.tableFooterView = footView;
}

- (void)cancelClick{
    NSString *url = [NSString stringWithFormat:@"%@api/user/logout",baseNet];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]) {
            params[@"loginName"] = [AccountTool account].loginName;
            params[@"password"] = [AccountTool account].password;
            params[@"mobile"] = [AccountTool account].mobile;
            params[@"isLog"] = @0;
            Account *account = [Account accountWithDict:params];
            [AccountTool saveAccount:account];
            SaveUserInfoTool *save = [SaveUserInfoTool shared];
            [save clearAllData];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[LoginViewController alloc]init];
        }
    } requestURL:url params:params];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserCenterListCell *cell = [UserCenterListCell cellWithTableView:tableView];
    NSDictionary *mesDic = self.list[indexPath.row];
    if ([mesDic[@"title"]isEqualToString:@"关于我们"]) {
        cell.isNewVer = self.isNewVer;
    }
    cell.dic = mesDic;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.list[indexPath.row];
    NSString *class = dic[@"vc"];
    if ([class isEqualToString:@"UserStoreInfoVC"]) {
        [ChooseStoreInfoTool chooseInfo:3];
        return;
    }
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    //如果没有则注册一个类
    if (!newClass) {
        [self shareShopClick];
        return;
    }
//    if (!newClass) {
//        Class superClass = [NSObject class];
//        newClass = objc_allocateClassPair(superClass, className, 0);
//        objc_registerClassPair(newClass);
//    }
    // 创建对象
    BaseViewController *instance = [[newClass alloc] init];
    instance.title = dic[@"title"];
    [self.navigationController pushViewController:instance animated:YES];
}

@end
