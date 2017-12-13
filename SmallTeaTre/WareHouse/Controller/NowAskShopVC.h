//
//  NowAskShopVC.h
//  SmallTeaTre
//
//  Created by 余建清 on 2017/11/24.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "BaseViewController.h"
#import "WareListInfo.h"
typedef void (^XTNumBack)(BOOL isSel);
@interface NowAskShopVC : BaseViewController
@property (nonatomic,strong)WareListInfo *info;
@property (nonatomic,assign)BOOL isSel;
@property (nonatomic,  copy)XTNumBack back;
@end
