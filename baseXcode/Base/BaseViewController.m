//
//  BaseViewController.m
//  XiaoAHelp
//
//  Created by hangshao on 16/7/11.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "BaseViewController.h"
#import "BaiduMobStat.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)dealloc
{
    TSLog(NSStringFromClass(self.class));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//        [self initBaseView];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}


-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    if ([User sharedUser].stopView == 1) {
        return;
    }
    [self.view endEditing:YES];
}
#pragma mark - 初始化UI
- (void)initBaseView {
    
    //添加左边、右边按钮
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1) {
        
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 13, 20)];
        [leftButton setImage:[UIImage imageNamed:@"2-1"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftButtonItem;
        
    }
}
- (void)leftButtonAction:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [YHNetWork stopAllRequest];
    NSString * name = NSStringFromClass([self class]);
    [[BaiduMobStat defaultStat] pageviewEndWithName:name];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [User sharedUser].urlFlag = 0;
    [User sharedUser].showMidLoading = @"数据加载中...";
    NSString * name = NSStringFromClass([self class]);
    [[BaiduMobStat defaultStat] pageviewStartWithName:name];
}
@end
