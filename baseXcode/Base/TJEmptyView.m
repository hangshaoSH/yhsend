//
//  TJEmptyView.m
//  XiaoAHelp
//
//  Created by hangshao on 16/8/15.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJEmptyView.h"

@interface TJEmptyView ()

@end

@implementation TJEmptyView

- (void)setEmptyView:(UIViewController *)controller x:(CGFloat)x y:(CGFloat)y wdth:(CGFloat)wdth height:(CGFloat)height labe:(NSString *)label
{
    UIView * view = [[UIView alloc] initWithFrame:Rect(x, y, wdth, height)];
    view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [controller.view addSubview:view];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:Rect(0, 0, wdth, 20)];
    label1.textColor = [UIColor blackColor];
    label1.centerX = wdth/2;
    label1.centerY = height/2;
    label1.text = label;
    label1.font = [UIFont systemFontOfSize:15];
    [view addSubview:label1];
    
}

@end
