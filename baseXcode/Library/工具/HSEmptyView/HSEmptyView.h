//
//  HSEmptyView.h
//  baseXcode
//
//  Created by hangshao on 16/11/2.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSEmptyView : UIView
+ (instancetype)sharedInstance;

//传入当前controller  view高度  颜色 空数据名称   字体大小  字体颜色 图片名称(名称为空时默认无图) 位置
//颜色均传入 hexString

- (void)giveImageControllerToGetEmptyView:(UIViewController *)controller getViewOrginY:(CGFloat)viewOrginY getHeight:(NSInteger)height getColor:(NSString *)color setMidName:(NSString *)midLabel setMidFont:(CGFloat)font setMidColor:(NSString *)labelColor setImage:(NSString *)imageStr setImageOrignX:(CGFloat)orignX setImageOrignY:(CGFloat)orignY setImageWidth:(CGFloat)width setImageHeight:(CGFloat)imageHeight;//有图
- (void)giveNoImageControllerToGetEmptyView:(UIViewController *)controller getViewOrginY:(CGFloat)viewOrginY getHeight:(NSInteger)height getColor:(NSString *)color setMidName:(NSString *)midLabel setMidFont:(CGFloat)font setMidColor:(NSString *)labelColor;//无图
- (void)hiddenView;
@end
