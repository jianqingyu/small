//
//  ChooseStoreInfoTool.m
//  SmallTeaTre
//
//  Created by 余建清 on 2017/12/5.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "ChooseStoreInfoTool.h"
#import "ChooseStoreInfoVC.h"
#import "ShowLoginViewTool.h"
#import "MainTabViewController.h"
#import "TemporaryDepVC.h"
#import "UserStoreInfoVC.h"
@implementation ChooseStoreInfoTool
+ (void)chooseInfo:(int)type{
    NSString *shopId = [SaveUserInfoTool shared].shopId;
    if (![YQObjectBool boolForObject:shopId]) {
        [ChooseStoreInfoTool pop:type];
    }else{
        [self typePushToClass:type and:NO];
    }
}

+ (void)pop:(int)type{
    NSDictionary *dic = @{@"title":@"绑定门店",@"message":@"请选择绑定地区及门店",
                          @"ok":@"绑定",@"cancel":@"稍后"};
    [NewUIAlertTool show:dic back:^{
        ChooseStoreInfoVC *storeVc = [ChooseStoreInfoVC new];
        storeVc.back = ^(BOOL isYes) {
            [self typePushToClass:type and:YES];
        };
        storeVc.title = @"选择门店";
        UIViewController *vc = [ShowLoginViewTool getCurrentVC];
        [vc.navigationController pushViewController:storeVc animated:YES];
    }];
}

+ (void)typePushToClass:(int)type and:(BOOL)isYes{
    UIViewController *vc = [ShowLoginViewTool getCurrentVC];
    switch (type) {
        case 1:{//切换Tab
            if (isYes) {
                NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: vc.navigationController.viewControllers];
                [navigationArray removeLastObject];
                vc.navigationController.viewControllers = navigationArray;
            }
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            MainTabViewController *tab = (MainTabViewController *)delegate.window.rootViewController;
            tab.selectedIndex = 2;
        }
            break;
        case 2:{//跳转到添加
            TemporaryDepVC *depVc = [TemporaryDepVC new];
            [vc.navigationController pushViewController:depVc animated:YES];
            if (isYes) {
                NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: vc.navigationController.viewControllers];
                [navigationArray removeObjectAtIndex:navigationArray.count-2];
                vc.navigationController.viewControllers = navigationArray;
            }
        }
            break;
        case 3:{//跳转到门店
            UserStoreInfoVC *userVc = [UserStoreInfoVC new];
            [vc.navigationController pushViewController:userVc animated:YES];
            if (isYes) {
                NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: vc.navigationController.viewControllers];
                [navigationArray removeObjectAtIndex:navigationArray.count-2];
                vc.navigationController.viewControllers = navigationArray;
            }
        }
            break;
        case 4:{//停留在主页
            [vc.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 5:{//切换tab 并且跳转到添加
            TemporaryDepVC *depVc = [TemporaryDepVC new];
            depVc.isAdd = YES;
            [vc.navigationController pushViewController:depVc animated:YES];
            if (isYes) {
                NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: vc.navigationController.viewControllers];
                [navigationArray removeObjectAtIndex:navigationArray.count-2];
                vc.navigationController.viewControllers = navigationArray;
            }
        }
            break;
        default:
            break;
    }
}

@end
