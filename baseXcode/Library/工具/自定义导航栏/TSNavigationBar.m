//
//  TSNavigationBar.m
//  晟轩生鲜
//
//  Created by Seven on 15/10/13.
//  Copyright © 2015年 Seven Lv. All rights reserved.
//

/// 返回按钮图片
#define BackButtonImageName @"back_normal"
#warning 改图片名字在这里改

#import "TSNavigationBar.h"
#import <objc/runtime.h>
typedef void (^ButtonClick)(void);

@interface TSNavigationBar ()

@property(nonatomic, copy)ButtonClick backBlock;
@property(nonatomic, copy)ButtonClick actionBlock;
@end

@implementation TSNavigationBar

#pragma mark - 对象方法
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.size = Size(kScreenWidth, 64 + SafeAreaTopHeight);
        self.backgroundColor = [UIColor colorWithHexString:@"c9383a"];
        // 分隔线
        CALayer * layer = [CALayer layer];
        layer.frame = Rect(0, 64 + SafeAreaTopHeight, kScreenWidth, 0.1);
        layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        [self.layer addSublayer:layer];
        self.borderColor = [UIColor lightGrayColor];
        self.borderWidth = 0.2;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)act
{
    if (self = [super init]) {
        UILabel * label = [UILabel labelWithText:title font:17 * ScaleModel textColor:[UIColor whiteColor] frame:Rect(40, 20 + SafeAreaTopHeight*2/3, kScreenWidth - 80, 44)];
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        
        UIButton * back = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:BackButtonImageName frame:Rect(5, 32 + SafeAreaTopHeight*2/3, 44, 44)];
        [back addTarget:target action:act];
        back.contentEdgeInsets = UIEdgeInsetsMake(14, 8, 14, 20);
        back.centerY = label.centerY;
        back.adjustsImageWhenHighlighted = NO;
        [self addSubview:back];
        self.titleLabel = label;
    }
    return self;
    
}
- (instancetype)initWithTitle_:(NSString *)title
{
    if (self = [super init]) {
        UILabel * label = [UILabel labelWithText:title font:17 * ScaleModel textColor:[UIColor whiteColor] frame:Rect(0, 20 + SafeAreaTopHeight*2/3, kScreenWidth, 44)];
        [self addSubview:label];
        self.titleLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title backAction:(void (^)(void))backAction
{
    if (self = [super init]) {
        UILabel * label = [UILabel labelWithText:title font:17 * ScaleModel textColor:[UIColor whiteColor] frame:Rect(40, 20 + SafeAreaTopHeight*2/3, kScreenWidth - 80, 44)];
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        
        UIButton * back = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:BackButtonImageName frame:Rect(5, 32 + SafeAreaTopHeight*2/3, 44, 44)];
        [back addTarget:self action:@selector(backClick)];
        back.contentEdgeInsets = UIEdgeInsetsMake(14, 8, 14, 20);
        back.centerY = label.centerY;
        back.adjustsImageWhenHighlighted = NO;
        [self addSubview:back];
        if (backAction) {
            self.backBlock = backAction;
        }
        self.titleLabel = label;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title rightTitle:(NSString *)rightTitle rightAction:(void (^)(void))action
{
    if (self = [super init]) {
        UILabel * label = [UILabel labelWithText:title font:17 * ScaleModel textColor:[UIColor whiteColor] frame:Rect(0, 20 + SafeAreaTopHeight*2/3, kScreenWidth, 44)];
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        
        CGSize size = [NSString getStringRect:rightTitle fontSize:15 width:300];
        UIButton * btn = [UIButton buttonWithTitle:rightTitle titleColor:[UIColor blackColor] backgroundColor:nil font:15 image:nil frame:Rect(kScreenWidth - 15 - size.width, 0, size.width, 22)];
        [self addSubview:btn];
        btn.adjustsImageWhenHighlighted = NO;
        btn.centerY = label.centerY;
        
        [btn addTarget:self action:@selector(btnClick)];
        if (action) {
            self.actionBlock = action;
        }
        
        self.rightButton = btn;
        self.titleLabel = label;
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title rightImage:(NSString *)rightImage rightAction:(void (^)(void))action backAction:(void (^)(void))backAction
{
    if (self = [super init]) {
        UILabel * label = [UILabel labelWithText:title font:17 * ScaleModel textColor:[UIColor whiteColor] frame:Rect(0, 20 + SafeAreaTopHeight*2/3, kScreenWidth, 44)];
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        
        UIButton * btn = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:rightImage frame:Rect(kScreenWidth - 40, 0, 22, 22)];
        [self addSubview:btn];
        btn.adjustsImageWhenHighlighted = NO;
        btn.centerY = label.centerY;
        
        [btn addTarget:self action:@selector(btnClick)];
        if (action) {
            self.actionBlock = action;
        }
        
        UIButton * back = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:BackButtonImageName frame:Rect(0, 32 + SafeAreaTopHeight*2/3, 44, 44)];
        [back addTarget:self action:@selector(backClick)];
        back.contentEdgeInsets = UIEdgeInsetsMake(14, 8, 14, 20);
        back.centerY = label.centerY;
        back.adjustsImageWhenHighlighted = NO;
        [self addSubview:back];
        if (backAction) {
            self.backBlock = backAction;
        }
        
        self.titleLabel = label;
        self.rightButton = btn;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title rightTitle:(NSString *)right rightAction:(void (^)(void))action backAction:(void (^)(void))backAction
{
    if (self = [super init]) {
        UILabel * label = [UILabel labelWithText:title font:17 * ScaleModel textColor:[UIColor whiteColor] frame:Rect(0, 20 + SafeAreaTopHeight*2/3, kScreenWidth, 44)];
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        
        CGSize size = [NSString getStringRect:right fontSize:15 width:300];
        
        UIButton * btn = [UIButton buttonWithTitle:right titleColor:[UIColor blackColor] backgroundColor:nil font:15 image:nil frame:Rect(kScreenWidth - 15 - size.width, 0, size.width, 22)];
        [self addSubview:btn];
        btn.adjustsImageWhenHighlighted = NO;
        btn.centerY = label.centerY;
        
        [btn addTarget:self action:@selector(btnClick)];
        if (action) {
            self.actionBlock = action;
        }
        
        UIButton * back = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:BackButtonImageName frame:Rect(0, 32 + SafeAreaTopHeight*2/3, 44, 44)];
        [back addTarget:self action:@selector(backClick)];
        back.contentEdgeInsets = UIEdgeInsetsMake(14, 8, 14, 20);
        back.centerY = label.centerY;
        back.adjustsImageWhenHighlighted = NO;
        [self addSubview:back];
        if (backAction) {
            self.backBlock = backAction;
        }
        
        self.titleLabel = label;
        self.rightButton = btn;
    }
    return self;
}

#pragma mark - 类方法
+ (instancetype)navWithTitle:(NSString *)title
                  rightTitle:(NSString *)rightTitle
                 rightAction:(void(^)(void))action {
    return [[self alloc] initWithTitle:title rightTitle:rightTitle rightAction:action];
}
+ (instancetype)navWithTitle:(NSString *)title
{
    return [[self alloc] initWithTitle_:title];
}
+ (instancetype)navWithTitle:(NSString *)title backAction:(void (^)(void))backAction
{
    return [[self alloc] initWithTitle:title backAction:backAction];
}

+ (instancetype)navWithTitle:(NSString *)title rightImage:(NSString *)rightImage rightAction:(void (^)(void))action backAction:(void (^)(void))backAction
{
    return [[self alloc] initWithTitle:title rightImage:rightImage rightAction:action backAction:backAction];
}

+ (instancetype)navWithTitle:(NSString *)title rightTitle:(NSString *)right rightAction:(void (^)(void))action backAction:(void (^)(void))backAction
{
    return [[self alloc] initWithTitle:title rightTitle:right rightAction:action backAction:backAction];
}

#pragma mark - ButtonAction
- (void)btnClick {
    if (self.actionBlock) self.actionBlock();
}

- (void)backClick {
    if (self.backBlock) self.backBlock();
}
@end

#import "TSNavigationBar.h"
static NSString * key = @"NavigatiionBar";
static const char MJRefreshFooterKey = '\0';
@implementation UIViewController (NavigatiionBar)

- (void)setTs_navgationBar:(TSNavigationBar *)ts_navgationBar {
    
    if (self.ts_navgationBar != ts_navgationBar) {
        [self.ts_navgationBar removeFromSuperview];
        [self.view addSubview:ts_navgationBar];
        objc_setAssociatedObject(self, &MJRefreshFooterKey, ts_navgationBar, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (TSNavigationBar *)ts_navgationBar
{
    return objc_getAssociatedObject(self, &MJRefreshFooterKey);
}

@end
