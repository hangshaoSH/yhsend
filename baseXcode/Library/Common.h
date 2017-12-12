//
//  ForFans
//
//  Created by Seven Lv on 15/10/18.
//  Copyright (c) 2015年 Seven Lv. All rights reserved.
//  定义各种宏

#ifndef ForFans_Common_h
#define ForFans_Common_h

#define Percent kScreenHeigth / 667


#define RGBColor(r, g, b)  [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]
#define RGBColor2(r, g, b, a)  [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]

#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenHeigth [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define SafeAreaBottomHeight (kScreenHeigth == 812.0 ? 34 : 0)
#define SafeAreaTopHeight (kScreenHeigth == 812.0 ? 24 : 0)
#define User_is_login [User sharedUser].isLogin
#define USER [User sharedUser]
#define UserData [User sharedUser].userInfo


#define SVShowError(message) [SVProgressHUD showError:(message)]
#define SVShowSuccess(message)[SVProgressHUD showSuccess:(message)]
#define SLFail SVShowError(@"网络连接失败");
#define ThemeOrangeColor RGBColor(253, 158 , 40)

#define WeakSelf __weak typeof(self) wself = self;

#define userClerkid [User sharedUser].userInfo[@"clerkid"];

// 背景颜色
#define BackgroundGrayColor [UIColor colorWithHexString:@"f1f1f1"];
#define TopBgColor  [UIColor colorWithHexString:@"c9383a"]
#define orangecolor  [UIColor colorWithHexString:@"ff9c00"]
#define orangeElseColor  [UIColor colorWithHexString:@"ffb400"]
#define fiveblueColor [UIColor colorWithHexString:@"57bdb9"]
#define sixblueColor [UIColor colorWithHexString:@"66c1bc"]
#define sevenlightColor [UIColor colorWithHexString:@"727272"]
#define fivelightColor [UIColor colorWithHexString:@"575757"]
#define zeroblackColor [UIColor colorWithHexString:@"010101"]
#define bordercolor [UIColor colorWithHexString:@"d0d0d0"]
#define ScaleModel  kScreenWidth/375

//font  11  12  13  14  15  16  17
#define elevenFont  [UIFont systemFontOfSize:11 * kScreenWidth/375]
#define twelveFont  [UIFont systemFontOfSize:12 * kScreenWidth/375]
#define thirteenFont  [UIFont systemFontOfSize:13 * kScreenWidth/375]
#define fourteenFont  [UIFont systemFontOfSize:14 * kScreenWidth/375]
#define fifteenFont  [UIFont systemFontOfSize:15 * kScreenWidth/375]
#define sixteentFont  [UIFont systemFontOfSize:16 * kScreenWidth/375]
#define seventeenFont  [UIFont systemFontOfSize:17 * kScreenWidth/375]
#define fifteenHelveticaFont [UIFont fontWithName:@"Helvetica-Bold" size:15 * ScaleModel];
#define seventeenHelveticaFont [UIFont fontWithName:@"Helvetica-Bold" size:17 * ScaleModel];
//位置
#define zeroOrigin CGPointMake(0, 0)
#define sixFourOrigin CGPointMake(0, 64)
#define seventeenS [@"相关" getStringRectWithfontSize:16 * ScaleModel width:100]
#define sixteenS [@"相关" getStringRectWithfontSize:17 * ScaleModel width:100]
#define fifteenS [@"相关" getStringRectWithfontSize:15 * ScaleModel width:100]
#define fourteenS [@"相关" getStringRectWithfontSize:14 * ScaleModel width:100]
//APP
#define MYAPP (AppDelegate *)([UIApplication sharedApplication].delegate)

/// CGRect
#define Rect(x, y, w, h) CGRectMake((x), (y), (w), (h))
/// CGSize
//#define Size(w, h) CGSizeMake((w), (h))
/// CGPoint
//#define Point(x, y) CGPointMake((x), (y))

/// 定义没有返回值的block
typedef void (^VoidBlcok)(void);

/// 定义带一个NSDictionary参数的block
///
/// @param dict NSDictionary
typedef void (^DictionaryBlcok)(NSDictionary *dict);

/// 定义带一个array参数的block
///
/// @param array NSArray
typedef void (^ArrayBlcok)(NSArray *array);

/// 定义带一个NSString参数的block
///
/// @param string NSString
typedef void (^StringBlcok)(NSString *string);

#define IfUserIsNotLogin \
if (!User_is_login) { \
    SLLoginViewController * login = [[SLLoginViewController alloc] init]; \
    login.ts_navgationBar = [TSNavigationBar navWithTitle:@"登录" backAction:^{ \
        [login dismissViewControllerAnimated:YES completion:nil]; \
    }]; \
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:login]; \
    nav.navigationBar.hidden = YES; \
    [self presentViewController:nav animated:YES completion:nil]; \
    return; \
}

/// 验证是文字是否输入
///
/// @param __Text    文字长度
/// @param __Message 错误提示
    #define SLVerifyText(__TextLength, __Message)\
    if (!__TextLength) {\
    SVShowError(__Message);\
    return;\
    }

/// 验证手机正则
///
/// @param __Text    文字
/// @param __Message 错误提示
#define SLVerifyPhone(__Phone, __Message)\
if (![__Phone validateMobile]) {\
SVShowError(__Message);\
return;\
}

/// 验证邮箱正则
///
/// @param __Text    文字
/// @param __Message 错误提示
#define SLVerifyEmail(__Email, __Message)\
if (![__Email validateEmail]) {\
SVShowError(__Message);\
return;\
}

/// 验证密码正则
///
/// @param __Text    文字
/// @param __Message 错误提示
#define SLVerifyPassword(__Password, __Message)\
if (![__Password validatePassword]) {\
SVShowError(__Message);\
return;\
}

#define EndRefreshing(__ScrollView)\
if ([__ScrollView.mj_footer isRefreshing]) {\
    [__ScrollView.mj_footer endRefreshing];\
}\
if ([__ScrollView.mj_header isRefreshing]) {\
    [__ScrollView.mj_header endRefreshing];\
}







#endif
