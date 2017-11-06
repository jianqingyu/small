//
//  UserHelpViewController.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserHelpViewController.h"
#import "MainProtocolVC.h"
#import "UserHelpProInfo.h"
@interface UserHelpViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,  copy)NSArray *list;
@end

@implementation UserHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self loadHomeData];
}

- (void)loadHomeData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *netUrl = [NSString stringWithFormat:@"%@api/help/types",baseNet];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            self.list = [UserHelpProInfo objectArrayWithKeyValuesArray:response.result];
            [self.tableView reloadData];
        }else{
            NSString *str = response.msg?response.msg:@"查询失败";
            [MBProgressHUD showError:str];
        }
    } requestURL:netUrl params:params];
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *Id = @"centerCell";
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        customCell.textLabel.font = [UIFont systemFontOfSize:14];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UserHelpProInfo *info = self.list[indexPath.row];
    customCell.textLabel.text = info.typeName;
    return customCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserHelpProInfo *info = self.list[indexPath.row];
    MainProtocolVC *pro = [MainProtocolVC new];
    pro.title = info.typeName;
    pro.typeId = info.typeId;
    [self.navigationController pushViewController:pro animated:YES];
}

@end
