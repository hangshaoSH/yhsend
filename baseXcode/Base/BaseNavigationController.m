//
//  BaseNavigationController.m
//  XiaoAHelp
//
//  Created by hangshao on 16/7/11.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
}

#pragma mark - 初始化UI
- (void)_initView {
    
    //设置导航栏的背景颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor greenColor]];
    self.navigationBar.hidden = YES;
    self.fd_fullscreenPopGestureRecognizer.enabled = YES;    //修改导航栏标题的字体
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor whiteColor];
    shadow.shadowOffset = CGSizeMake(0.5, 0.5);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont systemFontOfSize:18], NSFontAttributeName, nil]];
    
    
    
    
}
//修改状态栏的风格
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
}

/**
 *  拦截所有导航控制器的push操作
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        ///第二层viewcontroller 隐藏tabbar
        viewController.hidesBottomBarWhenPushed=YES;
    }
    [super pushViewController:viewController animated:YES];
}

@end
