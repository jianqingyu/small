//
//  NewUIAlertTool.h
//  MillenniumStarERP
//
//  Created by yjq on 17/2/16.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewUIAlertTool : NSObject
+ (void)creatActionSheetPhoto:(void (^)(void))PhotoBlock
                    andCamera:(void (^)(void))CameraBlock
                      andView:(UIView *)view;
+ (void)show:(NSDictionary *)dic back:(void (^)(void))okBlock;
@end
