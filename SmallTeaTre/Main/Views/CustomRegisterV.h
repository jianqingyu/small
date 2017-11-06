//
//  CustomRegisterV.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/1.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CusRegBack)(int staue);
@interface CustomRegisterV : UIView
+ (CustomRegisterV *)createRegisterView;
@property (nonatomic, copy)CusRegBack back;
@end
