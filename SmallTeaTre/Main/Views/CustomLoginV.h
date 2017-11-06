//
//  CustomLoginV.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/1.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CusLoginBack)(int isSel);
@interface CustomLoginV : UIView
+ (CustomLoginV *)createLoginView;
@property (weak, nonatomic) IBOutlet UITextField *phoneFie;
@property (weak, nonatomic) IBOutlet UITextField *passFie;
@property (nonatomic, copy)CusLoginBack btnBack;
@end
