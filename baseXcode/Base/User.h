//
//  User.h
//  XiaoAHelp
//
//  Created by hangshao on 16/7/11.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, assign, getter=isLogin) BOOL login;//是否登录
@property (nonatomic, assign, getter=isQiandao) BOOL qiandao;//是否签到
@property (nonatomic, assign, getter=isShowChoose) BOOL showChoose;//是否显示首页选择地址
@property (nonatomic, assign, getter=isShowSystemMessage) BOOL showSystemMessage;//是否接收系统消息
@property (nonatomic, assign, getter=isShowOrderMessage) BOOL showOrderMessage;//是否接收订单消息
@property (nonatomic, assign, getter=isHaveNewMessage) BOOL haveNewMessage;//是否有新消息
@property (nonatomic, assign, getter=isHaveNewPunlic) BOOL haveNewPunlic;//是否有新公告
@property (nonatomic, assign, getter=isBinding) BOOL binding;//是否绑定物业
@property (nonatomic, assign, getter=isOpenDoor) BOOL openDoor;//是否开启门襟
@property (nonatomic, assign, getter=isNoPay) BOOL noPay;//是否有未支付订单
@property (nonatomic, assign, getter=isGetGoodsAddress) BOOL getGoodsAddress;//是否选择收货地址
//@property (nonatomic,   assign) NSInteger  jumpFlag;//购物车结算跳地址
@property (nonatomic, assign, getter=isNewVersion) BOOL newVersion;//是否最新版本
@property (nonatomic, assign, getter=isThirdPartyLogin) BOOL thirdPartyLogin;//是否是第三方登录
@property (nonatomic, strong) NSMutableDictionary * userInfo;//用户信息
@property (nonatomic,strong) NSMutableDictionary * locationDic;//定位信息
@property (nonatomic,   assign) NSInteger   jumpflag;//1保存信息   0不保存
@property (nonatomic,   strong) NSMutableArray     * styleArray;//业务类型数组
@property (nonatomic,   strong) NSString     * uuidStr;//手机标示
@property (nonatomic,   strong) NSString     * topAddress;//中间的地址
@property (nonatomic,   strong) NSString     * cpcodeStr;//小区编码
@property (nonatomic, assign) NSInteger urlFlag;//0正常 1不正常
@property (nonatomic,   copy) NSString * isShowAppStore;
@property (nonatomic,   strong) NSString     * uniqueUuid;
@property (nonatomic,   strong) NSString     * userPhoneName;
@property (nonatomic,   strong) NSString     * deviceName;
@property (nonatomic,   strong) NSString     * phoneVersion;
@property (nonatomic,   strong) NSString     * phoneModel;
@property (nonatomic,   strong) NSString     * appCurVersion;
@property (nonatomic,   strong) NSString     * appCurVersionNum;
@property (nonatomic,   strong) NSString     * showMidLoading;
@property (nonatomic,   strong) NSString     * h5Urlstring;//统计的url
@property (nonatomic,   strong) NSString     * h5Title;//统计的头title
@property (nonatomic,   assign) NSInteger   h5flag;//是否点击首页
@property (nonatomic,   assign) NSInteger   goflag;//是否第一次进入
@property (nonatomic,   assign) NSInteger   refreshFlag;//1首页  2管理  3统计
@property (nonatomic,   assign) NSInteger  passTT;
@property (nonatomic,   assign) NSInteger  stopView;
@property (nonatomic,   assign) NSInteger  netFlag;//0  1
@property (nonatomic,   assign) BOOL stopLoading;
///  是否需要刷新购物车数据，
@property (nonatomic, assign, getter=isNeedRefreshCart) BOOL needRefreshCart;

+ (instancetype)sharedUser;

/// 支付完成时，是否需要回调
@property (nonatomic, assign, getter=isNeedRefreshBackground) BOOL needRefreshBackground;

/**
 *  保存用户信息
 *
 *  @param userInfo 用户信息字典
 *
 *  @return 是否保存成功
 */
+ (BOOL)saveUserInfomation:(NSDictionary *)userInfo;

///  从沙盒中获取用户信息
///
///  @return 用户字典或nil
+ (NSDictionary *)getUserInfomation;
- (NSDictionary *)getUserInfo;
- (void)removeUserInfo;
- (NSMutableAttributedString *)getAttributedString:(NSString *)str;//文字加下划线
/**
 *  删除用户信息
 *
 *  @return 是否删除成功
 */
+ (BOOL)removeUserInfomation;
/**
 *  移除userDefaults key对应的object
 *
 *  @param key key
 */
+ (void)removeUseDefaultsForKey:(NSString *)key;
/**
 *  移除userDefaults keys对应的objects
 *
 *  @param keysArray 传入数组，里面存放key
 */
+ (void)removeUseDefaultsForKeys:(NSArray *)keysArray;

- (void)storeUserInfo:(NSDictionary *)dic;

- (void)getPhoneMessage;//获取手机信息

- (void)callUp:(NSString *)phoneStr;//打电话
- (void)getVerson;//获取版本号
//获取当前年月日
- (NSString *)getNowTimeHaveHM;
- (NSString *)getNowTimeEnglish;
- (NSString *)getNowTime;
- (NSString *)getNowDay;//星期几
- (NSString *)getdeviceVersion;
@end
