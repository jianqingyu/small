//
//  UserMyCollection.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserMyCollection.h"
#import "ShoppingListInfo.h"
#import "HomeShoppingDetailVc.h"
#import "CustomBackgroundView.h"
#import "ShopShareCustomView.h"
#import "ShoppingListTableCell.h"
@interface UserMyCollection ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (assign,nonatomic) CGFloat height;
@property (weak,  nonatomic) CustomBackgroundView *baView;
@property (weak,  nonatomic) ShopShareCustomView *shareView;
@end

@implementation UserMyCollection

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultColor;
    self.dataArray = @[].mutableCopy;
    [self setupTableView];
    [self loadHomeData];self.height = 190;
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

- (void)loadHomeData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([[SaveUserInfoTool shared].id isKindOfClass:[NSString class]]) {
        params[@"userId"] = [SaveUserInfoTool shared].id;
    }
    NSString *netUrl = [NSString stringWithFormat:@"%@api/user/goods/likes",baseNet];
    [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            NSArray *arr = [ShoppingListInfo objectArrayWithKeyValuesArray:response.result];
            [self.dataArray addObjectsFromArray:arr];
            [self.tableView reloadData];
        }else{
            NSString *str = response.msg?response.msg:@"查询失败";
            [MBProgressHUD showError:str];
        }
    } requestURL:netUrl params:params];
}

- (void)setupTableView{
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
    self.tableView.tableFooterView = [UIView new];
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
    teaCell.isSel = YES;
    ShoppingListInfo *listInfo;
    if (indexPath.section<_dataArray.count) {
        listInfo = _dataArray[indexPath.section];
    }
    teaCell.listInfo = listInfo;
    teaCell.back = ^(int staue,BOOL isYes){
        if (staue==1) {
            [_dataArray removeObjectAtIndex:indexPath.section];
            [self.tableView reloadData];
        }else{
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
    ShoppingListInfo *listInfo;
    if (indexPath.section<_dataArray.count) {
        listInfo = _dataArray[indexPath.section];
    }
    detail.title = listInfo.goodsName;
    detail.url = listInfo.informationUrl;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
