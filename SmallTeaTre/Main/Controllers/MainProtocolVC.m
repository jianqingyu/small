//
//  MainProtocolVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/7.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "MainProtocolVC.h"

@interface MainProtocolVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, copy) NSString *url;
@end

@implementation MainProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.content.length>0) {
        [self setDataWith:self.content];
        return;
    }
    if (self.isFir) {
        self.url = @"api/help/protocol";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
        [self loadRegisterData];
    }else{
        self.url = @"api/help/type/";
        [self loadHomeData];
    }
}

- (void)loadRegisterData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *netUrl = [NSString stringWithFormat:@"%@%@",baseNet,self.url];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            NSDictionary *dic = [_typeId isEqualToString:@"0001"]?response.result[0]:response.result[1];
            [self setDataWith:dic[@"content"]];
        }else{
            NSString *str = response.msg?response.msg:@"查询失败";
            [MBProgressHUD showError:str];
        }
    } requestURL:netUrl params:params];
}

- (void)loadHomeData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *netUrl = [NSString stringWithFormat:@"%@%@%@",baseNet,self.url,_typeId];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            [self setDataWith:response.result[0][@"content"]];
        }else{
            NSString *str = response.msg?response.msg:@"查询失败";
            [MBProgressHUD showError:str];
        }
    } requestURL:netUrl params:params];
}

- (void)setDataWith:(NSString *)str{
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithData:
                [str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                          documentAttributes:nil error:nil];
    self.textView.attributedText = attributedString;
}

- (void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
