//
//  CustomChoosePhotoV.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/11.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ChoosePicBack)(NSInteger staue);
@interface CustomChoosePhotoV : UIView
+ (id)creatCustomView;
@property (nonatomic, copy)ChoosePicBack picBack;
@end
