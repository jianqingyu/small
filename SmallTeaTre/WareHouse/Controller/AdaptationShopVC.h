//
//  AdaptationShopVC.h
//  SmallTeaTre
//
//  Created by 余建清 on 2017/11/24.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "BaseViewController.h"
#import "WareListInfo.h"
typedef void (^XCNumBack)(BOOL isSel);
@interface AdaptationShopVC : BaseViewController
@property (nonatomic,strong)WareListInfo *info;
@property (nonatomic,  copy)XCNumBack back;
@end
