//
//  UserCenterListCell.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/7.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserCenterListCell.h"
@interface UserCenterListCell()
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@end
@implementation UserCenterListCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    UserCenterListCell *customCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (customCell==nil) {
        customCell = [[UserCenterListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"UserCenterListCell" owner:nil options:nil][0];
        UIView *line = [UIView new];
        line.backgroundColor = DefaultColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0);
            make.top.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.height.mas_equalTo(@0.5);
        }];
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic{
    if (dic) {
        _dic = dic;
        self.logoImage.image = [UIImage imageNamed:_dic[@"image"]];
        self.nameLab.text = _dic[@"title"];
        self.logoImg.hidden = !self.isNewVer;
    }
}

@end
