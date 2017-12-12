//
//  BezierViewCorner.m
//  new
//
//  Created by app on 2017/8/17.
//  Copyright © 2017年 杨航. All rights reserved.
//

#import "BezierViewCorner.h"
static BezierViewCorner * _bezierViewCorner = nil;
@interface BezierViewCorner ()

@end

@implementation BezierViewCorner

+(instancetype)sharedInstance
{
    if (_bezierViewCorner == nil) {
        _bezierViewCorner = [[self alloc] init];
    }
    return _bezierViewCorner;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bezierViewCorner = [super allocWithZone:zone];
    });
    return _bezierViewCorner;
}

- (void)setBezierCornerWithImageView:(UIImageView *)imageView andCornerValue:(CGFloat)cornerValue
{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:cornerValue];
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = imageView.bounds;
    shapeLayer.path = bezierPath.CGPath;
    imageView.layer.mask = shapeLayer;
    
}
- (void)setBezierCornerWithImageView:(UIImageView *)imageView
{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = imageView.bounds;
    shapeLayer.path = bezierPath.CGPath;
    imageView.layer.mask = shapeLayer;
}
- (void)setBezierCornerWithView:(UIView *)view andCornerValue:(CGFloat)cornerValue
{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:cornerValue];
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = view.bounds;
    shapeLayer.path = bezierPath.CGPath;
    view.layer.mask = shapeLayer;
}
- (void)setBezierCornerWithView:(UIView *)view
{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:view.bounds.size];
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = view.bounds;
    shapeLayer.path = bezierPath.CGPath;
    view.layer.mask = shapeLayer;
}
- (void)setBezierCornerWithButton:(UIButton *)button andCornerValue:(CGFloat)cornerValue
{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds cornerRadius:cornerValue];
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = button.bounds;
    shapeLayer.path = bezierPath.CGPath;
    button.layer.mask = shapeLayer;
}
- (void)setBezierCornerWithButton:(UIButton *)button
{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:button.bounds.size];
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = button.bounds;
    shapeLayer.path = bezierPath.CGPath;
    button.layer.mask = shapeLayer;
}
- (void)setBezierCornerWithLabel:(UILabel *)label andCornerValue:(CGFloat)cornerValue
{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:label.bounds cornerRadius:cornerValue];
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = label.bounds;
    shapeLayer.path = bezierPath.CGPath;
    label.layer.mask = shapeLayer;
}
- (void)setBezierCornerWithLabel:(UILabel *)label
{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:label.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:label.bounds.size];
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = label.bounds;
    shapeLayer.path = bezierPath.CGPath;
    label.layer.mask = shapeLayer;
}
- (void)setBezierCornerWithScrollview:(UIScrollView *)scrollview andCornerValue:(CGFloat)cornerValue
{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:scrollview.bounds cornerRadius:cornerValue];
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = scrollview.bounds;
    shapeLayer.path = bezierPath.CGPath;
    scrollview.layer.mask = shapeLayer;
}
- (void)setBezierCornerWithScrollview:(UIScrollView *)scrollview
{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:scrollview.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:scrollview.bounds.size];
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = scrollview.bounds;
    shapeLayer.path = bezierPath.CGPath;
    scrollview.layer.mask = shapeLayer;
}
- (void)setBezierCornerWithTableview:(UITableView *)tableview andCornerValue:(CGFloat)cornerValue
{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:tableview.bounds cornerRadius:cornerValue];
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = tableview.bounds;
    shapeLayer.path = bezierPath.CGPath;
    tableview.layer.mask = shapeLayer;
}
-(void)setBezierCornerWithTableview:(UITableView *)tableview
{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:tableview.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:tableview.bounds.size];
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = tableview.bounds;
    shapeLayer.path = bezierPath.CGPath;
    tableview.layer.mask = shapeLayer;
}
- (void)setBezierCornerWithCollectionview:(UICollectionView *)collectionview andCornerValue:(CGFloat)cornerValue
{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:collectionview.bounds cornerRadius:cornerValue];
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = collectionview.bounds;
    shapeLayer.path = bezierPath.CGPath;
    collectionview.layer.mask = shapeLayer;
}
- (void)setBezierCornerWithCollectionview:(UICollectionView *)collectionview
{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:collectionview.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:collectionview.bounds.size];
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = collectionview.bounds;
    shapeLayer.path = bezierPath.CGPath;
    collectionview.layer.mask = shapeLayer;
}
@end
