//
//  HomeShoppingDetailVc.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/11.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "HomeShoppingDetailVc.h"

@interface HomeShoppingDetailVc ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HomeShoppingDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    _webView.scrollView.bounces = NO; 
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [self loadHmtl];
}

- (void)loadHmtl{
    NSString *netUrl = [NSString stringWithFormat:@"%@%@",baseNet,self.url];
    NSURLRequest *urlRe = [NSURLRequest requestWithURL:[NSURL URLWithString:netUrl]];
    [self.webView loadRequest:urlRe];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
    [self setBaseWebView:webView];
}
//适配html网页
- (void)setBaseWebView:(UIWebView *)webView{
    //定义JS字符串
    NSString *script = [NSString stringWithFormat: @"var script = document.createElement('script');"
                        "script.type = 'text/javascript';"
                        "script.text = \"function ResizeImages() { "
                        "var myimg;"
                        "var maxwidth=%f;" //屏幕宽度
                        "for(i=0;i <document.images.length;i++){"
                        "myimg = document.images[i];"
                        "myimg.height = maxwidth / (myimg.width/myimg.height);"
                        "myimg.width = maxwidth;"
                        "}"
                        "}\";"
                        "document.getElementsByTagName('p')[0].appendChild(script);",SDevWidth-15];
    //添加JS
    [webView stringByEvaluatingJavaScriptFromString:script];
    //添加调用JS执行的语句
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}

- (void)backClick{
    if ([_webView canGoBack]) {
        [_webView goBack];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
