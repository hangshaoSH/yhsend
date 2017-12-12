//
//  UIVew+SL.h
//  SPAHOME
//
//  Created by 吕超 on 15/4/7.
//  Copyright (c) 2015年 TooCMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
/** 边框颜色 */
@property (nonatomic, strong) UIColor * borderColor;
/** 边框宽度 */
@property (nonatomic, assign) CGFloat borderWidth;
/** 最大 X */
@property (nonatomic, assign) CGFloat maxX;
/** 最大 Y */
@property (nonatomic, assign) CGFloat maxY;

+ (UIView *)viewWithBgColor:(UIColor *)bgColor frame:(CGRect)frame;
@end


@interface UILabel (Extension)

+ (UILabel *)label;
+ (UILabel *)labelWithText:(NSString *)text font:(CGFloat)fontSize textColor:(UIColor *)color frame:(CGRect)frame;
@end


@interface UIImageView (Extension)
+ (UIImageView *)imageViewWithUrl:(NSURL *)url frame:(CGRect)frame;
+ (UIImageView *)imageViewWithUrl:(NSURL *)url placeHolder:(UIImage *)placeHolder frame:(CGRect)frame;
+ (UIImageView *)imageViewWithImage:(UIImage *)image frame:(CGRect)frame;
@end

@interface UIScrollView (Extension)
+ (UIScrollView *)scrollViewWithBgColor:(UIColor *)bgColor frame:(CGRect)frame;
@end


