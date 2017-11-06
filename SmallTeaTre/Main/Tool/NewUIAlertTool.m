//
//  NewUIAlertTool.m
//  MillenniumStarERP
//
//  Created by yjq on 17/2/16.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NewUIAlertTool.h"
#import "ShowLoginViewTool.h"
@implementation NewUIAlertTool
+ (void)creatActionSheetPhoto:(void (^)(void))PhotoBlock
                    andCamera:(void (^)(void))CameraBlock
                      andView:(UIView *)view{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择头像"
        message:@"从相册选取照片或拍照发送" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * _Nonnull action){
         PhotoBlock();
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * _Nonnull action) {
         CameraBlock();
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction * _Nonnull action){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    UIViewController *con = [ShowLoginViewTool getCurrentVC];
    if(IsPhone){
        [con presentViewController:alert animated:YES completion:nil];
    }else{
        UIPopoverPresentationController *popPresenter = alert.popoverPresentationController;
        popPresenter.sourceView = view;
        popPresenter.sourceRect = view.bounds;
        [con presentViewController:alert animated:YES completion:nil];
    }
}

+ (void)show:(NSDictionary *)dic back:(void (^)(void))okBlock{
    NSString *mes = [YQObjectBool boolForObject:dic[@"message"]]?dic[@"message"]:@"";
    // 初始化 添加 提示内容
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:dic[@"title"]
                    message:mes preferredStyle:UIAlertControllerStyleAlert];
    // 添加 AlertAction 事件回调（三种类型：默认，取消，警告）
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * _Nonnull action) {
            if (okBlock) {
                okBlock();
            }
        // 移除
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIViewController *con = [ShowLoginViewTool getCurrentVC];
    // cancel类自动变成最后一个，警告类推荐放上面
    [alertController addAction:okAction];
    // 出现
    [con presentViewController:alertController animated:YES completion:nil];
}

@end
