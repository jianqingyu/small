//
//  HomePageVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/5.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "HomePageVC.h"
#import "HomePageHeadSView.h"
#import "MainTabViewController.h"
#import "TeaListTableCell.h"
#import "HYBLoopScrollView.h"
#import "HomePageHeadView.h"
#import "ShowHidenTabBar.h"
#import "HomeShopListInfo.h"
#import "CustomBackgroundView.h"
#import "ShopShareCustomView.h"
#import "HomeShoppingDetailVc.h"
#import "ShoppingListInfo.h"
#import "ChooseStoreInfoTool.h"
#import "LoggingWithDataTool.h"
@interface HomePageVC ()<UITableViewDelegate,UITableViewDataSource,
UINavigationControllerDelegate>{
    int pageCount;
    int onePage;
    int oneCount;
    int curPage;
    int totalCount;//商品总数量
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,  weak) HomePageHeadView *headView;
@property(nonatomic,strong) NSMutableArray *oneData;
@property(nonatomic,strong) NSMutableArray *twoData;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(assign,nonatomic) CGFloat height;
@property(weak,  nonatomic) CustomBackgroundView *baView;
@property(weak,  nonatomic) ShopShareCustomView *shareView;
@property(nonatomic,  copy) NSDictionary *versionDic;
@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultColor;
    pageCount = 10;
    self.oneData = @[].mutableCopy;
    self.twoData = @[].mutableCopy;
    self.height = 190;
    [self creatBaseView];
    //是否登录过
    if ([SaveUserInfoTool shared].haveLog) {
        [self setBaseTableAndNet];
        return;
    }
    [self loginUserInfo];
}

- (void)setBaseTableAndNet{
    [self setupTableView];
    [self setupHeaderRefresh];
//    [self loadHomeHead];
//    [self loadMessage];
}

- (void)loginUserInfo{
    int type = [[AccountTool account].isLog intValue];
    switch (type) {
        case 0:
            [self setBaseTableAndNet];
            break;
        case 1:
            [self loginByPhone];
            break;
        case 2:
            [self loginByWeiXin];
            break;
        case 3:
            [self loginByQQ];
            break;
        default:
            break;
    }
}

- (void)loginByPhone{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = [AccountTool account].loginName;
    params[@"password"] = [AccountTool account].password;
    NSMutableDictionary *dic = @{}.mutableCopy;
    dic[@"isLog"] = @1;
    NSString *logUrl = [NSString stringWithFormat:@"%@api/user/login",baseNet];
    [LoggingWithDataTool logData:params andUrl:logUrl andSaveDic:dic andBack:^(int type) {
        if (type==1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setBaseTableAndNet];
            });
        }
    }];
}

- (void)loginByWeiXin{
    NSString *refesh = [AccountTool account].refeshKey;
    NSString *userUrl = @"https://api.weixin.qq.com/sns/oauth2/refresh_token";
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"appid"] = @"wxce488c9ce08c20e3";
    params[@"grant_type"] = @"refresh_token";
    params[@"refresh_token"] = refesh;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",nil];
    [manager GET:userUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject[@"access_token"]) {
            params[@"isLog"] = @2;
            params[@"refeshKey"] = refesh;
            NSString *logUrl = [NSString stringWithFormat:@"%@api/user/wx/auth",baseNet];
            NSMutableDictionary *dic = @{}.mutableCopy;
            dic[@"access_token"] = responseObject[@"access_token"];
            dic[@"openid"] = responseObject[@"openid"];
            [LoggingWithDataTool logData:dic andUrl:logUrl andSaveDic:params andBack:^(int type) {
                if (type==1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setBaseTableAndNet];
                    });
                }
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"用refresh_token来更新accessToken时出错 = %@", error);
    }];
}

- (void)loginByQQ{
    NSString *refesh = [AccountTool account].refeshKey;
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"access_token"] = refesh;
    NSMutableDictionary *dic = @{}.mutableCopy;
    dic[@"isLog"] = @3;
    dic[@"refeshKey"] = refesh;
    NSString *logUrl = [NSString stringWithFormat:@"%@api/user/qq/auth",baseNet];
    [LoggingWithDataTool logData:params andUrl:logUrl andSaveDic:dic andBack:^(int type) {
        if (type==1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setBaseTableAndNet];
            });
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
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

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.view sendSubviewToBack:self.tableView];
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
    // 11.0以上才有这个属性
    if (@available(iOS 11.0, *)){
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)loadHomeHead{
    NSString *url = [NSString stringWithFormat:@"%@api/ads/page",baseNet];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = @1;
    params[@"pageSize"] = @5;
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]) {
            if ([YQObjectBool boolForObject:response.result]){
                NSArray *arr = response.result[@"result"];
                [self creatCusTomHeadView:arr];
                [self loadMessage];
            }
        }
    } requestURL:url params:params];
}

