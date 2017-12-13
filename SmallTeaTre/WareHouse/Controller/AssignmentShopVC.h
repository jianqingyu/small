//
//  AssignmentShopVC.h
//  SmallTeaTre
//
//  Created by 余建清 on 2017/11/24.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "BaseViewController.h"
#import "WareListInfo.h"
typedef void (^ZRNumBack)(BOOL isSel);
@interface AssignmentShopVC : BaseViewController
@property (nonatomic,strong)WareListInfo *info;
@property (nonatomic,assign)BOOL isSel;
@property (nonatomic,assign)BOOL isEdit;
@property (nonatomic,  copy)ZRNumBack back;
@end
