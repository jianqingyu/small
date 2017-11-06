//
//  CustomPickView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "CustomPickView.h"
#import "AddressListInfo.h"
@interface CustomPickView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, weak)UILabel *titleLab;
@property (nonatomic, weak)UIPickerView *pickView;
@property (nonatomic, copy)NSArray *allArr;
@property (nonatomic, copy)NSArray *areaArr;
@end
@implementation CustomPickView

+ (CustomPickView *)createAddPickView{
    static CustomPickView *_addView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _addView = [[CustomPickView alloc]init];
    });
    return _addView;
}

- (id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
        UIView *backV = [[UIView alloc]init];
        backV.backgroundColor = [UIColor whiteColor];
        [self addSubview:backV];
        [backV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0);
            make.bottom.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.height.mas_equalTo(@256);
        }];
        
        UILabel *title = [[UILabel alloc]init];
        title.font = [UIFont systemFontOfSize:18];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"请选择地区";
        [backV addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backV).offset(0);
            make.centerX.mas_equalTo(backV.mas_centerX);
            make.height.mas_equalTo(@44);
            make.width.mas_equalTo(@(SDevWidth*0.6));
        }];
        self.titleLab = title;
        [self setPickerView:backV];
        [self loadAddressData];
    }
    return self;
}

- (void)setPickerView:(UIView *)backV{
    UIPickerView *pickView = [[UIPickerView alloc]init];
    pickView.backgroundColor = DefaultColor;
    pickView.delegate = self;
    pickView.dataSource = self;
    [backV addSubview:pickView];
    [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backV).offset(0);
        make.bottom.equalTo(backV).offset(0);
        make.right.equalTo(backV).offset(0);
        make.height.mas_equalTo(@216);
    }];
    self.pickView = pickView;
}

- (void)loadAddressData{
    NSString *url = [NSString stringWithFormat:@"%@api/shop/area",baseNet];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            self.allArr = [AddressListInfo objectArrayWithKeyValuesArray:response.result];
            [self.pickView reloadComponent:0];
        }
    } requestURL:url params:params];
}

//选中
//- (void)setSelTitle:(NSString *)selTitle{
//    if (selTitle) {
//        _selTitle = selTitle;
//        int idex = 0;
//        for (int i=0; i<_typeList.count; i++) {
//            NSDictionary *info = _typeList[i];
//            if ([_selTitle isEqualToString:info[@"title"]]) {
//                idex = i;
//            }
//        }
//        [self.pickView selectRow:idex inComponent:0 animated:YES];
//    }
//}

// 返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
// 返回每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return self.allArr.count;
    }else{
        return self.areaArr.count;
    }
}
// 返回每行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0) {
        AddressListInfo *info = self.allArr[row];
        return info.name;
    }else{
        NSDictionary *dic = self.areaArr[row];
        return dic[@"name"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        AddressListInfo *info = self.allArr[row];
        self.areaArr = info.children;
        [self.pickView reloadComponent:1];
    }else{
        NSDictionary *dic = self.areaArr[row];
        if (self.popBack) {
            self.popBack(dic[@"code"]);
        }
    }
}

@end
