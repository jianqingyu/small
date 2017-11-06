//
//  ShoppingListTableCell.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/5.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "ShoppingListTableCell.h"
@interface ShoppingListTableCell()
@property (weak, nonatomic) IBOutlet UIImageView *teaImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *styleLab;
@property (weak, nonatomic) IBOutlet UILabel *listLab;
@property (weak, nonatomic) IBOutlet UIButton *favBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@end
@implementation ShoppingListTableCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    ShoppingListTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[ShoppingListTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ShoppingListTableCell" owner:nil options:nil][0];
        [self.teaImg setLayerWithW:35 andColor:BordColor andBackW:0.00001];
        [self.styleLab setLayerWithW:2 andColor:BordColor andBackW:0.0001];
        [self.favBtn setLayerWithW:2 andColor:BordColor andBackW:0.5];
        [self.shareBtn setLayerWithW:2 andColor:BordColor andBackW:0.5];
    }
    return self;
}

- (void)setListInfo:(ShoppingListInfo *)listInfo{
    if (listInfo) {
        _listInfo = listInfo;
        self.favBtn.selected = _listInfo.isStored;
        if (self.isSel) {
            self.favBtn.selected = YES;
        }
        NSString *url = [NSString stringWithFormat:@"%@%@",baseNet,_listInfo.imgUrl];
        [self.teaImg sd_setImageWithURL:[NSURL URLWithString:url]
                                 placeholderImage:DefaultImage];
        self.titleLab.text = _listInfo.goodsName;
        NSString *strpo = [_listInfo.deportName isEqual:nil]?@"":_listInfo.deportName;
        self.listLab.text = [NSString stringWithFormat:@"%@ %@",strpo,_listInfo.typeName];
        NSString *style = @"";
        if (_listInfo.tagName.length>0) {
            style = [NSString stringWithFormat:@" %@    ",_listInfo.tagName];
        }
        self.styleLab.text = style;
        NSString *str = _listInfo.introduction;
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
        str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        self.infoLab.text = str;
    }
}

- (IBAction)favClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSString *str = sender.selected?@"like":@"unlike";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([[SaveUserInfoTool shared].id isKindOfClass:[NSString class]]) {
        params[@"userId"] = [SaveUserInfoTool shared].id;
    }
    params[@"goodsId"] = _listInfo.id;
    NSString *netUrl = [NSString stringWithFormat:@"%@api/user/goods/%@",baseNet,str];
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        NSString *str = [YQObjectBool boolForObject:response.msg]?response.msg:@"操作成功";
        [MBProgressHUD showSuccess:str];
        sender.enabled = YES;
    } requestURL:netUrl params:params];
    if (self.back&&self.isSel) {
        self.back(1,YES);
    }
}

- (IBAction)shareClick:(id)sender {
    if (self.back) {
        self.back(2,YES);
    }
}

@end
