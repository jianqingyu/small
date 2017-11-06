//
//  WareChooseNumVc.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/11.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "BaseViewController.h"
#import "WareListInfo.h"
typedef void (^ZYNumBack)(BOOL isSel);
@interface WareChooseNumVc : BaseViewController
@property (nonatomic,strong)WareListInfo *info;
@property (nonatomic,assign)BOOL isSel;
@property (nonatomic,  copy)ZYNumBack back;
@end
