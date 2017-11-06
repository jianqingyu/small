//
//  HomePageHeadView.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/6.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "HomePageHeadView.h"
#import "HYBLoopScrollView.h"
#import "HomeMessageListVC.h"
#import "ShowLoginViewTool.h"
#import "HomeBannerDetailVC.h"
@interface HomePageHeadView()
@property (weak, nonatomic) IBOutlet UIButton *conBtn;
@property (weak, nonatomic) IBOutlet UILabel *messLab;
@end
@implementation HomePageHeadView

+ (HomePageHeadView *)createHeadView{
    HomePageHeadView *headView = [[HomePageHeadView alloc]init];
    return headView;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HomePageHeadView" owner:nil options:nil][0];
    }
    return self;
}

- (void)setLoopScrollView:(NSArray *)arr{
    if (arr.count==0) {
        return;
    }
    NSMutableArray *pic  = @[].mutableCopy;
    for (NSDictionary*dict in arr) {
        NSString *str = [self UsingEncoding:dict[@"imgUrl"]];
        if (str.length>0) {
            [pic addObject:str];
        }
    }
    if (pic.count==0) {
        [pic addObject:@"pic"];
    }
    HYBLoopScrollView *loop = [HYBLoopScrollView loopScrollViewWithFrame:
                               CGRectMake(0, 0, SDevWidth, SDevWidth*0.53) imageUrls:pic.copy];
    loop.timeInterval = 3.0;
    loop.didSelectItemBlock = ^(NSInteger atIndex,HYBLoadImageView  *sender){
        [self openBanner:arr[atIndex]];
    };
    loop.alignment = kPageControlAlignRight;
    [self addSubview:loop];
}

- (void)setInfoArr:(NSArray *)infoArr{
    if (infoArr) {
        _infoArr = infoArr;
        [self setLoopScrollView:_infoArr];
    }
}

- (void)setMessDic:(NSDictionary *)messDic{
    if (messDic) {
        _messDic = messDic;
        self.messLab.text = _messDic[@"title"];
    }
}

- (IBAction)topClick:(id)sender {
    self.conBtn.enabled = NO;
    [self performSelector:@selector(changeButtonStatus)withObject:nil afterDelay:1.0f];//防止重复点击
    [self openConfirmOrder];
}

- (void)changeButtonStatus{
    self.conBtn.enabled = YES;
}

- (void)openBanner:(NSDictionary *)dic{
    if (dic.count==0) {
        return;
    }
    HomeBannerDetailVC *banner = [HomeBannerDetailVC new];
    banner.title = dic[@"title"];
    banner.url = dic[@"url"];
    UIViewController *vc = [ShowLoginViewTool getCurrentVC];
    [vc.navigationController pushViewController:banner animated:YES];
}

- (void)openConfirmOrder{
    if (self.messDic.count==0) {
        return;
    }
    UIViewController *vc = [ShowLoginViewTool getCurrentVC];
    HomeMessageListVC *listVc = [HomeMessageListVC new];
    [vc.navigationController pushViewController:listVc animated:YES];
}

- (NSString *)UsingEncoding:(NSString *)str{
    NSString *url = [NSString stringWithFormat:@"%@%@",baseNet,str];
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
