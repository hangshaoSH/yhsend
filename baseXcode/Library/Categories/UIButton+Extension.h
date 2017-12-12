//
//  UIButton+SL.h
//  Sushi
//
//  Created by toocmstoocms on 15/5/8.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)
/** 文字*/
@property (nonatomic, copy) NSString * title;
/** 图片*/
@property (nonatomic, copy) NSString * image;
/** 高亮图片*/
@property (nonatomic, copy) NSString * highlightImage;
/** 选中*/
@property (nonatomic, copy) NSString * selectImage;
/** 文字颜色*/
@property (nonatomic, strong) UIColor * titleColor;
/** 选中文字颜色 */
@property (nonatomic, strong) UIColor * selectTitleColor;

@property (nonatomic , assign) CGFloat titleFont;

/**
 *  添加监听
 */
- (void)addTarget:(id)target action:(SEL)action;

/**
 *  快速创建button
 *
 *  @param title      文字
 *  @param titleColor 文字颜色
 *  @param bgColor    背影颜色
 *  @param fontSize   字体大小
 *  @param imageName  图片名
 *  @param frame      frame
 *
 *  @return UIButton
 */
+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
              backgroundColor:(UIColor *)bgColor
                         font:(CGFloat)fontSize
                        image:(NSString *)imageName
                        frame:(CGRect)frame;

@end
