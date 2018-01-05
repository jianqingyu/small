//
//  WeChatManager.h
//  SmallTeaTre
//
//  Created by 余建清 on 2017/12/19.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^WeChatManBack)(id model);
@interface WeChatManager : NSObject
+ (instancetype)sharedManager;
+ (void)sendAuthRequest;
@property (nonatomic, copy)WeChatManBack back;
@end
