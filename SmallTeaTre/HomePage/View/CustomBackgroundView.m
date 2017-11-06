//
//  CustomBackgroundView.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/11.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "CustomBackgroundView.h"

@implementation CustomBackgroundView

+ (CustomBackgroundView *)createBackView{
    CustomBackgroundView *baView = [[CustomBackgroundView alloc]init];
    return baView;
//    static CustomBackgroundView *_baView = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _baView = [[CustomBackgroundView alloc]init];
//    });
//    return _baView;
}

- (id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
    }
    return self;
}

@end
