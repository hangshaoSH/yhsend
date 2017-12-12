//
//  AppDelegate.m
//  baseXcode
//
//  Created by hangshao on 16/10/16.
//  Copyright © 2016年 hangshao. All rights reserved.
//
#import "AppDelegate.h"
#import "MainViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "BaiduMobStat.h"
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [BaiduMobStat defaultStat].enableDebugOn = YES;
    [[BaiduMobStat defaultStat] startWithAppId:@"9ab400a934"];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[[User sharedUser] getUserInfo]];
    if ([dic count] > 0) {
        [User sharedUser].login = YES;
        [User sharedUser].jumpflag = 1;
    } else {
        [User sharedUser].login = NO;
        [User sharedUser].jumpflag = 0;
    }
    [User sharedUser].h5Urlstring = @"http://wy.cqtianjiao.com/guanjia/sincere/web/stattoday.jsp";
    [User sharedUser].h5Title = @"今日统计";
    [[User sharedUser] getPhoneMessage];
    [[User sharedUser] getVerson];
    //注册推送代码
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                TSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    TSLog(settings);
                }];
            } else {
                // 点击不允许
                TSLog(@"注册失败");
            }
        }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
        //iOS8 - iOS10
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        //iOS8系统以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self window];
    [self.window makeKeyAndVisible];
    return YES;
}
-(UIWindow *)window
{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:kScreenBounds];
        _window.rootViewController = [MainViewController new];
    }
    return _window;
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    TSLog(error);
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *str=[NSString stringWithFormat:@"%@",deviceToken];
    
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *str2=[str1 stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
    NSString *devicStr=[str2 stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:devicStr forKey:@"devicetoken"];
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    TSLog(devicStr);
    TSLog(@"走推送代理了－－－－－－－－－－－－");
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"devicetoken"] = devicStr;
    params[@"model"] = [[User sharedUser] getdeviceVersion];
    params[@"version"] = phoneVersion;
    params[@"fromos"] = @"ios";
    params[@"clerkid"] = userClerkid;
    NSString * url = @"devicetoken.jsp";
    
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            TSLog(@"初次上传succ............");
        }else {
            TSLog(request[@"err"]);
        }
    } failBlock:^(NSError *error) {
        TSLog(@"推送err.............");
    }];
}
#pragma -mark 推送
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    if ([[User sharedUser].userInfo[@"ispush"] integerValue] == 0) {
//        return;
    }
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    //功能：可设置是否在应用内弹出通知
    completionHandler(UNNotificationPresentationOptionAlert);
    //    NSDictionary * userInfo = notification.request.content.userInfo;
    //    UNNotificationRequest *request = notification.request; // 收到推送的请求
    //    UNNotificationContent *content = request.content; // 收到推送的消息内容
    //    NSNumber *badge = content.badge; // 推送消息的角标
    //    NSString *body = content.body; // 推送消息体
    //    UNNotificationSound *sound = content.sound; // 推送消息的声音
    //    NSString *subtitle = content.subtitle; // 推送消息的副标题
    //    NSString *title = content.title; // 推送消息的标题
    //    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    //        TSLog(@"iOS  tui  song");
    //    }
    //    else {
    //        // 判断为本地通知
    //    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    if ([[User sharedUser].userInfo[@"ispush"] integerValue] == 0) {
//        return;
    }
    TSLog(@"走推送消息－－－－－－－－－－－－");
    //    NSDictionary * userInfo = response.notification.request.content.userInfo;
    //    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    //    UNNotificationContent *content = request.content; // 收到推送的消息内容
    //    NSNumber *badge = content.badge; // 推送消息的角标
    //    NSString *body = content.body; // 推送消息体
    //    UNNotificationSound *sound = content.sound; // 推送消息的声音
    //    NSString *subtitle = content.subtitle; // 推送消息的副标题
    //    NSString *title = content.title; // 推送消息的标题
    //    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    //        TSLog(@"iOS10....");
    //    }
    //    else {
    //        // 判断为本地通知
    //    }
    completionHandler(); // 系统要求执行这个方法
}
#pragma mark - app开启时的推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    if ([[User sharedUser].userInfo[@"ispush"] integerValue] == 0) {
//        return;
    }
    [application setApplicationIconBadgeNumber:0];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if ([[User sharedUser].userInfo[@"ispush"] integerValue] == 0) {
//        return;
    }
    NSDictionary *apsDic=[userInfo objectForKey:@"aps"];
    NSString *alert = [apsDic objectForKey:@"alert"];
    NSDictionary *paramDic=[apsDic objectForKey:@"param"];
    TSLog(paramDic);
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:alert delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"重新登录", nil];
        [alertView show];
    }
    [application setApplicationIconBadgeNumber:0];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    TSLog(@"houtai");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    TSLog(@"qiantai");

    NSString * name = [NSString string];
    if ([User sharedUser].refreshFlag == 2) {
        name = @"refreshmanager";
    }else
    if ([User sharedUser].refreshFlag == 3) {
        name = @"refreshtongji";
    }else{
        name = @"refreshhome";
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:nil];
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    if ([User sharedUser].jumpflag == 1) {
        
    } else {
        [[User sharedUser] removeUserInfo];
    }
}

@end
