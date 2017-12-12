//
//  UIButton+SL.m
//  Sushi
//
//  Created by toocmstoocms on 15/5/8.
//  Copyright (c) 2015年 Seven. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "UIButton+Extension.h"

@implementation UIButton (Extension)
- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}
- (NSString *)title
{
    return self.currentTitle;
}
- (void)setImage:(NSString *)image
{
    [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}
- (NSString *)image
{
    return nil;
}
-(void)addTarget:(id)target action:(SEL)action {
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
- (void)setTitleColor:(UIColor *)titleColor
{
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}
- (UIColor *)titleColor
{
    return self.currentTitleColor;
}
- (NSString *)highlightImage
{
    return nil;
}
- (void)setHighlightImage:(NSString *)highlightImage
{
    [self setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
}
- (NSString *)selectImage
{
    return nil;
}
- (void)setSelectImage:(NSString *)selectImage
{
    [self setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
}
- (CGFloat)titleFont
{
    return 0;
}
- (void)setTitleFont:(CGFloat)titleFont
{
    self.titleLabel.font = [UIFont systemFontOfSize:titleFont];
}
- (UIColor *)selectTitleColor
{
    return nil;
}
- (void)setSelectTitleColor:(UIColor *)selectTitleColor
{
    [self setTitleColor:selectTitleColor forState:UIControlStateSelected];
}
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)bgColor font:(CGFloat)fontSize image:(NSString *)imageName frame:(CGRect)frame
{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    button.adjustsImageWhenDisabled = NO;
    button.adjustsImageWhenHighlighted = NO;
    if (title) button.title = title;
    if (titleColor) button.titleColor = titleColor;
    if (bgColor) button.backgroundColor = bgColor;
    if (fontSize) button.titleFont = fontSize;
    if (imageName) {
        button.image = imageName;
        button.contentMode = UIViewContentModeCenter;
    }
    return button;
}
@end
