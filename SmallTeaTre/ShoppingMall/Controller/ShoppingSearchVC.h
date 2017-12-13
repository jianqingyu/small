//
//  ShoppingSearchVC.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/8.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ShoppingSBack)(id model);
@interface ShoppingSearchVC : BaseViewController
@property (nonatomic,assign)BOOL isCh;
@property (nonatomic,  copy)ShoppingSBack back;
@end
