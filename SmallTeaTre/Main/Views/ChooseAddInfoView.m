//
//  ChooseAddInfoView.m
//  SmallTeaTre
//
//  Created by yjq on 17/10/10.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "ChooseAddInfoView.h"
#import "AddressListInfo.h"
@interface ChooseAddInfoView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *allTab;
@property (weak, nonatomic) IBOutlet UITableView *areaTab;
@property (nonatomic, copy) NSArray *allArr;
@property (nonatomic, copy) NSArray *areaArr;
@property (nonatomic, copy) NSString *allName;
@end
@implementation ChooseAddInfoView

+ (ChooseAddInfoView *)createAddPickView{
    static ChooseAddInfoView *_addView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _addView = [[ChooseAddInfoView alloc]init];
    });
    return _addView;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ChooseAddInfoView" owner:nil options:nil][0];
        self.areaTab.tableFooterView = [UIView new];
        self.areaTab.bounces = NO;
        self.allTab.tableFooterView = [UIView new];
        self.allTab.bounces = NO;
        [self loadAddressData];
    }
    return self;
}

- (void)loadAddressData{
    NSString *url = [NSString stringWithFormat:@"%@api/shop/area",baseNet];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            NSArray *arr = [AddressListInfo objectArrayWithKeyValuesArray:response.result];
            AddressListInfo *info = arr[0];
            self.allName = info.name;
            self.areaArr = info.children;
            self.allArr = arr;
            [self.allTab reloadData];
            [self.areaTab reloadData];
            NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.allTab selectRowAtIndexPath:first animated:YES
                                  scrollPosition:UITableViewScrollPositionTop];
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
    if (tableView==self.allTab) {
        return self.allArr.count;
    }else{
        return self.areaArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Id = @"textCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = CUSTOM_COLOR(40, 40, 40);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        if (tableView==self.allTab) {
            cell.backgroundColor = [UIColor whiteColor];
        }else{
            cell.backgroundColor = BackColor;
        }
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = BackColor;
    }
    if (tableView==self.allTab) {
        AddressListInfo *info = self.allArr[indexPath.row];
        cell.textLabel.text = info.name;
    }else{
        NSDictionary *dic = self.areaArr[indexPath.row];
        cell.textLabel.text = dic[@"name"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.allTab) {
        AddressListInfo *info = self.allArr[indexPath.row];
        self.areaArr = info.children;
        [self.areaTab reloadData];
        self.allName = info.name;
    }else{
        NSDictionary *dic = self.areaArr[indexPath.row];
        NSMutableDictionary *mutD = dic.mutableCopy;
        mutD[@"name"] = [NSString stringWithFormat:@"%@%@",self.allName,dic[@"name"]];
        if (self.popBack) {
            self.popBack(mutD,YES);
        }
    }
}

@end
