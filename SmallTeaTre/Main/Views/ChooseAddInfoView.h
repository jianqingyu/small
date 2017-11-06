//
//  ChooseAddInfoView.h
//  SmallTeaTre
//
//  Created by yjq on 17/10/10.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AddPickBack)(id mess,BOOL isYes);
@interface ChooseAddInfoView : UIView
@property (nonatomic,  copy)AddPickBack popBack;
+ (ChooseAddInfoView *)createAddPickView;
@end
