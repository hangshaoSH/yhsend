//
//  TJTongJiWebTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/11/25.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJTongJiWebTableViewCell.h"

@interface TJTongJiWebTableViewCell ()<UIWebViewDelegate>
@property (nonatomic, strong) UIActivityIndicatorView * activityView;//系统自带
@end

@implementation TJTongJiWebTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.activityView.centerX = kScreenWidth/2;
    self.activityView.centerY = kScreenHeigth/2;
    [self addSubview:self.activityView];
    self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJTongJiWebCell";
    TJTongJiWebTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJStatisticsCell" owner:self options:nil] objectAtIndex:1];
    }
    return cell;
}
- (void)seturlWithStr:(NSString *)str
{
    _tongjiweb.autoresizesSubviews = YES;//自动调整大小
    _tongjiweb.backgroundColor = [UIColor clearColor];
    _tongjiweb.delegate = self;
    [_tongjiweb scalesPageToFit];
    [_tongjiweb sizeToFit];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
    [_tongjiweb loadRequest:request];
    if ([User sharedUser].goflag == 0) {
        _tongjiweb.userInteractionEnabled = NO;
        [User sharedUser].goflag = 1;
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityView startAnimating];
    NSString * title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (title.length > 0) {
        if ([User sharedUser].h5flag == 0) {
            if ([_delegate respondsToSelector:@selector(touchTitle:)]) {
                [_delegate touchTitle:title];
            }
        }
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityView stopAnimating];
    _tongjiweb.userInteractionEnabled = YES;
    [User sharedUser].goflag = 2;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityView stopAnimating];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (UIWebViewNavigationTypeLinkClicked == navigationType) {
         NSString *url = [[[request URL] absoluteString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [User sharedUser].h5Urlstring = url;
        [User sharedUser].h5flag = 0;
        return YES; //对链接进行了拦截处理，返回false
    }
    NSString *url = [[[request URL] absoluteString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([url hasPrefix:@"http://wy.cqtianjiao.com/guanjia/sincere/web/stattoday.jsp"]) {
        [User sharedUser].h5Urlstring = url;
        [User sharedUser].h5flag = 0;
    }
    return YES;
}
@end
