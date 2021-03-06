//
//  MainNavViewController.m
//  MillenniumStar08.07
//
//  Created by yjq on 15/8/7.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import "MainNavViewController.h"
#import "MainTabViewController.h"

@interface MainNavViewController ()<UIGestureRecognizerDelegate>

@end

@implementation MainNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
}
//实现代理方法:return YES :手势有效, NO :手势无效
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //当导航控制器的子控制器个数 大于1 手势才有效
    return self.childViewControllers.count > 1;
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.extendedLayoutIncludesOpaqueBars = NO;
        viewController.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
        //设置左边的返回按钮
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back{
    [self popViewControllerAnimated:YES];
}

@end
