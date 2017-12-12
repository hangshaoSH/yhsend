//
//  MainViewController.m
//  XiaoAHelp
//
//  Created by hangshao on 16/7/11.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "TJHomeViewController.h"
#import "TJStatisticsViewController.h"
#import "TJManageViewController.h"

@interface MainViewController ()<UITabBarControllerDelegate>

@property (nonatomic,   weak) UIButton * selectButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self initializeUserInterface];
    
    [self initializeUserNotice];
}

- (void)initializeUserInterface
{
    NSArray *selectImages = @[@"home_select",@"manager_select",@"statistics_select"];
    NSArray *normalImages = @[@"home_normal",@"manager_normal",@"statistics_normal"];
    NSArray *title = @[@"首页",@"管理",@"统计"];
    
    NSMutableArray * items = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:title[i] image:[UIImage imageNamed:normalImages[i]] selectedImage:[UIImage imageNamed:selectImages[i]]];
        [items addObject:item];
    }
    NSArray *views = @[[TJHomeViewController new],
                       [TJManageViewController new],
                       [TJStatisticsViewController new]];
    
    for (int i = 0; i < views.count; i ++) {
        UIViewController * viewC = views[i];
        viewC.tabBarItem = items[i];
    }
    
    self.tabBar.translucent = YES;
    NSMutableArray * viewCs = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < views.count; i ++) {
        BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:views[i]];
        [viewCs addObject:nav];
    }
    self.viewControllers = viewCs;
    self.selectedIndex = 0;
}
#pragma mark - 初始化tabbaritem设置(字体颜色等)
+ (void)initialize
{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = TopBgColor;
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}
- (void)initializeUserNotice
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToFirstPage) name:@"PushToFirstPage" object:nil];
}

- (void)pushToFirstPage
{
    self.selectedIndex = 0;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    [YHNetWork stopAllRequest];//切换页面  清除网络请求
}
@end