- (void)loadMessage{
    NSString *url = [NSString stringWithFormat:@"%@api/notice/page",baseNet];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = @1;
    params[@"pageSize"] = @1;
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]) {
            if ([YQObjectBool boolForObject:response.result]){
                NSArray *arr = response.result[@"result"];
                if (arr.count>0) {
                    self.headView.messDic = arr[0];
                }
            }
        }
        if ([SaveUserInfoTool shared].haveLog) {
            [ChooseStoreInfoTool chooseInfo:4];
        }
    } requestURL:url params:params];
}

- (void)loadNewTea{
    NSString *url = [NSString stringWithFormat:@"%@api/goods/page",baseNet];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tag"] = @"02";
    params[@"index"] = @1;
    params[@"pageSize"] = @3;
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]) {
            if ([YQObjectBool boolForObject:response.result]){
                [self setupListDataWithDict:response.result and:NO];
            }
            [self.tableView reloadData];
        }
    } requestURL:url params:params];
}

#pragma mark -- 网络请求
- (void)setupHeaderRefresh{
    // 刷新功能
    MJRefreshStateHeader*header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headerRereshing];
    }];
    [header setTitle:@"用力往下拉我!!!" forState:MJRefreshStateIdle];
    [header setTitle:@"快放开我!!!" forState:MJRefreshStatePulling];
    [header setTitle:@"努力刷新中..." forState:MJRefreshStateRefreshing];
    _tableView.header = header;
    [self.tableView.header beginRefreshing];
}

- (void)setupFootRefresh{
    
    MJRefreshAutoNormalFooter*footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
    [footer setTitle:@"上拉有惊喜" forState:MJRefreshStateIdle];
    [footer setTitle:@"好了，可以放松一下手指" forState:MJRefreshStatePulling];
    [footer setTitle:@"努力加载中，请稍候" forState:MJRefreshStateRefreshing];
    _tableView.footer = footer;
}
#pragma mark - refresh
- (void)headerRereshing{
    [self loadNewRequestWith:YES];
}

- (void)footerRereshing{
    [self loadNewRequestWith:NO];
}

- (void)loadNewRequestWith:(BOOL)isPullRefresh{
    if (isPullRefresh){
        curPage = 1;
        [self.oneData removeAllObjects];
        [self.twoData removeAllObjects];
        [self loadHomeHead];
        [self loadNewTea];
    }
    [self getCommodityData];
}

- (void)getCommodityData{
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    NSString *url = [NSString stringWithFormat:@"%@api/goods/page",baseNet];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tag"] = @"01";
    params[@"index"] = @(curPage);
    params[@"pageSize"] = @(pageCount);
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if ([response.code isEqualToString:@"0000"]) {
            [self setupFootRefresh];
            if ([YQObjectBool boolForObject:response.result]){
                [self setupListDataWithDict:response.result and:YES];
            }
            [self.tableView reloadData];
        }
        self.view.userInteractionEnabled = YES;
    } requestURL:url params:params];
}

