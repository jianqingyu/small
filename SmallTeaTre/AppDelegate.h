//
//  AppDelegate.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/1.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^NetBack)(BOOL isSel);
typedef void (^WXPayBlock)(BOOL isYes);
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy)NetBack loadBack;
@property (nonatomic, copy)WXPayBlock weChatPayBlock;
@end

