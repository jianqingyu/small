//
//  ShoppingSearchVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/8.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "ShoppingSearchVC.h"
#import "ShoppingListInfo.h"
#import "HomeShoppingDetailVc.h"
#import "ShopShareCustomView.h"
#import "CustomTitleView.h"
#import "ShoppingListTableCell.h"
@interface ShoppingSearchVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    int curPage;
    int pageCount;
    int totalCount;//商品总数量
}
@property (weak,  nonatomic) UISearchBar *searchBar;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (weak,  nonatomic) UIView *baView;
@property (assign,nonatomic) CGFloat height;
@property (weak,  nonatomic) ShopShareCustomView *shareView;
@end

@implementation ShoppingSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultColor;
    pageCount = 10;
    [self creatNaviBaseView];
    [self setupTableView];
    self.height = 190;
    [self creatBaseView];
    [self setupHeaderRefresh];
    if (@available(iOS 11.0, *)) {
        
    } else {
        
    }
}

- (void)creatNaviBaseView{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
    UIButton *bar = [UIButton buttonWithType:UIButtonTypeCustom];
    bar.frame = CGRectMake(0, 0, 30, 30);
    [bar setTitle:@"取消" forState:UIControlStateNormal];
    bar.titleLabel.font = [UIFont systemFontOfSize:15];
    [bar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bar addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bar];
    
    CustomTitleView *titleView = [[CustomTitleView alloc]init];
    titleView.frame = CGRectMake(0, 0, SDevWidth*0.65, 30);
    titleView.backgroundColor = [UIColor whiteColor];
    [titleView setLayerWithW:3 andColor:BordColor andBackW:0.0001];
    UISearchBar *seaBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    [titleView addSubview:seaBar];
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [seaBar setPlaceholder:@"搜索茶叶信息"];
    if (!self.isCh) {
        [seaBar becomeFirstResponder];
    }
    for (id view in seaBar.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            for (id laV in [view subviews]){
                if ([laV isKindOfClass:[UITextField class]]) {
                    [laV setReturnKeyType:UIReturnKeyDone];
                }
            }
        }
        if ([view isKindOfClass:[UITextField class]]) {
            [view setReturnKeyType:UIReturnKeyDone];
        }
    }
    seaBar.delegate = self;
    self.searchBar = seaBar;
    
    UIImage *backImg = [CommonUtils createImageWithColor:[UIColor clearColor]];
    [self.searchBar setBackgroundImage:backImg];
     self.navigationItem.titleView = titleView;
}

- (void)btnClick:(id)sender{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length>0) {
        [self.tableView.header beginRefreshing];
        [searchBar resignFirstResponder];
    }
}
#pragma mark -- 分享
- (void)creatBaseView{
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
    
    ShopShareCustomView *infoV = [ShopShareCustomView creatCustomView];
    [self.view addSubview:infoV];
    infoV.back = ^(BOOL isYes){
        [self changeStoreView:YES];
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
        self.height = 0;
        isHi = NO;
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
    }];
}
#pragma mark -- tableView
- (void)setupTableView{
    self.dataArray = [NSMutableArray new];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
    // 11.0以上才有这个属性
    if (@available(iOS 11.0, *)){
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
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
    if (_searchBar.text.length==0&&!self.isCh) {
        [_tableView.header endRefreshing];
        return;
    }
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    NSString *url = [NSString stringWithFormat:@"%@api/goods/shop/page",baseNet];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = @(curPage);
    params[@"pageSize"] = @(pageCount);
    params[@"goodsName"] = _searchBar.text;
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if ([response.code isEqualToString:@"0000"]) {
            [self setupFootRefresh];
            if ([YQObjectBool boolForObject:response.result]){
                [self setupListDataWithDict:response.result];
            }
            [self.tableView reloadData];
            self.view.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
        }
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
        if(curPage>=totalCount){
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
    ShoppingListInfo *listInfo;
    if (indexPath.section<self.dataArray.count) {
        listInfo = self.dataArray[indexPath.section];
    }
    if (self.isCh) {
        if (self.back) {
            self.back(listInfo);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    HomeShoppingDetailVc *detail = [HomeShoppingDetailVc new];
    detail.title = listInfo.goodsName;
    detail.url = listInfo.informationUrl;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
