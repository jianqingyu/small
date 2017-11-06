//
//  WareConfirmRedeemVc.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/11.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "BaseViewController.h"
#import "WareListInfo.h"
typedef void (^WareFirBack)(BOOL isSel);
@interface WareConfirmRedeemVc : BaseViewController
@property (nonatomic,strong)WareListInfo *info;
@property (nonatomic,  copy)WareFirBack back;
@end
