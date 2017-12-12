//
//  TSNavigationBar.h
//  晟轩生鲜
//
//  Created by Seven on 15/10/13.
//  Copyright © 2015年 Seven Lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSNavigationBar : UIView
@property (nonatomic,   weak) UILabel * titleLabel;
@property (nonatomic,   weak) UIButton * rightButton;

- (instancetype)initWithTitle_:(NSString *)title;

- (instancetype)initWithTitle:(NSString *)title
                   backAction:(void(^)(void))backAction;

- (instancetype)initWithTitle:(NSString *)title
                   rightImage:(NSString *)rightImage
                  rightAction:(void (^)(void))action
                   backAction:(void (^)(void))backAction;

- (instancetype)initWithTitle:(NSString *)title
                   rightTitle:(NSString *)right
                  rightAction:(void (^)(void))action
                   backAction:(void (^)(void))backAction;

- (instancetype)initWithTitle:(NSString *)title
                   rightTitle:(NSString *)rightTitle
                  rightAction:(void(^)(void))action;

//  只有标题
//
//  @param title 标题
//
//  @return 导航栏
+ (instancetype)navWithTitle:(NSString *)title;

//  只有标题和返回键
//
//  @param title      标题
//  @param backAction 返回事件
//
//  @return 导航栏
+ (instancetype)navWithTitle:(NSString *)title
                  backAction:(void(^)(void))backAction;

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)act;

// 标题 + 右边文字
//
// @param title      标题
// @param backAction 右侧点击事件
//
// @return 导航栏
+ (instancetype)navWithTitle:(NSString *)title
                  rightTitle:(NSString *)rightTitle
                 rightAction:(void(^)(void))action;

//  右侧是文字的导航栏
//  @param title      标题
//  @param right      右侧文字
//  @param action     右侧点击事件
//  @param backAction 返回事件
//
//  @return 导航栏
+ (instancetype)navWithTitle:(NSString *)title
                  rightTitle:(NSString *)right
                 rightAction:(void(^)(void))action
                  backAction:(void(^)(void))backAction;

//  右侧是图片的导航栏
//
//  @param title      标题
//  @param rightImage 右侧图片
//  @param action     右侧点击事件
//  @param backAction 返回事件
//
//  @return 导航栏
+ (instancetype)navWithTitle:(NSString *)title
                  rightImage:(NSString *)rightImage
                 rightAction:(void(^)(void))action
                  backAction:(void(^)(void))backAction;
@end


@class TSNavigationBar;
@interface UIViewController (NavigatiionBar)

@property (nonatomic, strong) TSNavigationBar * ts_navgationBar;

@end
