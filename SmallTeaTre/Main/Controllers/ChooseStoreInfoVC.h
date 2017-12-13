//
//  ChooseStoreInfoVC.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ChooseSInfoBack)(BOOL isYes);
@interface ChooseStoreInfoVC : BaseViewController
@property (nonatomic,strong)NSMutableDictionary *mutDic;
@property (nonatomic,  copy)ChooseSInfoBack back;
@end