- (void)setupListDataWithDict:(NSDictionary *)dict and:(BOOL)isYes{
    if (isYes) {
        if([YQObjectBool boolForObject:dict[@"result"]]){
            self.tableView.footer.state = MJRefreshStateIdle;
            curPage++;
            totalCount = [dict[@"totalPage"]intValue];
            NSArray *seaArr = [ShoppingListInfo objectArrayWithKeyValuesArray:dict[@"result"]];
            [self.twoData addObjectsFromArray:seaArr];
            if(curPage>totalCount){
                //已加载全部数据
                MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_tableView.footer;
                [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
                self.tableView.footer.state = MJRefreshStateNoMoreData;
            }
        }else{
            //[self.tableView.header removeFromSuperview];
            MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_tableView.footer;
            [footer setTitle:@"暂时没有商品" forState:MJRefreshStateNoMoreData];
            _tableView.footer.state = MJRefreshStateNoMoreData;
        }
    }else{
        if([YQObjectBool boolForObject:dict[@"result"]]){
            NSArray *arr = [ShoppingListInfo objectArrayWithKeyValuesArray:dict[@"result"]];
            self.oneData = arr.mutableCopy;
        }
    }
}

#pragma mark - 初始化图片
- (void)creatCusTomHeadView:(id)arr{
    [self setupHeadView:arr];
}

- (NSString *)UsingEncoding:(NSString *)str{
    NSString *url = [NSString stringWithFormat:@"%@%@",baseNet,str];
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)setupHeadView:(NSArray *)headArr{
    CGRect headF = CGRectMake(0, 0, SDevWidth, SDevWidth*0.53+40+70+2*6);
    //轮播视图
    UIView *headView = [[UIView alloc]initWithFrame:headF];
    headView.backgroundColor = DefaultColor;
    HomePageHeadView *hView = [HomePageHeadView createHeadView];
    [headView addSubview:hView];
    [hView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(0);
        make.top.equalTo(headView).offset(0);
        make.right.equalTo(headView).offset(0);
        make.bottom.equalTo(headView).offset(-(70+2*6));
    }];
    hView.infoArr = headArr;
    self.headView = hView;
    HomePageHeadSView *sView = [HomePageHeadSView createHeadSView];
    [headView addSubview:sView];
    [sView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(0);
        make.height.mas_equalTo(70);
        make.right.equalTo(headView).offset(0);
        make.bottom.equalTo(headView).offset(-6);
    }];
    self.tableView.tableHeaderView = headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section?self.twoData.count:self.oneData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0001f;
    if (section==0&&self.oneData.count>0) {
        height = 18.0f;
    }
    if (section==1&&self.twoData.count>0) {
        height = 18.0f;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BOOL isHi = section?self.twoData.count:self.oneData.count;
    NSString *title = section?@"hot_tea":@"new_tea";
    UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 18)];
    UIView *heView = [[UIView alloc]initWithFrame:CGRectMake(9.5, 0,SDevWidth-19, 18)];
    [heView setLayerWithW:0.001 andColor:DefaultColor andBackW:0.5];
    heView.backgroundColor = DefColor;

    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 45, 12)];
    image.image = [UIImage imageNamed:title];
    [hView addSubview:heView];
    [heView addSubview:image];
    hView.hidden = !isHi;
    return hView;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    BOOL isHi = section?self.twoData.count:self.oneData.count;
//    NSString *title = section?@"热门茶叶":@"新茶上架";
//    UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 18)];
//    UIView *heView = [[UIView alloc]initWithFrame:CGRectMake(9.5, 0,SDevWidth-19, 18)];
//    [heView setLayerWithW:0.001 andColor:DefaultColor andBackW:0.5];
//    heView.backgroundColor = [UIColor whiteColor];
//
//    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SDevWidth-30, 18)];
//    lab.text = title;
//    lab.font = [UIFont systemFontOfSize:11];
//    lab.backgroundColor = [UIColor whiteColor];
//    [hView addSubview:heView];
//    [heView addSubview:lab];
//    hView.hidden = !isHi;
//    return hView;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section==1) {
//        return [UIView new];
//    }
//    UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 29)];
//    UIButton *footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    footBtn.frame = CGRectMake(9.5, 0,SDevWidth-19, 24);
//    footBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [footBtn setTitle:@"加载更多" forState:UIControlStateNormal];
//    [footBtn setTitleColor:CUSTOM_COLOR(40, 40, 40) forState:UIControlStateNormal];
//    [footBtn addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
//    [hView addSubview:footBtn];
//    return hView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeaListTableCell *teaCell = [TeaListTableCell cellWithTableView:tableView];
    NSArray *arr = indexPath.section?self.twoData:self.oneData;
    ShoppingListInfo *listInfo;
    if (indexPath.row<arr.count) {
        listInfo = arr[indexPath.row];
    }
    teaCell.listInfo = listInfo;
    teaCell.back = ^(int staue,BOOL isYes){
        if (staue==2) {
            self.shareView.shareDic = [self dicWithList:listInfo];
            [self shareShopClick];
        }
    };
    return teaCell;
}

- (NSDictionary *)dicWithList:(ShoppingListInfo *)listInfo{
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"title"] = listInfo.goodsName;
    params[@"des"] = listInfo.introduction;
    params[@"image"] = listInfo.imgUrl;
    params[@"url"] = listInfo.informationUrl;
    return params.copy;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeShoppingDetailVc *detail = [HomeShoppingDetailVc new];
    NSArray *arr = indexPath.section?self.twoData:self.oneData;
    ShoppingListInfo *listInfo;
    if (indexPath.row<arr.count) {
        listInfo = arr[indexPath.row];
    }
    detail.title = listInfo.goodsName;
    detail.url = listInfo.informationUrl;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
