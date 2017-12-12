//
//  TJPubMessageDetailViewController.m
//  baseXcode
//
//  Created by hangshao on 17/1/3.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJPubMessageDetailViewController.h"

@interface TJPubMessageDetailViewController ()<UIWebViewDelegate>
@property (nonatomic,   weak) UILabel     * midLabel;
@property (nonatomic, strong) UIActivityIndicatorView * activityView;//系统自带
@end

@implementation TJPubMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView];
    
    [self setBottomView];
}

#pragma mark - setview

- (void)setTopView
{
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
    UIWebView * view = [[UIWebView alloc]initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeigth - 64-100)];
    view.autoresizesSubviews = YES;//自动调整大小
    view.backgroundColor = [UIColor clearColor];
    view.delegate = self;
    [view scalesPageToFit];
    [view sizeToFit];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlStr]];
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
- (void)setBottomView
{
    UIView * view = [[[NSBundle mainBundle] loadNibNamed:@"TJKeepBaseCell" owner:self options:nil]objectAtIndex:2];
    view.frame = Rect(0, kScreenHeigth-100, kScreenWidth, 100);
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    
    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[view viewWithTag:110 + i];
        button.titleFont = 15 * ScaleModel;
        button.cornerRadius = 5.0;
        if (i == 0) {
            button.backgroundColor = orangecolor;
        } else {
            button.backgroundColor = [UIColor colorWithHexString:@"b5b5b5"];
        }
        [button addTarget:self action:@selector(tuisongOrDelete:)];
    }
}
#pragma mark - buttonAction
- (void)tuisongOrDelete:(UIButton *)button
{
    NSString * showStr = [NSString string];
    NSInteger number = 0;
    if (button.tag == 110) {//推送
        number = 1;
        showStr = @"是否推送该条信息?";
    } else {//删除
        showStr = @"是否删除该条信息?";
        number = 0;
    }
    [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:showStr titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self beginTuisongOrdelete:number];
        }
    }];
}
#pragma mark - delete

#pragma mark - netWorking
- (void)beginTuisongOrdelete:(NSInteger)number
{
    NSString * showLabel = [NSString string];
    if (number == 0) {
        showLabel = @"删除成功!";
    } else {
        showLabel = @"推送成功!";
    }
    NSString * url = @"wuye/newsact.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"newsid"] = self.newsid;
    params[@"act"] = @(number);
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(showLabel);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (number == 0) {
                    if (self.refreshBlock) {
                        self.refreshBlock();
                    }
                }
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else {
            SVShowError(request[@"err"]);
        }
    } failBlock:^(NSError *error) {
        SVShowError(@"网络连接错误，请检查您的网络!");
    }];
}
#pragma mark - 懒加载
@end
