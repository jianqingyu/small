//
//  CustomProtrlView.h
//  SmallTeaTre
//
//  Created by 余建清 on 2017/11/28.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CProtrlBack)(BOOL isYes);
@interface CustomProtrlView : UIView
+ (id)creatCustomView;
@property (nonatomic, copy)NSString *str;
@property (nonatomic, copy)NSString *titleStr;
@property (nonatomic, copy)CProtrlBack back;
@end
