//
//  UserCenterHeadView.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/1.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserCenterHeadView.h"
#import "HomeMessageListVC.h"
#import "ShowLoginViewTool.h"
@interface UserCenterHeadView()
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UIButton *messBtn;
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

- (void)changeBtnNew:(BOOL)isNew{
    NSString *img = isNew?@"icon_noti_s":@"icon_noti";
    [self.messBtn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
}

- (void)setUserInfo{
    self.nickname.text = [SaveUserInfoTool shared].nickName;
    NSString *url = [SaveUserInfoTool shared].imgUrl;
    if ([YQObjectBool boolForObject:url]) {
        if (![url containsString:@"http"]) {
            url = [NSString stringWithFormat:@"%@%@",baseNet,url];
        }
        [self.headView sd_setImageWithURL:[NSURL URLWithString:url]
                         placeholderImage:DefaultHead];
    }
}

- (IBAction)notiClick:(id)sender {
    HomeMessageListVC *list = [HomeMessageListVC new];
    list.title = @"消息中心";
    list.isMes = YES;
    UIViewController *vc = [ShowLoginViewTool getCurrentVC];
    [vc.navigationController pushViewController:list animated:YES];
}

@end
