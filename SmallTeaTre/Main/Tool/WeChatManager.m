//
//  WeChatManager.m
//  SmallTeaTre
//
//  Created by 余建清 on 2017/12/19.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "WeChatManager.h"
#import "WXApi.h"

@implementation WeChatManager
+ (instancetype)sharedManager{
    static WeChatManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WeChatManager alloc]init];
    });
    return instance;
}

- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *res = (SendAuthResp *)resp;
        [self loginSuccessByCode:res.code];
    }
}

+ (void)sendAuthRequest{
    SendAuthReq* req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"233";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

- (void)loginSuccessByCode:(NSString *)code{
    NSString *urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"wxce488c9ce08c20e3",@"203e4b15ebfc1a03475c2ad0809667ee",code];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"]){
                    //获取token错误
                }else{
                    if (self.back) {
                        self.back(dict);
                    }
                }
            }
        });
    });
}

@end
