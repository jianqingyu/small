//
//  CustomChWareHouse.m
//  SmallTeaTre
//
//  Created by 余建清 on 2017/11/27.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "CustomChWareHouse.h"

@interface CustomChWareHouse()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
@end
@implementation CustomChWareHouse

+ (id)creatCustomView{
    CustomChWareHouse *headView = [[CustomChWareHouse alloc]init];
    return headView;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CustomChWareHouse" owner:nil options:nil][0];
    }
    return self;
}

- (IBAction)btnsClick:(UIButton *)sender {
    int idex = (int)[self.btns indexOfObject:sender];
    if (self.back) {
        self.back(idex);
    }
}

@end
