//
//  HSMidView.h
//  baseXcode
//
//  Created by hangshao on 16/11/3.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IndexBlock)(NSInteger buttonIndex);
@interface HSMidView : UIView
+(instancetype)sharedInstance;
//设置view宽度  颜色   字体颜色  按钮颜色  背景颜色  颜色传入string 或者[UIColor ###]格式
- (void)setMidViewWidth:(CGFloat)width viewColor:(id)viewColor WithTitle:(NSString *)title titleColor:(id)titleC AndMessage:(NSString *)message messageColor:(id)messageC AndLeftName:(NSString *)leftNAme leftTitleColor:(id)leftColor leftBackColor:(id)leftBackColor AndRightName:(NSString *)rightName rightTitleColor:(id)rightColor rightBackColor:(id)rightBackColor clickAtIndex:(IndexBlock)indexBlock;
//特别提醒 如不用message而有多排文字  请用title
@end
