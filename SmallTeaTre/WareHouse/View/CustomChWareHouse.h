//
//  CustomChWareHouse.h
//  SmallTeaTre
//
//  Created by 余建清 on 2017/11/27.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^chooseHou)(int idex);
@interface CustomChWareHouse : UIView
@property (nonatomic,copy)chooseHou back;
+ (id)creatCustomView;
@end
