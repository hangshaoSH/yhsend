//
//  UIColor+Utilities.h
//  DailyJokeProject
//
//  Created by LeungJR on 16/1/5.
//  Copyright © 2016年 LeungJR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utilities)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;

@end
