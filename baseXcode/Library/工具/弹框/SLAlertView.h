//
//  SLAlertView.h
//  AlertView
//
//  Created by Seven on 15/10/10.
//  Copyright (c) 2015年 Seven Lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLAlertView : UIView

/// 弹框
///
/// @param title     标题
/// @param cancelbtn 取消按钮
/// @param des       破坏性按钮
/// @param array     其它按钮
/// @param click     按钮点击事件(buttonIndex从上到下为0.1.2....,取消按钮没有索引)
+ (void)alertViewWithTitle:(NSString *)title cancelBtn:(NSString *)cancelbtn destructiveButton:(NSString *)des otherButtons:(NSArray *)array clickAtIndex:(void (^)(NSInteger buttonIndex))click;
@end
