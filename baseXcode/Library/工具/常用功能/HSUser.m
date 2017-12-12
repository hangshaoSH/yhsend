//
//  HSUser.m
//  baseXcode
//
//  Created by hangshao on 16/10/31.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "HSUser.h"
#import "sys/utsname.h"
static HSUser * _hsUser = nil;

@implementation HSUser

+ (instancetype)sharedUser
{
    if (_hsUser == nil) {
        _hsUser = [[self alloc] init];
    }
    return _hsUser;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _hsUser = [super allocWithZone:zone];
    });
    return _hsUser;
}
- (NSMutableAttributedString *)setLowLineAttributedString:(NSString *)str
{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    return content;
}
- (NSMutableAttributedString *)attributedstringWithText:(NSString *)text
                                                 range1:(NSRange)range1
                                                  font1:(CGFloat)font1
                                                 color1:(UIColor *)color1
                                                 range2:(NSRange)range2
                                                  font2:(CGFloat)font2
                                                 color2:(UIColor *)color2
{
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:text];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font1] range:range1];
    [attr addAttribute:NSForegroundColorAttributeName value:color1 range:range1];
    
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font2] range:range2];
    [attr addAttribute:NSForegroundColorAttributeName value:color2 range:range2];
    return attr;
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
    NSLog(@"手机别名: %@", userPhoneName);
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    self.deviceName = deviceName;
    //NSLog(@"设备名称: %@",deviceName );
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
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSLog(@"物理尺寸:%.0f × %.0f",width,height);
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    NSLog(@"分辨率是:%.0f × %.0f",width*scale_screen ,height*scale_screen);
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
-(void)getVersonWithAppId:(NSString *)appID
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",@"https://itunes.apple.com/lookup?id=",appID];
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
    NSString *version = [[infoContent objectAtIndex:0] objectForKey:@"version"];
    
    NSLog(@"商店的版本是 %@",version);
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前的版本是 %@",currentVersion);
    
    
    if (![version isEqualToString:currentVersion]) {
        self.appNewCurVersion = version;
    } else {
        self.appOldCurVersion = currentVersion;
    }
    
}
- (void)removeUseDefaultsForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setUseDefaultsForKey:(NSString *)key object:(NSString *)object
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
}
- (void)setUseDefaultsForKey:(NSString *)key objectArray:(NSArray *)objectArray
{
    for (int i = 0; i < objectArray.count; i ++) {
        [[NSUserDefaults standardUserDefaults] setObject:objectArray[i] forKey:key];
    }
}
- (void)removeUseDefaultsForKeys:(NSArray *)keysArray {
    
    for (NSString * key in keysArray) {
        [self removeUseDefaultsForKey:key];
    }
}
- (BOOL)saveUserInfomation:(NSDictionary *)userInfo {
    
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
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HSUserInfo.plist"];
    // 是否保存成功
    [HSUser sharedUser].userInfo = [NSMutableDictionary dictionaryWithDictionary:userInfoDict];
    return [userInfoDict writeToFile:path atomically:YES];
}

- (NSDictionary *)getUserInfomation
{
    // 沙盒路径
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HSUserInfo.plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

- (BOOL)removeUserInfomation {
    
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HSUserInfo.plist"];
    NSFileManager * manager = [NSFileManager defaultManager];
    // 判断文件路径是否存在
    if (![manager fileExistsAtPath:path]) {
        return NO;
    }
    // 删除文件
    return [manager removeItemAtPath:path error:nil];
}
/////abouttime
+ (NSString *)steNowTimeToString
{
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}
+ (NSString *)steYourTimeToString:(NSString *)yourStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:yourStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}
+ (NSString *)steYourTimeFromDate:(NSDate *)yourdate
{
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[yourdate timeIntervalSince1970]];
    return timeSp;
}
+ (NSDate *)setYouStringToDate:(NSString *)youStr
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(long)[youStr doubleValue]];
    return confromTimesp;
}
+ (NSString *)setYouStringToStr:(NSString *)youStr
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(long)[youStr doubleValue]];
    NSString * string = [formatter stringFromDate:confromTimesp];
    return string;
}
@end
