//
//  ShoppingMallVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/1.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "ShoppingMallVC.h"
#import "ShoppingSearchVC.h"
#import "MainTabViewController.h"
#import "CustomBackgroundView.h"
#import "ShopShareCustomView.h"
#import "ShoppingListTableCell.h"
#import "HomeShoppingDetailVc.h"
#import "ShowHidenTabBar.h"
#import "ShoppingListInfo.h"
@interface ShoppingMallVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    int curPage;
    int pageCount;
    int totalCount;//商品总数量
}
@property (weak,  nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (assign,nonatomic) CGFloat height;
@property (weak,  nonatomic) CustomBackgroundView *baView;
@property (weak,  nonatomic) ShopShareCustomView *shareView;
@end

@implementation ShoppingMallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultColor;
    UIImage *backImg = [CommonUtils createImageWithColor:CUSTOM_COLOR(210, 210, 210)];
    [self.searchBar setBackgroundImage:backImg];
    self.searchBar.delegate = self;
    [self setupTableView];
    [self setupHeaderRefresh];
    self.height = 190;
    [self creatBaseView];
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
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(self.height);
        }];
        [self.shareView layoutIfNeeded];//强制绘制
        self.baView.hidden = isHi;
        if (isHi) {
            [ShowHidenTabBar showTabBar:self];
        }
    }];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    ShoppingSearchVC *searchVc = [ShoppingSearchVC new];
    [self.navigationController pushViewController:searchVc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)setupTableView{
    self.dataArray = [NSMutableArray new];
    pageCount = 10;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = DefaultColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(44);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
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
        [self.dataArray removeAllObjects];
    }
    [self getCommodityData];
}

- (void)getCommodityData{
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    NSString *url = [NSString stringWithFormat:@"%@api/goods/shop/page",baseNet];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = @(curPage);
    params[@"pageSize"] = @(pageCount);
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if ([response.code isEqualToString:@"0000"]) {
            [self setupFootRefresh];
            if ([YQObjectBool boolForObject:response.result]){
                [self setupListDataWithDict:response.result];
            }
            [self.tableView reloadData];
        }
        self.view.userInteractionEnabled = YES;
    } requestURL:url params:params];
}

- (void)setupListDataWithDict:(NSDictionary *)dict{
    if([dict[@"result"] isKindOfClass:[NSArray class]]
       && [dict[@"result"] count]>0){
        self.tableView.footer.state = MJRefreshStateIdle;
        curPage++;
        totalCount = [dict[@"totalPage"]intValue];
        NSArray *seaArr = [ShoppingListInfo objectArrayWithKeyValuesArray:dict[@"result"]];
        [_dataArray addObjectsFromArray:seaArr];
        if(curPage>totalCount){
            //已加载全部数据
            MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_tableView.footer;
            [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        }
    }else{
        //[self.tableView.header removeFromSuperview];
        MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_tableView.footer;
        [footer setTitle:@"暂时没有商品" forState:MJRefreshStateNoMoreData];
        _tableView.footer.state = MJRefreshStateNoMoreData;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0001f;
    if (section==0) {
        height = 5.0f;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShoppingListTableCell *teaCell = [ShoppingListTableCell cellWithTableView:tableView];
    ShoppingListInfo *listInfo;
    if (indexPath.section<self.dataArray.count) {
        listInfo = self.dataArray[indexPath.section];
    }
    teaCell.listInfo = listInfo;
    teaCell.back = ^(int staue,BOOL isYes){
        if (staue==2){
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
    ShoppingListInfo *listInfo;
    if (indexPath.section<self.dataArray.count) {
        listInfo = self.dataArray[indexPath.section];
    }
    HomeShoppingDetailVc *detail = [HomeShoppingDetailVc new];
    detail.title = listInfo.goodsName;
    detail.url = listInfo.informationUrl;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
