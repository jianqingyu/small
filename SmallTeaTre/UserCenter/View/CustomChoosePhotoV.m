//
//  CustomChoosePhotoV.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/11.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "CustomChoosePhotoV.h"
@interface CustomChoosePhotoV()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
@end
@implementation CustomChoosePhotoV

+ (id)creatCustomView{
    CustomChoosePhotoV *headView = [[CustomChoosePhotoV alloc]init];
    return headView;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CustomChoosePhotoV" owner:nil options:nil][0];
    }
    return self;
}

- (IBAction)btnClick:(UIButton *)sender {
    NSInteger idex = [self.btns indexOfObject:sender];
    if (self.picBack) {
        self.picBack(idex);
    }
}

@end
