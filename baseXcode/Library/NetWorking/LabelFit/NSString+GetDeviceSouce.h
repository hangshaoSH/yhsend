//
//  NSString+GetDeviceSouce.h
//  ILiveForiOS
//
//  Created by 于小水 on 15/12/12.
//  Copyright (c) 2015年 于欢. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GetDeviceSouce)
//获得设备型号
+ (NSString *)getCurrentDeviceModel;
//获得设备版本
+(NSString *)getCurrentDeviceVersion;
//获得App版本
+(NSString *)getCurrentAppVersion;
@end
