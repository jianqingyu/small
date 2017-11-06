//
//  UserMyOrderListVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/20.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserMyOrderListVC.h"
#import "WareHouseListTableCell.h"
#import "ShoppingListInfo.h"
@interface UserMyOrderListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    int curPage;
    int pageCount;
    int totalCount;//商品总数量
}
@property (nonatomic,strong)UITableView *mTableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation UserMyOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultColor;
    [self setupTableView];
    [self setupHeaderRefresh];
}

- (void)setupTableView{
    self.dataArray = [NSMutableArray new];
    pageCount = 10;
    self.mTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.mTableView.backgroundColor = DefaultColor;
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.mTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
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
    _mTableView.header = header;
    [_mTableView.header beginRefreshing];
}

- (void)setupFootRefresh{
    
    MJRefreshAutoNormalFooter*footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
    [footer setTitle:@"上拉有惊喜" forState:MJRefreshStateIdle];
    [footer setTitle:@"好了，可以放松一下手指" forState:MJRefreshStatePulling];
    [footer setTitle:@"努力加载中，请稍候" forState:MJRefreshStateRefreshing];
    _mTableView.footer = footer;
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
        [_dataArray removeAllObjects];
    }
    [self getCommodityData];
}

- (void)getCommodityData{
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    NSString *url = [NSString stringWithFormat:@"%@api/order/list",baseNet];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = @(curPage);
    params[@"pageSize"] = @(pageCount);
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        [_mTableView.header endRefreshing];
        [_mTableView.footer endRefreshing];
        if ([response.code isEqualToString:@"0000"]) {
            [self setupFootRefresh];
            if ([YQObjectBool boolForObject:response.result]){
                [self setupListDataWithDict:response.result];
            }
            [_mTableView reloadData];
            self.view.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
        }
    } requestURL:url params:params];
}

- (void)setupListDataWithDict:(NSDictionary *)dict{
    if([dict[@"result"] isKindOfClass:[NSArray class]]
       && [dict[@"result"] count]>0){
        _mTableView.footer.state = MJRefreshStateIdle;
        curPage++;
        totalCount = [dict[@"totalPage"]intValue];
        NSArray *seaArr = [UserOrderListInfo objectArrayWithKeyValuesArray:dict[@"result"]];
        [_dataArray addObjectsFromArray:seaArr];
        if(curPage>totalCount){
            //已加载全部数据
            MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_mTableView.footer;
            [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
            _mTableView.footer.state = MJRefreshStateNoMoreData;
        }
    }else{
        //[_mTableView.header removeFromSuperview];
        MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)_mTableView.footer;
        [footer setTitle:@"暂时没有商品" forState:MJRefreshStateNoMoreData];
        _mTableView.footer.state = MJRefreshStateNoMoreData;
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
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
    WareHouseListTableCell *cell = [WareHouseListTableCell cellWithTableView:tableView];
    UserOrderListInfo *listInfo;
    if (indexPath.section<_dataArray.count) {
        listInfo = _dataArray[indexPath.section];
    }
    cell.orderInfo = listInfo;
    return cell;
}

@end
