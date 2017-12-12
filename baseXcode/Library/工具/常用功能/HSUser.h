//
//  HSUser.h
//  baseXcode
//
//  Created by hangshao on 16/10/31.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSUser : NSObject
///手机相关
@property (nonatomic,   strong) NSString     * uuidStr;//手机标示
@property (nonatomic,   strong) NSString     * uniqueUuid;//设备唯一标识符
@property (nonatomic,   strong) NSString     * userPhoneName;//手机别名： 用户定义的名称
@property (nonatomic,   strong) NSString     * deviceName;//设备名称
@property (nonatomic,   strong) NSString     * phoneVersion;//手机系统版本
@property (nonatomic,   strong) NSString     * phoneModel;//手机型号
@property (nonatomic,   strong) NSString     * appNewCurVersion;//app新版本号
@property (nonatomic,   strong) NSString     * appOldCurVersion;//app当前版本号

///HSUserInfo
+ (instancetype)sharedUser;
@property (nonatomic, strong) NSMutableDictionary * userInfo;//存用户信息


- (NSMutableAttributedString *)setLowLineAttributedString:(NSString *)str;//文字加下划线
- (NSMutableAttributedString *)attributedstringWithText:(NSString *)text//设置颜色字体
                                                 range1:(NSRange)range1
                                                  font1:(CGFloat)font1
                                                 color1:(UIColor *)color1
                                                 range2:(NSRange)range2
                                                  font2:(CGFloat)font2
                                                 color2:(UIColor *)color2

;
- (void)getPhoneMessage;//获取手机信息
- (void)callUp:(NSString *)phoneStr;//打电话
- (void)getVersonWithAppId:(NSString *)appID;//传入appID
/**
 *  保存用户信息
 *  @param userInfo 用户信息字典
 *  @return 是否保存成功
 */
- (BOOL)saveUserInfomation:(NSDictionary *)userInfo;
///  从沙盒中获取用户信息
///  @return 用户字典或nil
- (NSDictionary *)getUserInfomation;
/**
 *  删除用户信息
 *  @return 是否删除成功
 */
- (BOOL)removeUserInfomation;
/**
 *  移除userDefaults key对应的object
 *  @param key key
 */
- (void)setUseDefaultsForKey:(NSString *)key object:(NSString *)object;
- (void)removeUseDefaultsForKey:(NSString *)key;
/**
 *  移除userDefaults keys对应的objects
 */
- (void)setUseDefaultsForKey:(NSString *)key objectArray:(NSArray *)objectArray;
- (void)removeUseDefaultsForKeys:(NSArray *)keysArray;

//////时间相关
//当前时间转时间戳
+ (NSString *)steNowTimeToString;
//传入时间转时间戳YYYY-MM-dd HH:mm:ss
+ (NSString *)steYourTimeToString:(NSString *)yourStr;
+ (NSString *)steYourTimeFromDate:(NSDate *)yourdate;
//时间戳转时间
+ (NSDate *)setYouStringToDate:(NSString *)youStr;
+ (NSString *)setYouStringToStr:(NSString *)youStr;
@end
