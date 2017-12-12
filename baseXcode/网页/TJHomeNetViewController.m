//
//  TJHomeNetViewController.m
//  XiaoAHelp
//
//  Created by hangshao on 16/8/10.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJHomeNetViewController.h"
@interface TJHomeNetViewController ()<UIWebViewDelegate>
@property (nonatomic,   weak) UILabel     * midLabel;
@property (nonatomic, strong) UIActivityIndicatorView * activityView;//系统自带
@end

@implementation TJHomeNetViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    UILabel * midLabel = [[UILabel alloc] initWithFrame:Rect(0, 0, 200, 30)];
    midLabel.textAlignment = NSTextAlignmentCenter;
    midLabel.origin = CGPointMake(0, 64);
    midLabel.centerX = kScreenWidth/2;
    midLabel.text = @"网页由app.cqtianjiao.com提供";
    midLabel.textColor = [UIColor grayColor];
    midLabel.font = [UIFont systemFontOfSize:11 * ScaleModel];
    [self.view addSubview:midLabel];
    self.midLabel = midLabel;
    
    [self addView];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.activityView.center = [UIApplication sharedApplication].keyWindow.center;
    [self.view addSubview:self.activityView];
    self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    WeakSelf
    wself.ts_navgationBar = [TSNavigationBar navWithTitle:wself.navTitle backAction:^{
        [YHNetWork stopTheVcRequset:wself];
        [wself.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)addView
{
    UIWebView * view = [[UIWebView alloc]initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeigth - 64)];
    view.autoresizesSubviews = YES;//自动调整大小
    view.backgroundColor = [UIColor clearColor];
    view.delegate = self;
    [view scalesPageToFit];
    [view sizeToFit];
    NSString * url = [NSString string];
    NSString * ID = userClerkid;
    if ([self.urlStr rangeOfString:@"?"].location !=NSNotFound) {
        url = [NSString stringWithFormat:@"%@clerkid=%@",self.urlStr,ID];
    }else {
        url = [NSString stringWithFormat:@"%@?clerkid=%@",self.urlStr,ID];
    }
    if ([url containsString:@" "]) {
        url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [view loadRequest:request];
    [self.view addSubview:view];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityView stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityView stopAnimating];
}
@end
