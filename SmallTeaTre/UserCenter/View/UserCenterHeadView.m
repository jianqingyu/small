//
//  UserCenterHeadView.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/1.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserCenterHeadView.h"
@interface UserCenterHeadView()
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@end
@implementation UserCenterHeadView

+ (UserCenterHeadView *)createHeadView{
    static UserCenterHeadView *_userHV = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userHV = [[UserCenterHeadView alloc]init];
    });
    return _userHV;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"UserCenterHeadView" owner:nil options:nil][0];
        [self.headView setLayerWithW:45 andColor:[UIColor whiteColor] andBackW:2];
    }
    return self;
}

- (void)setUserInfo{
    self.nickname.text = [SaveUserInfoTool shared].nickName;
    NSString *url = [NSString stringWithFormat:@"%@%@",baseNet,[SaveUserInfoTool shared].imgUrl];
    [self.headView sd_setImageWithURL:[NSURL URLWithString:url]
                   placeholderImage:DefaultHead];
}

@end
