//
//  ShopShareCustomView.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/7.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "ShopShareCustomView.h"
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import "ShowLoginViewTool.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
@interface ShopShareCustomView()<WXApiDelegate>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
@end
@implementation ShopShareCustomView

+ (id)creatCustomView{
    ShopShareCustomView *headView = [[ShopShareCustomView alloc]init];
    return headView;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ShopShareCustomView" owner:nil options:nil][0];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(touchTab:) name:NotificationTouch object:nil];
    }
    return self;
}
//点击tab的通知
- (void)touchTab:(NSNotification *)notification{
    if (self.back) {
        self.back(YES);
    }
}

- (IBAction)cancelClick:(id)sender {
    if (self.back) {
        self.back(YES);
    }
}

- (IBAction)shareClick:(UIButton *)sender {
    NSInteger idex = [self.btns indexOfObject:sender];
    [self setShareSdkAtIndex:idex];
}

- (void)setShareSdkAtIndex:(NSInteger)idex{
    if (idex==0||idex==1) {
        if (![WXApi isWXAppInstalled]) {
            //未安装微信调起web登录
            [MBProgressHUD showError:@"未安装微信"];
            return;
        }
    }
    [SVProgressHUD show];
    //创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    id image;
    NSString *url;
    if (self.isApp) {
        image = self.shareDic[@"image"];
        url = self.shareDic[@"url"];
    }else{
        NSString *str = [NSString stringWithFormat:@"%@%@",baseNet,self.shareDic[@"image"]];
        image = [NSURL URLWithString:str];
        url = [NSString stringWithFormat:@"%@%@",baseNet,self.shareDic[@"url"]];
    }
    NSString *des = self.shareDic[@"des"];
    SSDKPlatformType type;
    switch (idex) {
        case 0:
            type = SSDKPlatformTypeWechat;
            break;
        case 1:
            type = SSDKPlatformSubTypeWechatTimeline;
            break;
        case 2:
            type = SSDKPlatformTypeQQ;
            break;
        case 3:
            type = SSDKPlatformTypeSinaWeibo;
            des  = [NSString stringWithFormat:@"%@ %@",self.shareDic[@"des"],url];
            break;
        default:
            break;
    }
    [shareParams SSDKSetupShareParamsByText:des
                                     images:image
                                        url:[NSURL URLWithString:url]
                                      title:self.shareDic[@"title"]
                                       type:SSDKContentTypeAuto];
    //进行分享 //传入分享的平台类型
    [ShareSDK share:type parameters:shareParams onStateChanged:nil];
    [SVProgressHUD dismiss];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
