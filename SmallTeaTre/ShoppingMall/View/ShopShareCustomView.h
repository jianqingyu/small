//
//  ShopShareCustomView.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/7.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ShareCancelBack)(BOOL isSel);
@interface ShopShareCustomView : UIView
+ (id)creatCustomView;
@property(nonatomic,copy)NSDictionary *shareDic;
@property (nonatomic,assign)BOOL isApp;
@property(nonatomic,   copy)ShareCancelBack back;
@end
