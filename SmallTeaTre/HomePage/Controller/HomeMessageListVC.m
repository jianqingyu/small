//
//  HomeMessageListVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/27.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "HomeMessageListVC.h"
#import "MainProtocolVC.h"
#import "HomeMessageInfo.h"
@interface HomeMessageListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    int curPage;
    int pageCount;
    int totalCount;
}
@property (nonatomic, strong)UITableView *mTableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation HomeMessageListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公告管理";
    [self setupTableView];
    [self setupHeaderRefresh];
}

- (void)setupTableView{
    self.dataArray = [NSMutableArray new];
    pageCount = 10;
    self.mTableView = [[UITableView alloc]init];
    self.mTableView.backgroundColor = DefaultColor;
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
    NSString *url = [NSString stringWithFormat:@"%@api/notice/page",baseNet];
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
        NSArray *seaArr = [HomeMessageInfo objectArrayWithKeyValuesArray:dict[@"result"]];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *Id = @"centerCell";
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Id];
        customCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        customCell.textLabel.font = [UIFont systemFontOfSize:14];
        customCell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HomeMessageInfo *info;
    if (indexPath.row<_dataArray.count) {
        info = self.dataArray[indexPath.row];
    }
    customCell.textLabel.text = info.title;
    NSString *string = [OrderNumTool strWithTime:info.createTime];
    customCell.detailTextLabel.text = string;
    return customCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeMessageInfo *info;
    if (indexPath.row<_dataArray.count) {
        info = self.dataArray[indexPath.row];
    }
    MainProtocolVC *pro = [MainProtocolVC new];
    pro.title = info.title;
    pro.content = info.content;
    [self.navigationController pushViewController:pro animated:YES];
}

@end
