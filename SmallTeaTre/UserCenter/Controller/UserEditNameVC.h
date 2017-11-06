//
//  UserEditNameVC.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/7.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^EditNickBack)(BOOL isSel);
@interface UserEditNameVC : BaseViewController
@property (nonatomic, copy)EditNickBack back;
@end
