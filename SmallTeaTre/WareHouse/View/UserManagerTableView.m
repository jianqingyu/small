//
//  ServerTypeTableView.m
//  CheKu
//
//  Created by JIMU on 15/5/14.
//  Copyright (c) 2015年 puxiang. All rights reserved.
//

#import "UserManagerTableView.h"
#import "WareChooseNumVc.h"
#import "WareHouseListTableCell.h"
#import "WareHouseDetailVC.h"
#import "WareConfirmRedeemVc.h"
#import "WareListInfo.h"
#import "AssignmentShopVC.h"
@interface UserManagerTableView()<UITableViewDataSource,UITableViewDelegate>{
    int curPage;
    int pageCount;
    int totalCount;//商品总数量
    NSMutableArray *_dataArray;
    UITableView *_mTableView;
    BOOL isFir;
}

@end

@implementation UserManagerTableView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        curPage = 1;
        pageCount = 10;
        _dataArray = [NSMutableArray array];
        _mTableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                style:UITableViewStyleGrouped];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:_mTableView];
        [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0);
            make.top.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.bottom.equalTo(self).offset(0);
        }];
        // 11.0以上才有这个属性
        if (@available(iOS 11.0, *)){
            _mTableView.estimatedRowHeight = 0;
            _mTableView.estimatedSectionHeaderHeight = 0;
            _mTableView.estimatedSectionFooterHeight = 0;
        }
        [self setupHeaderRefresh];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict{
    if (dict) {
        _dict = dict;
        if (isFir) {
            return;
        }
        [_mTableView.header beginRefreshing];
    }
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
    if ([self.dict[@"deportId"]length]==0) {
        [_mTableView.header endRefreshing];
        return;
    }
    isFir = YES;
    [SVProgressHUD show];
    self.userInteractionEnabled = NO;
    NSString *url = [NSString stringWithFormat:@"%@api/store/list",baseNet];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = @(curPage);
    params[@"pageSize"] = @(pageCount);
    params[@"storeType"] = _dict[@"deportId"];
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        [_mTableView.header endRefreshing];
        [_mTableView.footer endRefreshing];
        if ([response.code isEqualToString:@"0000"]) {
            [self setupFootRefresh];
            if ([YQObjectBool boolForObject:response.result]){
                [self setupListDataWithDict:response.result];
            }
            [_mTableView reloadData];
        }
        self.userInteractionEnabled = YES;
    } requestURL:url params:params];
}

- (void)setupListDataWithDict:(NSDictionary *)dict{
    if([dict[@"result"] isKindOfClass:[NSArray class]]
       && [dict[@"result"] count]>0){
        _mTableView.footer.state = MJRefreshStateIdle;
        curPage++;
        totalCount = [dict[@"totalPage"]intValue];
        NSArray *seaArr = [WareListInfo objectArrayWithKeyValuesArray:dict[@"result"]];
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
//    cell.reBack = ^(BOOL isYes){
//        WareConfirmRedeemVc *redVc = [WareConfirmRedeemVc new];
//        [self.superNav pushViewController:redVc animated:YES];
//    };
    WareListInfo *listInfo;
    if (indexPath.section<_dataArray.count) {
        listInfo = _dataArray[indexPath.section];
    }
    cell.listInfo = listInfo;
    return cell;
}

#pragma mark -- UITableDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WareListInfo *listInfo;
    if (indexPath.section<_dataArray.count) {
        listInfo = _dataArray[indexPath.section];
    }
    [self gotoNextViewControll:listInfo];
}
//跳到下一步
- (void)gotoNextViewControll:(WareListInfo *)listInfo{
    //暂存交易成功
    if ([listInfo.transType isEqualToString:@"0001"]&&listInfo.transStatus==3) {
        WareHouseDetailVC *detailVc = [WareHouseDetailVC new];
        detailVc.back = ^(BOOL isYes){
            [_mTableView.header beginRefreshing];
        };
        detailVc.title = listInfo.goodsName;
        detailVc.arr = @[listInfo];
        [self.superNav pushViewController:detailVc animated:YES];
        return;
    }
    //质押审核通过 -- 交易成功
    if ([listInfo.transType isEqualToString:@"0004"]) {
        if (listInfo.transStatus==1||listInfo.transStatus==3) {
            WareConfirmRedeemVc *redVc = [WareConfirmRedeemVc new];
            redVc.back = ^(BOOL isYes){
                [_mTableView.header beginRefreshing];
            };
            redVc.info = listInfo;
            [self.superNav pushViewController:redVc animated:YES];
            return;
        }
    }
    //赎回审核通过
    if ([listInfo.transType isEqualToString:@"0002"]&&listInfo.transStatus==1) {
        WareConfirmRedeemVc *redVc = [WareConfirmRedeemVc new];
        redVc.back = ^(BOOL isYes){
            [_mTableView.header beginRefreshing];
        };
        redVc.info = listInfo;
        [self.superNav pushViewController:redVc animated:YES];
        return;
    }
    //取消转让
    if ([listInfo.transType isEqualToString:@"0003"]&&listInfo.transStatus==0) {
        AssignmentShopVC *assVc = [AssignmentShopVC new];
        assVc.back = ^(BOOL isYes){
            [_mTableView.header beginRefreshing];
        };
        assVc.info = listInfo;
        assVc.isEdit = YES;
        [self.superNav pushViewController:assVc animated:YES];
        return;
    }
    [MBProgressHUD showError:listInfo.transStatusName];
}

@end
