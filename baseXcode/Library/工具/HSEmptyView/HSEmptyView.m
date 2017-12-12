//
//  HSEmptyView.m
//  baseXcode
//
//  Created by hangshao on 16/11/2.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "HSEmptyView.h"
static HSEmptyView * _empty = nil;
@interface HSEmptyView ()
@end

@implementation HSEmptyView
+(instancetype)sharedInstance
{
    if (_empty == nil) {
        _empty = [[self alloc] init];
    }
    return _empty;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _empty = [super allocWithZone:zone];
    });
    return _empty;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}
- (void)giveImageControllerToGetEmptyView:(UIViewController *)controller getViewOrginY:(CGFloat)viewOrginY getHeight:(NSInteger)height getColor:(NSString *)color setMidName:(NSString *)midLabel setMidFont:(CGFloat)font setMidColor:(NSString *)labelColor setImage:(NSString *)imageStr setImageOrignX:(CGFloat)orignX setImageOrignY:(CGFloat)orignY setImageWidth:(CGFloat)width setImageHeight:(CGFloat)imageHeight
{
    UIView * emptyview = [[[NSBundle mainBundle] loadNibNamed:@"HSEmptyVCell" owner:controller options:nil]lastObject];
    emptyview.frame = CGRectMake(0, viewOrginY, [[UIScreen mainScreen] bounds].size.width, height);
    if (color.length == 0) {
        emptyview.backgroundColor = [UIColor clearColor];
    } else {
        emptyview.backgroundColor = [UIColor colorWithHexString:color];
    }
    [[([UIApplication sharedApplication].delegate) window].rootViewController.view addSubview:emptyview];
    UILabel * label = (UILabel *)[emptyview viewWithTag:100];
    label.text = midLabel;
    label.font = [UIFont systemFontOfSize:font * [[UIScreen mainScreen] bounds].size.width/375];
    if (labelColor.length == 0) {
        label.textColor = [UIColor blackColor];
    } else {
        label.textColor = [UIColor colorWithHexString:labelColor];
    }
    if (imageStr.length > 0) {
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(orignX, orignY, width, imageHeight)];
        image.image = [UIImage imageNamed:imageStr];
        [emptyview addSubview:image];
        label.hidden = YES;
    } else {
        label.hidden = NO;
    }
}
- (void)giveNoImageControllerToGetEmptyView:(UIViewController *)controller getViewOrginY:(CGFloat)viewOrginY getHeight:(NSInteger)height getColor:(NSString *)color setMidName:(NSString *)midLabel setMidFont:(CGFloat)font setMidColor:(NSString *)labelColor
{
    UIView * emptyview = [[[NSBundle mainBundle] loadNibNamed:@"HSEmptyVCell" owner:controller options:nil]lastObject];
    emptyview.frame = CGRectMake(0, viewOrginY, [[UIScreen mainScreen] bounds].size.width, height);
    if (color.length == 0) {
        emptyview.backgroundColor = [UIColor clearColor];
    } else {
        emptyview.backgroundColor = [UIColor colorWithHexString:color];
    }
    [[([UIApplication sharedApplication].delegate) window].rootViewController.view addSubview:emptyview];
    UILabel * label = (UILabel *)[emptyview viewWithTag:100];
    label.text = midLabel;
    label.font = [UIFont systemFontOfSize:font * [[UIScreen mainScreen] bounds].size.width/375];
    if (labelColor.length == 0) {
        label.textColor = [UIColor blackColor];
    } else {
        label.textColor = [UIColor colorWithHexString:labelColor];
    }
}
- (void)hiddenView
{
    [self removeFromSuperview];
}

@end
