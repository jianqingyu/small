//
//  WareHouseDetailVC.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/5.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^HouseBack)(BOOL isSel);
@interface WareHouseDetailVC : BaseViewController
@property (nonatomic, copy)NSArray *arr;
@property (nonatomic, copy)HouseBack back;
@end
