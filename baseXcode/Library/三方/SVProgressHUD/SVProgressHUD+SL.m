//
//  SVProgressHUD+SL.m
//  svprogress
//
//  Created by Seven on 15/7/28.
//  Copyright (c) 2015年 toocms. All rights reserved.
//

#import "SVProgressHUD+SL.h"

@implementation SVProgressHUD (SL)
+ (void)showSuccess:(NSString *)success
{
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD showSuccessWithStatus:success];
}

+ (void)showError:(NSString *)error
{
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD showInfoWithStatus:error];
}

+ (void)showStatus:(NSString *)status
{
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD showWithStatus:status];
}
@end
