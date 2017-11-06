//
//  ShowHidenTabBar.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/11.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "ShowHidenTabBar.h"

@implementation ShowHidenTabBar
+ (void)hideTabBar:(UIViewController *)vc{
    if (vc.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[vc.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ){
        contentView = [vc.tabBarController.view.subviews objectAtIndex:1];
    }else{
        contentView = [vc.tabBarController.view.subviews objectAtIndex:0];
        contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + vc.tabBarController.tabBar.frame.size.height);
    }
    vc.tabBarController.tabBar.hidden = YES;
}

#pragma mark -显示TabBar
+ (void)showTabBar:(UIViewController *)vc {
    if (vc.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    UIView *contentView;
    if ([[vc.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]){
        contentView = [vc.tabBarController.view.subviews objectAtIndex:1];
    }else{
        contentView = [vc.tabBarController.view.subviews objectAtIndex:0];
        contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - vc.tabBarController.tabBar.frame.size.height);
    }
    vc.tabBarController.tabBar.hidden = NO;
}
@end
