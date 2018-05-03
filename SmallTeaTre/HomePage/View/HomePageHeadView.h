//
//  HomePageHeadView.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/6.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageHeadView : UIView
+ (HomePageHeadView *)createHeadView;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (nonatomic, copy)NSArray *infoArr;
@property (nonatomic, copy)NSDictionary *messDic;
@end
