//
//  ChooseStoreInfoView.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "ChooseStoreInfoView.h"
@interface ChooseStoreInfoView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *list;
@end
@implementation ChooseStoreInfoView

+ (ChooseStoreInfoView *)createLoginView{
    static ChooseStoreInfoView *_InfoView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _InfoView = [[ChooseStoreInfoView alloc]init];
    });
    return _InfoView;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ChooseStoreInfoView" owner:nil options:nil][0];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.bounces = NO;
    }
    return self;
}

- (void)setAreaCode:(NSString *)areaCode{
    if (areaCode) {
        _areaCode = areaCode;
        [self loadHomeData];
    }
}

- (void)loadHomeData{
    NSString *url = [NSString stringWithFormat:@"%@api/shop/all/%@",baseNet,_areaCode];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            self.list = response.result;
            [self.tableView reloadData];
        }
    } requestURL:url params:params];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Id = @"customCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = CUSTOM_COLOR(40, 40, 40);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    NSDictionary *dic;
    if (indexPath.row<self.list.count) {
        dic = self.list[indexPath.row];
    }
    cell.textLabel.text = dic[@"shopName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic;
    if (indexPath.row<self.list.count) {
        dic = self.list[indexPath.row];
    }
    if (self.storeBack) {
        self.storeBack(dic,YES);
    }
}

- (IBAction)cancelClick:(id)sender {
    if (self.storeBack) {
        self.storeBack(@{},NO);
    }
}

@end
