//
//  User.m
//  XiaoAHelp
//
//  Created by hangshao on 16/7/11.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "User.h"
#import "sys/utsname.h"
#import "AFHTTPSessionManager.h"
static User * _user = nil;

@implementation User

+ (instancetype)sharedUser
{
    if (_user == nil) {
        _user = [[self alloc] init];
    }
    return _user;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [super allocWithZone:zone];
    });
    return _user;
}

+ (BOOL)saveUserInfomation:(NSDictionary *)userInfo {
    
    if (!userInfo) return NO;
    
    NSMutableDictionary * userInfoDict = [NSMutableDictionary dictionary];
    for (NSString *key in [userInfo allKeys]) {
        id storeItem = userInfo[key];
        if ([storeItem isKindOfClass:[NSString class]] ) {
            [userInfoDict setObject:storeItem forKey:key];
        } else if ([storeItem isKindOfClass:[NSNumber class]]){
            [userInfoDict setObject:[(NSNumber *)storeItem stringValue] forKey:key];
        } else if ([storeItem isKindOfClass:[NSNull class]]){
            [userInfoDict setObject:@"" forKey:key];
        } else {
            [userInfoDict setObject:storeItem forKey:key];
        }
    }
    
    // 沙盒路径
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.plist"];
    // 是否保存成功
    
    [User sharedUser].userInfo = [NSMutableDictionary dictionaryWithDictionary:userInfoDict];
    
    return [userInfoDict writeToFile:path atomically:YES];
}

+ (NSDictionary *)getUserInfomation
{
    // 沙盒路径
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

+ (BOOL)removeUserInfomation {
    
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.plist"];
    
    NSFileManager * manager = [NSFileManager defaultManager];
    
    // 判断文件路径是否存在
    if (![manager fileExistsAtPath:path]) {
        return NO;
    }
    
    // 删除文件
    return [manager removeItemAtPath:path error:nil];
}

+ (void)removeUseDefaultsForKey:(NSString *)key {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeUseDefaultsForKeys:(NSArray *)keysArray {
    
    for (NSString * key in keysArray) {
        [self removeUseDefaultsForKey:key];
    }
}
- (void)storeUserInfo:(NSDictionary *)dic
{
    [User sharedUser].userInfo = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSMutableArray * array = [NSMutableArray arrayWithObject:dic];
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths objectAtIndex:0];
    NSString * filePath = [documentDirectory stringByAppendingPathComponent:@"UserData.plist"];
    [array writeToFile:filePath atomically:YES];
}
- (NSDictionary *)getUserInfo
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDictory = [paths objectAtIndex:0];
    NSString * userDataPath = [documentDictory stringByAppendingPathComponent:@"UserData.plist"];
    NSMutableArray * array = [NSMutableArray arrayWithContentsOfFile:userDataPath];
    [User sharedUser].userInfo = [NSMutableDictionary dictionaryWithDictionary:array[0]];
    return [NSMutableDictionary dictionaryWithDictionary:array[0]];
}
- (void)removeUserInfo{
    [User sharedUser].userInfo = [NSMutableDictionary dictionary];
    NSMutableArray * array = [NSMutableArray arrayWithObject:[User sharedUser].userInfo];
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths objectAtIndex:0];
    NSString * filePath = [documentDirectory stringByAppendingPathComponent:@"UserData.plist"];
    [array writeToFile:filePath atomically:YES];
}
- (NSMutableAttributedString *)getAttributedString:(NSString *)str
{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    return content;
}

