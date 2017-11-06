//
//  HomePageVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/5.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "HomePageVC.h"
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
@property (assign,nonatomic) CGFloat height;
@property (weak,  nonatomic) CustomBackgroundView *baView;
@property (weak,  nonatomic) ShopShareCustomView *shareView;
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
    if ([AccountTool account].isLog) {
        [self loginUser];
    }else{
        [self setBaseTableAndNet];
    }
}

- (void)setBaseTableAndNet{
    [self setupTableView];
    [self setupHeaderRefresh];
//    [self loadHomeHead];
//    [self loadMessage];
}

- (void)loginUser{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = [AccountTool account].loginName;
    params[@"password"] = [AccountTool account].password;
    NSString *logUrl = [NSString stringWithFormat:@"%@api/user/login",baseNet];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        // 处理耗时操作的代码块...
//    });
    [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            params[@"mobile"] = response.result[@"mobile"];
            params[@"isLog"] = @YES;
            Account *account = [Account accountWithDict:params];
            [AccountTool saveAccount:account];
            SaveUserInfoTool *save = [SaveUserInfoTool shared];
            save.id = response.result[@"id"];
            save.nickName = response.result[@"nickName"];
            save.shopId = response.result[@"shopId"];
            save.imgUrl = response.result[@"imgUrl"];
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setBaseTableAndNet];
            });
        }else{
            NSString *str = response.msg?response.msg:@"登录失败";
            [MBProgressHUD showError:str];
        }
    } requestURL:logUrl params:params];
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
    CGRect headF = CGRectMake(0, 0, SDevWidth, SDevWidth*0.53+46);
    //轮播视图
    UIView *headView = [[UIView alloc]initWithFrame:headF];
    headView.backgroundColor = DefaultColor;
    HomePageHeadView *hView = [HomePageHeadView createHeadView];
    [headView addSubview:hView];
    [hView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(0);
        make.top.equalTo(headView).offset(0);
        make.right.equalTo(headView).offset(0);
        make.bottom.equalTo(headView).offset(-6);
    }];
    hView.infoArr = headArr;
    self.headView = hView;
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
    NSString *title = section?@"热门茶叶":@"新茶上架";
    UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 18)];
    UIView *heView = [[UIView alloc]initWithFrame:CGRectMake(9.5, 0,SDevWidth-19, 18)];
    [heView setLayerWithW:0.001 andColor:DefaultColor andBackW:0.5];
    heView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SDevWidth-30, 18)];
    lab.text = title;
    lab.font = [UIFont systemFontOfSize:11];
    lab.backgroundColor = [UIColor whiteColor];
    [hView addSubview:heView];
    [heView addSubview:lab];
    hView.hidden = !isHi;
    return hView;
}

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
