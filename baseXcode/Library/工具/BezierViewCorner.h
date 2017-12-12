//
//  BezierViewCorner.h
//  new
//
//  Created by app on 2017/8/17.
//  Copyright © 2017年 杨航. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BezierViewCorner : NSObject
+ (instancetype)sharedInstance;
 //uiimageview  //半圆  //传圆角
- (void)setBezierCornerWithImageView:(UIImageView *)imageView;
- (void)setBezierCornerWithImageView:(UIImageView *)imageView andCornerValue:(CGFloat)cornerValue;
//uiview
- (void)setBezierCornerWithView:(UIView *)view;
- (void)setBezierCornerWithView:(UIView *)view andCornerValue:(CGFloat)cornerValue;
//button
- (void)setBezierCornerWithButton:(UIButton *)button;
- (void)setBezierCornerWithButton:(UIButton *)button andCornerValue:(CGFloat)cornerValue;
//label
- (void)setBezierCornerWithLabel:(UILabel *)label;
- (void)setBezierCornerWithLabel:(UILabel *)label andCornerValue:(CGFloat)cornerValue;
//UIScrollView
- (void)setBezierCornerWithScrollview:(UIScrollView *)scrollview;
- (void)setBezierCornerWithScrollview:(UIScrollView *)scrollview andCornerValue:(CGFloat)cornerValue;
//tableview
- (void)setBezierCornerWithTableview:(UITableView *)tableview;
- (void)setBezierCornerWithTableview:(UITableView *)tableview andCornerValue:(CGFloat)cornerValue;
//collectionview
- (void)setBezierCornerWithCollectionview:(UICollectionView *)collectionview;
- (void)setBezierCornerWithCollectionview:(UICollectionView *)collectionview andCornerValue:(CGFloat)cornerValue;
@end
