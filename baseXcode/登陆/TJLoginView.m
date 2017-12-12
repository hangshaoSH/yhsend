//
//  TJLoginView.m
//  baseXcode
//
//  Created by hangshao on 16/11/18.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJLoginView.h"

@interface TJLoginView ()<UITextFieldDelegate>

@property (nonatomic,   weak) UITextField     * accountNumber;
@property (nonatomic,   weak) UITextField     * passwordNew;
@property (nonatomic,   assign) NSInteger   chooseFlag;
@property (nonatomic,   weak) UIButton     * chooseBut;
@property (nonatomic,   weak) UIButton     * chooseBut1;
@end

@implementation TJLoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"2c2c2c"];
        [self setMainView];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHideView)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = NO;
        //将触摸事件添加到当前view
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}
- (void)keyboardHideView
{
    [self endEditing:YES];
}
- (void)setMainView
{
    UIImageView * AImageView = [[UIImageView alloc] initWithFrame:Rect(0, 72 * ScaleModel, 124 * ScaleModel, 124 * ScaleModel)];
    AImageView.centerX = kScreenWidth/2;
    AImageView.image = [UIImage imageNamed:@"login_photo"];
    [self addSubview:AImageView];
    
    //账号
    UIView * topView = [[UIView alloc] initWithFrame:Rect(40.5 * ScaleModel, 282 * ScaleModel, kScreenWidth - 81 *ScaleModel, 43 * ScaleModel)];
    topView.backgroundColor = [UIColor clearColor];
    topView.cornerRadius = 5.0;
    [self addSubview:topView];
    
    UIView * leftview = [[UIView alloc] initWithFrame:Rect(0, 0, 44 * ScaleModel, topView.height)];
    leftview.backgroundColor = [UIColor blackColor];
    [topView addSubview:leftview];
    
    UIImageView * personImage = [[UIImageView alloc] initWithFrame:Rect(0, 0, 19 * ScaleModel, 22 * ScaleModel)];
    personImage.image = [UIImage imageNamed:@"login_person"];
    personImage.centerX = leftview.width/2;
    personImage.centerY = leftview.height/2;
    [leftview addSubview:personImage];
    
    UIView * rightview = [[UIView alloc] initWithFrame:Rect(leftview.width, 0, topView.width - leftview.width, topView.height)];
    rightview.backgroundColor = [UIColor colorWithHexString:@"424242"];
    [topView addSubview:rightview];
    
    UITextField * accountNumber = [[UITextField alloc] initWithFrame:Rect(14 * ScaleModel, 0, rightview.width - 28 * ScaleModel, 30)];
    accountNumber.textColor = [UIColor whiteColor];
    accountNumber.centerY = rightview.centerY;
    accountNumber.font = [UIFont systemFontOfSize:15 * ScaleModel];
    accountNumber.placeholder = @"请输入登录账号";
    accountNumber.clearButtonMode = UITextFieldViewModeAlways;
    accountNumber.keyboardType = UIKeyboardTypeEmailAddress;
    [rightview addSubview:accountNumber];
    self.accountNumber = accountNumber;
    
    //密码
    UIView * topView1 = [[UIView alloc] initWithFrame:Rect(40.5 * ScaleModel, 338 * ScaleModel, kScreenWidth - 81 *ScaleModel, 43 * ScaleModel)];
    topView1.backgroundColor = [UIColor clearColor];
    topView1.cornerRadius = 5.0;
    [self addSubview:topView1];
    
    UIView * leftview1 = [[UIView alloc] initWithFrame:Rect(0, 0, 44 * ScaleModel, topView1.height)];
    leftview1.backgroundColor = [UIColor blackColor];
    [topView1 addSubview:leftview1];
    
    UIImageView * personImage1 = [[UIImageView alloc] initWithFrame:Rect(0, 0, 19 * ScaleModel, 22 * ScaleModel)];
    personImage1.image = [UIImage imageNamed:@"login_password"];
    personImage1.centerX = leftview1.width/2;
    personImage1.centerY = leftview1.height/2;
    [leftview1 addSubview:personImage1];
    
    UIView * rightview1 = [[UIView alloc] initWithFrame:Rect(leftview1.width, 0, topView1.width - leftview1.width, topView1.height)];
    rightview1.backgroundColor = [UIColor colorWithHexString:@"424242"];
    [topView1 addSubview:rightview1];
    
    UITextField * passwordNew = [[UITextField alloc] initWithFrame:Rect(14 * ScaleModel, 0, rightview1.width - 28 * ScaleModel, 30)];
    passwordNew.textColor = [UIColor whiteColor];
    passwordNew.centerY = rightview1.centerY;
    passwordNew.font = [UIFont systemFontOfSize:15 * ScaleModel];
    passwordNew.placeholder = @"请输入登录密码";
    passwordNew.clearButtonMode = UITextFieldViewModeAlways;
    passwordNew.keyboardType = UIKeyboardTypeEmailAddress;
    passwordNew.secureTextEntry = YES;
    passwordNew.delegate = self;
    passwordNew.returnKeyType = UIReturnKeyJoin;
    [rightview1 addSubview:passwordNew];
    self.passwordNew = passwordNew;
    //自动登录
    UIButton * selfmotionbut = [[UIButton alloc] initWithFrame:Rect(topView.origin.x + leftview.width/2, topView1.endY + 15.5 * ScaleModel, 15.5 * ScaleModel, 15.5 * ScaleModel)];
    [selfmotionbut setImage:[UIImage imageNamed:@"login_gou_normal"] forState:UIControlStateNormal];
    [selfmotionbut setImage:[UIImage imageNamed:@"login_gou_select"] forState:UIControlStateSelected];
    [selfmotionbut addTarget:self action:@selector(chooseAc:)];
    selfmotionbut.selected = YES;
    [self addSubview:selfmotionbut];
    self.chooseBut = selfmotionbut;
    
    UILabel * zidongdenglu = [[UILabel alloc] initWithFrame:Rect(selfmotionbut.endX + 10 * ScaleModel, 0, 100, 30)];
    zidongdenglu.centerY = selfmotionbut.centerY;
    zidongdenglu.font = [UIFont systemFontOfSize:14 * ScaleModel];
    zidongdenglu.text = @"自动登录";
    zidongdenglu.textColor = [UIColor whiteColor];
    [self addSubview:zidongdenglu];
    
    UIButton * choose = [[UIButton alloc] initWithFrame:zidongdenglu.frame];
    [choose addTarget:self action:@selector(chooseAc:)];
    choose.selected = YES;
    [self addSubview:choose];
    self.chooseBut1 = choose;
    //登陆
    UIButton * loginbut = [[UIButton alloc] initWithFrame:Rect(topView.origin.x, topView1.endY + 77.5 * ScaleModel, topView.width, topView.height)];
    loginbut.title = @"登录";
    loginbut.titleFont = 15 * ScaleModel;
    loginbut.cornerRadius = 5.0;
    loginbut.backgroundColor = [UIColor colorWithHexString:@"c9383a"];
    [loginbut addTarget:self action:@selector(loginAc)];
    [self addSubview:loginbut];
    
    //label
    UILabel * label = [[UILabel alloc] initWithFrame:Rect(0, 0, kScreenWidth, 30)];
    label.centerY = kScreenHeigth - 16 * ScaleModel - label.height/2;
    label.centerX = kScreenWidth/2;
    label.font = [UIFont systemFontOfSize:12.5 * ScaleModel];
    label.textColor = [UIColor colorWithHexString:@"737373"];
    label.text = @"若需申请开通账号、找回密码请联系管理员";
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
}
- (void)chooseAc:(UIButton *)button
{
    if (button.selected == NO) {
        button.selected = YES;
        self.chooseBut.selected = YES;
        self.chooseBut1.selected = YES;
    } else {
        button.selected = NO;
        self.chooseBut.selected = NO;
        self.chooseBut1.selected = NO;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType==UIReturnKeyJoin) {
        [self endEditing:YES];
        [self loginAc];
    }
    return YES;
}
- (void)loginAc
{
    if (self.accountNumber.text.length == 0) {
        SVShowError(@"请输入帐号");
        return;
    }
    if (self.passwordNew.text.length == 0) {
        SVShowError(@"请输入密码");
        return;
    }
    NSString * url = @"login.jsp";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"logincode"] = self.accountNumber.text;
    params[@"password"] = self.passwordNew.text;
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"data"] count] > 0) {
            if (self.chooseBut.selected == YES || self.chooseBut1.selected == YES) {//勾选之后保存用户信息
                [[User sharedUser] storeUserInfo:request[@"data"]];
                [User sharedUser].jumpflag = 1;
            }else {
                [User sharedUser].userInfo = [NSMutableDictionary dictionaryWithDictionary:request[@"data"]];
                [User sharedUser].jumpflag = 0;
            }
            [User sharedUser].login = YES;
            if ([_delegate respondsToSelector:@selector(loginSucc)]) {
                [_delegate loginSucc];
            }
        }else {
            SVShowError(request[@"err"]);
        }
        
    } failBlock:^(NSError *error) {
        
    }];
}
@end
