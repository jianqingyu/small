//
//  AppDelegate.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/1.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "CommonUtils.h"
#import "Reachability.h"
#import "ShowLoginViewTool.h"
#import "UIWindow+Extension.h"

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <LocalAuthentication/LocalAuthentication.h>
@interface AppDelegate (){
    Reachability *hostReach;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window switchRootViewController];
    [self.window makeKeyAndVisible];
    
    // 监听网络状态改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification object: nil];
    hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReach startNotifier];
    
//    UIImage *backImg = [CommonUtils createImageWithColor:BarColor];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"icon_navBack"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSDictionary *attbutes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance]setTitleTextAttributes:attbutes];
    
    [self setShareSDK];
    return YES;
}

- (void)setShareSDK{
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ)]
                             onImport:^(SSDKPlatformType platformType) {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType)
        {
            case SSDKPlatformTypeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                [appInfo SSDKSetupSinaWeiboByAppKey:@"2341659063"
                                          appSecret:@"31df936deb0b727abff9aace6eaaf07c"
                                        redirectUri:@"http://www.sharesdk.cn"
                                           authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wxce488c9ce08c20e3"
                                      appSecret:@"203e4b15ebfc1a03475c2ad0809667ee"];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:@"1106339351"//QQ41F16617
                                     appKey:@"dXpXeg8jKculB0SS"
                                   authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }

    }];
//    [ShareSDK registerApp:@"20f981628abd0"
//          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
//                            @(SSDKPlatformTypeWechat),
//                            @(SSDKPlatformTypeQQ)]
//                 onImport:^(SSDKPlatformType platformType)
//     {
//         switch (platformType)
//         {
//             case SSDKPlatformTypeWechat:
//                 [ShareSDKConnector connectWeChat:[WXApi class]];
//                 break;
//             case SSDKPlatformTypeQQ:
//                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                 break;
//             case SSDKPlatformTypeSinaWeibo:
//                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                 break;
//             default:
//                 break;
//         }
//     }
//          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
//     {
//         switch (platformType)
//         {
//             case SSDKPlatformTypeSinaWeibo:
//                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2341659063"
//                                           appSecret:@"31df936deb0b727abff9aace6eaaf07c"
//                                         redirectUri:@"http://www.sharesdk.cn"
//                                            authType:SSDKAuthTypeBoth];
//                 break;
//             case SSDKPlatformTypeWechat:
//                 [appInfo SSDKSetupWeChatByAppId:@"wxce488c9ce08c20e3"
//                                       appSecret:@"203e4b15ebfc1a03475c2ad0809667ee"];
//                 break;
//             case SSDKPlatformTypeQQ:
//                 [appInfo SSDKSetupQQByAppId:@"1106339351"//QQ41F16617
//                                      appKey:@"dXpXeg8jKculB0SS"
//                                    authType:SSDKAuthTypeBoth];
//                 break;
//             default:
//                 break;
//         }
//     }];
}

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NetworkStatus status = [curReach currentReachabilityStatus];
    BOOL isYes = !(status == NotReachable);
    if (self.loadBack) {
        self.loadBack(isYes);
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
