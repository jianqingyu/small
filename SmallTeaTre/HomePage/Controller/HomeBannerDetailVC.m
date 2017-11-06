//
//  HomeBannerDetailVC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/27.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "HomeBannerDetailVC.h"

@interface HomeBannerDetailVC ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation HomeBannerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [self loadHmtl];
}

- (void)loadHmtl{
    NSURLRequest *urlRe = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:urlRe];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}

@end
