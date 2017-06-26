//
//  BannerWebViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/25.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "BannerWebViewController.h"

@interface BannerWebViewController ()<UIWebViewDelegate>

@end

@implementation BannerWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) setBannerStr:(NSString *)bannerStr{
    _bannerStr = bannerStr;
    UIWebView * webViews = [[UIWebView alloc]init];
    webViews.frame = self.view.bounds;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:_bannerStr]];
    webViews.backgroundColor = [UIColor cyanColor];
    webViews.delegate = self;
    [webViews loadRequest:request];
    [self.view addSubview:webViews];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];


    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navColorType = NavigationTitleColorTypeWhite;
    self.colorType = ButtonItemTitleColorTypeBlue;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"加载webview出错原因 %@",error);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
