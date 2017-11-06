//
//  WareHouseDetailVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/5.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "WareHouseDetailVC.h"
#import "NewUIAlertTool.h"
#import "WareChooseNumVc.h"
#import "WareHouseListTableCell.h"
@interface WareHouseDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,  copy)NSArray *dicArr;
@end

@implementation WareHouseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dicArr = @[@{@"title":@"请与客服联系仓库线下提货"},
                    @{@"title":@"请与客服联系仓库线下续存"},
                    @{@"title":@"购买时间未满三年，禁止操作"},
                    @{@"title":@"已满三年，请与客服联系买家"}];
    [self setupTableView];
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = DefaultColor;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-44);
    }];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arr.count;
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
    WareListInfo *listInfo;
    if (indexPath.section<_arr.count) {
        listInfo = _arr[indexPath.section];
    }
    cell.listInfo = listInfo;
    return cell;
}

- (IBAction)bottomClick:(UIButton *)sender {
    WareListInfo *listInfo = _arr[0];
    NSInteger idex = [self.btns indexOfObject:sender];
    if (idex==3) {
        WareChooseNumVc *numVc = [WareChooseNumVc new];
        numVc.back = ^(BOOL isYes){
            if (self.back) {
                self.back(YES);
            }
        };
        numVc.info = listInfo;
        [self.navigationController pushViewController:numVc animated:YES];
        return;
    }
    NSDictionary *dic = self.dicArr[idex];
    if (idex==2) {
        if ([self compareNowAndOldTime:listInfo]) {
            dic = self.dicArr[3];
        }
    }
    [NewUIAlertTool show:dic back:nil];
}

- (BOOL)compareNowAndOldTime:(WareListInfo *)listInfo{
    NSTimeInterval second = listInfo.createTime.longLongValue / 1000.0;
    // 时间戳 -> NSDate *
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitYear;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:now toDate:date options:0];
    if ([comps year]>=3) {
        return YES;
    }else{
        return NO;
    }
}

@end
