//
//  CustomPickView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CustomBtmPickBack)(NSString *code);
@interface CustomPickView : UIView
@property (nonatomic,  copy)CustomBtmPickBack popBack;
+ (CustomPickView *)createAddPickView;
@end
