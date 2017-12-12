//
//  HSMidView.m
//  baseXcode
//
//  Created by hangshao on 16/11/3.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "HSMidView.h"
static HSMidView * _midView = nil;
static IndexBlock _indexBlock;
@interface HSMidView ()
@property (nonatomic,   weak) UIView     * midview;
@property (nonatomic,   weak) UIView     * bgView;
@end

@implementation HSMidView

+(instancetype)sharedInstance
{
    if (_midView == nil) {
        _midView = [[self alloc] init];
    }
    return _midView;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _midView = [super allocWithZone:zone];
    });
    return _midView;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
}
- (void)setMidViewWidth:(CGFloat)width viewColor:(id)viewColor WithTitle:(NSString *)title titleColor:(id)titleC AndMessage:(NSString *)message messageColor:(id)messageC AndLeftName:(NSString *)leftNAme leftTitleColor:(id)leftColor leftBackColor:(id)leftBackColor AndRightName:(NSString *)rightName rightTitleColor:(id)rightColor rightBackColor:(id)rightBackColor clickAtIndex:(IndexBlock)indexBlock
{
    _indexBlock = [indexBlock copy];
    UIView * bgView = [[UIView alloc] initWithFrame:[([UIApplication sharedApplication].delegate) window].rootViewController.view.frame];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    self.bgView = bgView;
    
    NSInteger height = 0;
    UIView * midView = [[[NSBundle mainBundle] loadNibNamed:@"HSMidVCell" owner:[([UIApplication sharedApplication].delegate) window].rootViewController options:nil]lastObject];
    CGSize titleS = [title getStringRectWithfontSize:15 * ScaleModel width:width - 40];
    CGSize messageS = [message getStringRectWithfontSize:14 * ScaleModel width:width - 40];
    if (message.length == 0) {
        height = 137 + titleS.height - 42;
    } else {
        height = messageS.height + 137 + titleS.height - 35;
    }
    midView.frame = CGRectMake(0, 0, width, height);
    midView.cornerRadius = 5.0;
    midView.center  = [UIApplication sharedApplication].keyWindow.center;
    if ([viewColor isKindOfClass:[NSString class]]) {
        NSString * str = viewColor;
        if (str.length > 0) {
            midView.backgroundColor = [UIColor colorWithHexString:viewColor];
            self.backgroundColor = [UIColor colorWithHexString:viewColor];
        }
    }else {
        midView.backgroundColor = viewColor;
        self.backgroundColor = viewColor;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:midView];
    self.midview = midView;
    UILabel * title0 = (UILabel *)[midView viewWithTag:100];
    title0.font = [UIFont systemFontOfSize:15 * ScaleModel];
    UILabel * message0 = (UILabel *)[midView viewWithTag:101];
    message0.font = [UIFont systemFontOfSize:14 * ScaleModel];
    UIButton * left0 = (UIButton *)[midView viewWithTag:110];
    left0.titleFont = 15 * ScaleModel;
    UIButton * right0 = (UIButton *)[midView viewWithTag:111];
    right0.titleFont = 15 * ScaleModel;
    left0.title = leftNAme;
    right0.title = rightName;
    left0.cornerRadius = 5.0f;
    right0.cornerRadius = 5.0f;
    if (title.length > 0) {
        title0.text = title;
    }
    if ([titleC isKindOfClass:[NSString class]]) {
        NSString * str = titleC;
        if (str.length > 0) {
            title0.textColor = [UIColor colorWithHexString:titleC];
        }
    }else {
        title0.textColor = titleC;
    }
    if ([messageC isKindOfClass:[NSString class]]) {
        NSString * str = messageC;
        if (str.length > 0) {
            message0.textColor = [UIColor colorWithHexString:messageC];
        }
    }else {
        message0.textColor = messageC;
    }
    if ([leftColor isKindOfClass:[NSString class]]) {
        NSString * str = leftColor;
        if (str.length > 0) {
            left0.titleColor = [UIColor colorWithHexString:leftColor];
        }
    }else {
        left0.titleColor = leftColor;
    }
    if ([rightColor isKindOfClass:[NSString class]]) {
        NSString * str = rightColor;
        if (str.length > 0) {
            right0.titleColor = [UIColor colorWithHexString:rightColor];
        }
    }else {
        right0.titleColor = rightColor;
    }
    if ([leftBackColor isKindOfClass:[NSString class]]) {
        NSString * str = leftBackColor;
        if (str.length > 0) {
            left0.backgroundColor = [UIColor colorWithHexString:leftBackColor];
        }
    }else {
        left0.backgroundColor = leftBackColor;
    }
    if ([rightBackColor isKindOfClass:[NSString class]]) {
        NSString * str = rightBackColor;
        if (str.length > 0) {
            right0.backgroundColor = [UIColor colorWithHexString:rightBackColor];
        }
       
    }else {
        right0.backgroundColor = rightBackColor;
    }
    if (message.length == 0) {
        message0.hidden = YES;
    } else {
        message0.text = message;
        message0.hidden = NO;
    }
    [left0 addTarget:self action:@selector(leftAction0:)];
    [right0 addTarget:self action:@selector(rightAction0:)];
}
- (void)leftAction0:(UIButton *)button
{
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    [self.midview removeFromSuperview];
    self.midview = nil;
    if (_indexBlock) {
        _indexBlock(button.tag - 110);
    }
}
- (void)rightAction0:(UIButton *)button
{
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    [self.midview removeFromSuperview];
    self.midview = nil;
    if (_indexBlock) {
        _indexBlock(button.tag - 110);
    }
}
@end
