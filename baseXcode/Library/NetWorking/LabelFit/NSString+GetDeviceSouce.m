//
//  NSString+GetDeviceSouce.m
//  ILiveForiOS
//
//  Created by 于小水 on 15/12/12.
//  Copyright (c) 2015年 于欢. All rights reserved.
//

#import "NSString+GetDeviceSouce.h"
#import <sys/utsname.h>
@implementation NSString (GetDeviceSouce)
//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
//
//    NSArray *modelArray = @[
//
//                            @"i386", @"x86_64",
//
//                            @"iPhone1,1",
//                            @"iPhone1,2",
//                            @"iPhone2,1",
//                            @"iPhone3,1",
//                            @"iPhone3,2",
//                            @"iPhone3,3",
//                            @"iPhone4,1",
//                            @"iPhone5,1",
//                            @"iPhone5,2",
//                            @"iPhone5,3",
//                            @"iPhone5,4",
//                            @"iPhone6,1",
//                            @"iPhone6,2",
//
//                            @"iPod1,1",
//                            @"iPod2,1",
//                            @"iPod3,1",
//                            @"iPod4,1",
//                            @"iPod5,1",
//
//                            @"iPad1,1",
//                            @"iPad2,1",
//                            @"iPad2,2",
//                            @"iPad2,3",
//                            @"iPad2,4",
//                            @"iPad3,1",
//                            @"iPad3,2",
//                            @"iPad3,3",
//                            @"iPad3,4",
//                            @"iPad3,5",
//                            @"iPad3,6",
//
//                            @"iPad2,5",
//                            @"iPad2,6",
//                            @"iPad2,7",
//                            ];
//    NSArray *modelNameArray = @[
//
//                                @"iPhone Simulator", @"iPhone Simulator",
//
//                                @"iPhone 2G",
//                                @"iPhone 3G",
//                                @"iPhone 3GS",
//                                @"iPhone 4(GSM)",
//                                @"iPhone 4(GSM Rev A)",
//                                @"iPhone 4(CDMA)",
//                                @"iPhone 4S",
//                                @"iPhone 5(GSM)",
//                                @"iPhone 5(GSM+CDMA)",
//                                @"iPhone 5c(GSM)",
//                                @"iPhone 5c(Global)",
//                                @"iphone 5s(GSM)",
//                                @"iphone 5s(Global)",
//
//                                @"iPod Touch 1G",
//                                @"iPod Touch 2G",
//                                @"iPod Touch 3G",
//                                @"iPod Touch 4G",
//                                @"iPod Touch 5G",
//
//                                @"iPad",
//                                @"iPad 2(WiFi)",
//                                @"iPad 2(GSM)",
//                                @"iPad 2(CDMA)",
//                                @"iPad 2(WiFi + New Chip)",
//                                @"iPad 3(WiFi)",
//                                @"iPad 3(GSM+CDMA)",
//                                @"iPad 3(GSM)",
//                                @"iPad 4(WiFi)",
//                                @"iPad 4(GSM)",
//                                @"iPad 4(GSM+CDMA)",
//
//                                @"iPad mini (WiFi)",
//                                @"iPad mini (GSM)",
//                                @"ipad mini (GSM+CDMA)"
//                                ];
//    NSInteger modelIndex = - 1;
//    NSString *modelNameString = nil;
//    modelIndex = [modelArray indexOfObject:deviceString];
//    if (modelIndex >= 0 && modelIndex < [modelNameArray count]) {
//        modelNameString = [modelNameArray objectAtIndex:modelIndex];
//    }
//
//
//    NSLog(@"----设备类型---%@",modelNameString);
//    return modelNameString;
    NSLog(@"name: %@", [[UIDevice currentDevice] name]);
    NSLog(@"systemName: %@", [[UIDevice currentDevice] systemName]);
    NSLog(@"systemVersion: %@", [[UIDevice currentDevice] systemVersion]);
    NSLog(@"model: %@", [[UIDevice currentDevice] model]);
    NSLog(@"localizedModel: %@", [[UIDevice currentDevice] localizedModel]);

    return [[UIDevice currentDevice] model];
}
+(NSString *)getCurrentDeviceVersion{
//    //    IOS-获取Model（设备型号）、Version（设备版本号）、app（程序版本号）等
//    NSLog(@"name: %@", [[UIDevice currentDevice] name]);
//    NSLog(@"systemName: %@", [[UIDevice currentDevice] systemName]);
//    NSLog(@"systemVersion: %@", [[UIDevice currentDevice] systemVersion]);
//    NSLog(@"model: %@", [[UIDevice currentDevice] model]);
//    NSLog(@"localizedModel: %@", [[UIDevice currentDevice] localizedModel]);

//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//
//    CFShow((__bridge CFTypeRef)(infoDictionary));

//    // app名称
//    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    // app build版本
//    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];

    return [[UIDevice currentDevice] systemVersion];
}
+(NSString *)getCurrentAppVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    return app_Version;
}
@end
