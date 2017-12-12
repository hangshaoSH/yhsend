//
//  UIVew+SL.m
//  SPAHOME
//
//  Created by 吕超 on 15/4/7.
//  Copyright (c) 2015年 TooCMS. All rights reserved.
//
#import "UIView+Extension.h"
#import <objc/runtime.h>
#define DEFAULT_VOID_COLOR [UIColor clearColor]
#pragma mark - UIView (Extension)

static NSString * const kCornerRadiusKey = @"cornerRadius";
static NSString * const kBorderColorKey = @"borderColorKey";


@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin {
    return self.frame.origin;
}

- (CGFloat)cornerRadius
{
    return [objc_getAssociatedObject(self, &kCornerRadiusKey) floatValue];
}


- (void)setCornerRadius:(CGFloat)cornerRadius
{
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)].CGPath;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    objc_setAssociatedObject(self, &kCornerRadiusKey, @(cornerRadius), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (UIColor *)borderColor
{
    return objc_getAssociatedObject(self, &kBorderColorKey);
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
    objc_setAssociatedObject(self, &kBorderColorKey, borderColor, OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}
- (void)setMaxX:(CGFloat)maxX
{
    self.x = maxX - self.width;
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}
- (void)setMaxY:(CGFloat)maxY
{
    self.y = maxY - self.height;
}
+ (UIView *)viewWithBgColor:(UIColor *)bgColor frame:(CGRect)frame {
    UIView * view = [[UIView alloc] initWithFrame:frame];
    if (!bgColor) {
        view.backgroundColor = [UIColor clearColor];
    } else {
        view.backgroundColor = bgColor;
    }
    return view;
}

@end


#pragma mark - UILabel (Extension)
@implementation UILabel (Extension)

+ (UILabel *)label
{
    return [[self alloc] init];
}

+ (UILabel *)labelWithText:(NSString *)text font:(CGFloat)fontSize textColor:(UIColor *)color frame:(CGRect)frame
{
    UILabel * label = [[self alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:fontSize];
    if (text) label.text = text;
    if (color) label.textColor = color;
    return label;
}
@end


#pragma mark - UIImageView
@implementation UIImageView (Extension)

+ (UIImageView *)imageViewWithImage:(UIImage *)image frame:(CGRect)frame {
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setImage:image];
    return imageView;
}

+ (UIImageView *)imageViewWithUrl:(NSURL *)url frame:(CGRect)frame {
    
    return [self imageViewWithUrl:url placeHolder:nil frame:frame];
}

+ (UIImageView *)imageViewWithUrl:(NSURL *)url placeHolder:(UIImage *)placeHolder frame:(CGRect)frame {
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView sd_setImageWithURL:url placeholderImage:placeHolder];
    return imageView;
}

@end

#pragma mark - UIScrollView
@implementation UIScrollView (Extension)

+ (UIScrollView *)scrollViewWithBgColor:(UIColor *)bgColor frame:(CGRect)frame
{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:frame];
    if (bgColor) {
        scrollView.backgroundColor = bgColor;
    } else {
        scrollView.backgroundColor = [UIColor clearColor];
    }
    return scrollView;
}

@end

