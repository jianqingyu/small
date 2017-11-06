//
//  WareHouseVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/1.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "WareHouseVC.h"
#import "UserManagerMenuHrizontal.h"
#import "UserManagerScrollPageView.h"
#define MENUHEIHT 40
@interface WareHouseVC ()<UserManagerMenuHrizontalDelegate,UserManagerScrollPageViewDelegate>{
    NSArray*titleArray;
    UserManagerScrollPageView*mScrollPageView;
    UserManagerMenuHrizontal*menuHorizontalView;
}
@end

@implementation WareHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    titleArray = @[@{@"title":@"华南仓",@"deportId":@"0001"},
                   @{@"title":@"云南仓",@"deportId":@"0002"}],
    [self initCustomView];
}

#pragma mark UI初始化
- (void)initCustomView{
    //main view
    UIView *mainContentView = [[UIView alloc] init];
    menuHorizontalView = [[UserManagerMenuHrizontal alloc] initWithFrame:CGRectZero ButtonItems:titleArray];
    menuHorizontalView.delegate = self;
    //默认选中第一个button
    [menuHorizontalView clickButtonAtIndex:_index];
    [mainContentView addSubview:menuHorizontalView];
    
    //初始化滑动列表
    mScrollPageView = [[UserManagerScrollPageView alloc] initScrollPageView:CGRectZero navigation:self.navigationController];
    mScrollPageView.delegate = self;
    [mScrollPageView setContentOfTables:titleArray andId:@"UserManagerTableView"];
    [mainContentView addSubview:mScrollPageView];
    //初始化选择
    [mScrollPageView moveScrollowViewAthIndex:_index];
    [menuHorizontalView changeButtonStateAtIndex:_index];
    [self.view addSubview:mainContentView];
    [mainContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [menuHorizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainContentView).offset(0);
        make.left.equalTo(mainContentView).offset(0);
        make.right.equalTo(mainContentView).offset(0);
        make.height.mas_equalTo(40);
    }];
    [mScrollPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainContentView).offset(0);
        make.top.equalTo(menuHorizontalView.mas_bottom).with.offset(0);
        make.bottom.equalTo(mainContentView).offset(0);
        make.right.equalTo(mainContentView).offset(0);
    }];
}

#pragma mark - 其他辅助功能
- (void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)index{
    _index = (int)index;
    [mScrollPageView moveScrollowViewAthIndex:index];
}

#pragma mark ScrollPageViewDelegate
- (void)didScrollPageViewChangedPage:(NSInteger)page{
    _index = (int)page;
    [menuHorizontalView changeButtonStateAtIndex:page];
}

@end