- (void)getPhoneMessage
{
    CFUUIDRef  uuid = CFUUIDCreate(NULL);
    //assert(uuid);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    NSString * uniqueUuid = [NSString stringWithFormat:@"%@",uuidStr];
    self.uniqueUuid = uniqueUuid;
    //设备唯一标识符
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    self.uuidStr = identifierStr;
    NSLog(@"设备唯一标识符:%@",identifierStr);
    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    self.userPhoneName = userPhoneName;
    NSLog(@"手机别名: %@", userPhoneName);
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    self.deviceName = deviceName;
//    NSLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    self.phoneVersion = phoneVersion;
    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString * phoneModel =  [self deviceVersion];
    self.phoneModel = phoneModel;
    NSLog(@"手机型号:%@",phoneModel);
    //地方型号  （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSLog(@"国际化区域名称: %@",localPhoneModel );
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.appCurVersion = appCurVersion;
//    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    self.appCurVersionNum = appCurVersionNum;
//    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSLog(@"物理尺寸:%.0f × %.0f",width,height);
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    NSLog(@"分辨率是:%.0f × %.0f",width*scale_screen ,height*scale_screen);
    [self getPhoneDatawith:identifierStr and:phoneModel and:@"IOS" and:phoneVersion];
}
- (void)getPhoneDatawith:(NSString *)devicetoken and:(NSString *)model and:(NSString *)froms and:(NSString *)version
{
//    [[NSUserDefaults standardUserDefaults] setObject:devicetoken forKey:@"devicetoken"];
//    NSString * url = @"devicetoken.jsp";
//    
//    NSMutableDictionary * params = [NSMutableDictionary dictionary];
//    params[@"devicetoken"] = devicetoken;
//    params[@"model"] = model;
//    params[@"version"] = version;
//    params[@"fromos"] = froms;
//    params[@"clerkid"] = userClerkid;
//    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
//        if ([request[@"flag"] integerValue] == 0) {
//            TSLog(@"succ");
//        }else {
//            TSLog(request[@"err"]);
//        }
//    } failBlock:^(NSError *error) {
//        TSLog(@"err");
//    }];
}
- (NSString *)getdeviceVersion
{
    return [self deviceVersion];
}
- (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    　return deviceString;
}
- (void)callUp:(NSString *)phoneStr
{
    [TSGlobalTool alertWithTitle:[NSString stringWithFormat:@"%@%@",@"是否拨打",phoneStr] message:nil cancelButtonTitle:@"否" OtherButtonsArray:@[@"是"] clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneStr]]];
        }
    }];
}
- (void)getVerson
{
//    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    [self judgeAPPVersion];
}
-(void)judgeAPPVersion
{
    NSString *urlStr = @"https://itunes.apple.com/lookup?id=1188527469";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:req delegate:self];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *appInfo = (NSDictionary *)jsonObject;
    NSArray *infoContent = [appInfo objectForKey:@"results"];
    if (infoContent.count == 0) {
        return;
    }
    NSString *version = [[infoContent objectAtIndex:0] objectForKey:@"version"];
    
    NSLog(@"商店的版本是 %@",version);
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前的版本是 %@",currentVersion);
    
    
    if (![version isEqualToString:currentVersion]) {
        [User sharedUser].newVersion = YES;
    } else {
        [User sharedUser].newVersion = NO;
    }
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"curversion"] = currentVersion;
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://wy.cqtianjiao.com/guanjia/sincere/iosversion.jsp" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * obj = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];//字符串json转字典
        NSError * err;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        if ([dic[@"flag"] integerValue] == 0) {
            if ([dic[@"data"][@"version"] floatValue] > 8) {
                [TSGlobalTool alertWithTitle:@"提示" message:[NSString stringWithFormat:@"%@,%@",dic[@"data"][@"versionname"],dic[@"data"][@"versiondesc"]] cancelButtonTitle:@"我知道了" OtherButtonsArray:@[@"前往更新"] clickAtIndex:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dic[@"data"][@"versionurl"]]];
                    } else {
                        
                    }
                }];
            }
        }else {
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        TSLog(error);
    }];
}
- (NSString *)getNowTime
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString * year = [dateString substringWithRange:NSMakeRange(0, 4)];
    NSString * month = [dateString substringWithRange:NSMakeRange(4, 2)];
    NSString * day = [dateString substringWithRange:NSMakeRange(6, 2)];
    return [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
}
- (NSString *)getNowTimeEnglish
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString * year = [dateString substringWithRange:NSMakeRange(0, 4)];
    NSString * month = [dateString substringWithRange:NSMakeRange(4, 2)];
    NSString * day = [dateString substringWithRange:NSMakeRange(6, 2)];
    return [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
}
- (NSString *)getNowTimeHaveHM
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddHHmm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString * year = [dateString substringWithRange:NSMakeRange(0, 4)];
    NSString * month = [dateString substringWithRange:NSMakeRange(4, 2)];
    NSString * day = [dateString substringWithRange:NSMakeRange(6, 2)];
    NSString * hour = [dateString substringWithRange:NSMakeRange(8, 2)];
    NSString * minut = [dateString substringWithRange:NSMakeRange(10, 2)];
    return [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minut];
}
- (NSString *)getNowDay
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    return [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:[comps weekday] - 1]]];
}
@end
