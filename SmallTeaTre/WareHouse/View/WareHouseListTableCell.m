//
//  WareHouseListTableCell.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/5.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "WareHouseListTableCell.h"
#import "OrderNumTool.h"
@interface WareHouseListTableCell()
@property (weak, nonatomic) IBOutlet UIImageView *teaImg;
@property (weak, nonatomic) IBOutlet UILabel *wareTLab;
@property (weak, nonatomic) IBOutlet UILabel *wareSta;
@property (weak, nonatomic) IBOutlet UILabel *sPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *allPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIButton *styBtn;
@end
@implementation WareHouseListTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    WareHouseListTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[WareHouseListTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"WareHouseListTableCell" owner:nil options:nil][0];
        [self.teaImg setLayerWithW:35 andColor:BordColor andBackW:0.0001];
    }
    return self;
}

- (void)setListInfo:(WareListInfo *)listInfo{
    if (listInfo) {
        _listInfo = listInfo;
        NSString *url = [NSString stringWithFormat:@"%@%@",baseNet,_listInfo.imgUrl];
        [self.teaImg sd_setImageWithURL:[NSURL URLWithString:url]
                       placeholderImage:DefaultImage];
        self.wareTLab.text = _listInfo.goodsName;
        self.wareSta.text = [NSString stringWithFormat:@"%@ %@",_listInfo.deportName,_listInfo.typeName];
        [self.styBtn setTitle:_listInfo.transStatusName forState:UIControlStateNormal];
        self.sPriceLab.text = [NSString stringWithFormat:@"茶叶单价:%0.2f/%@",_listInfo.price,_listInfo.unitName];
        self.numLab.text = [NSString stringWithFormat:@"成交总量:%@%@",_listInfo.quantity,_listInfo.unitName];
        self.allPriceLab.text = [NSString stringWithFormat:@"成交总金额:%0.2f元",_listInfo.total];
        NSString *string = [OrderNumTool strWithTime:_listInfo.createTime];
        self.dateLab.text = [NSString stringWithFormat:@"购买日期:%@",string];
    }
}

- (void)setOrderInfo:(UserOrderListInfo *)orderInfo{
    if (orderInfo) {
        _orderInfo = orderInfo;
        NSString *url = [NSString stringWithFormat:@"%@%@",baseNet,_orderInfo.imgUrl];
        [self.teaImg sd_setImageWithURL:[NSURL URLWithString:url]
                       placeholderImage:DefaultImage];
        self.wareTLab.text = _orderInfo.goodsName;
//        self.wareSta.text = [NSString stringWithFormat:@"%@ %@",_orderInfo.deportName,_orderInfo.typeName];
        self.wareSta.text = _orderInfo.typeName;
        [self.styBtn setTitle:_orderInfo.orderTypeName forState:UIControlStateNormal];
        self.sPriceLab.text = [NSString stringWithFormat:@"茶叶单价:%0.2f/%@",_orderInfo.price,_orderInfo.unitName];
        self.numLab.text = [NSString stringWithFormat:@"成交总量:%@%@",_orderInfo.quantity,_orderInfo.unitName];
        self.allPriceLab.text = [NSString stringWithFormat:@"成交总金额:%0.2f元",_orderInfo.total];
        NSString *string = [OrderNumTool strWithTime:_orderInfo.createTime];
        self.dateLab.text = [NSString stringWithFormat:@"购买日期:%@",string];
    }
}

- (IBAction)staueClick:(id)sender {
    if (self.reBack) {
        self.reBack(YES);
    }
}

@end
