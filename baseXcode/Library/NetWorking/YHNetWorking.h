//
//  YHNetWorking.h
//  网络封装BolckDemo
//
//  Created by ZG-于欢 on 15/10/22.
//  Copyright © 2015年 于欢. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "YHCheckNetworkMananger.h"//单利模型，用来记录当前的网络状态
#import "AFNetworkReachabilityManager.h"//af里面监听网络状态的类
@interface YHNetWorking : AFHTTPRequestOperationManager

/**
 *  @brief 网络请求Get  URL拼接  在plist里面设置 增加baseURL
 *  @param api 域名后的地址 dic 所传参数
 *  @return void
 *  @blocks
 *              success:返回的NSDictionary中包含服务器的response信息，包括图片id（id）,url(url),宽度(width),高度(height)。使用括号中的名称从NSDictionary中获取。
 *              failed:返回error
 *  @warning
 **/
+(void)invokeGetApi:(NSString *)api args:(NSMutableDictionary*)dic Success:(void(^)(id responseDict))success Faild:(void(^)(id error))faild;

/**
 *  @brief 网络请Post URL拼接 在plist里面设置 增加baseURL
 *  @param api 域名后的地址 dic 所传参数
 *  @return void
 *  @blocks
 *              success:返回的NSDictionary中包含服务器的response信息，包括图片id（id）,url(url),宽度(width),高度(height)。使用括号中的名称从NSDictionary中获取。
 *              failed:返回error
 *  @warning
 **/

+(void)invokePostApi:(NSString *)api args:(NSMutableDictionary*)dic Success:(void(^)(id responseDict))success Faild:(void(^)(id error))faild;

/**
 *  @brief 网络请求Get 有加载旋转框 URL拼接 在plist里面设置 增加baseURL
 *  @param api 域名后的地址 dic 所传参数 view 旋转框加载的view loadStr  加载文字
 *  @return void
 *  @blocks
 *              success:返回的NSDictionary中包含服务器的response信息，包括图片id（id）,url(url),宽度(width),高度(height)。使用括号中的名称从NSDictionary中获取。
 *              failed:返回error
 *  @warning
 **/
+(void)invokeGetApi:(NSString *)api args:(NSMutableDictionary*)dic Success:(void(^)(id responseDict))success Faild:(void(^)(id error))faild inLoadView:(UIView *)view AndLoadStr:(NSString *)loadStr;

/**
 *  @brief 网络请求Post 有加载旋转框 URL拼接 在plist里面设置 增加baseURL
 *  @param api 域名后的地址 dic 所传参数 view 旋转框加载的view loadStr  加载文字
 *  @return void
 *  @blocks
 *              success:返回的NSDictionary中包含服务器的response信息，包括图片id（id）,url(url),宽度(width),高度(height)。使用括号中的名称从NSDictionary中获取。
 *              failed:返回error
 *  @warning
 **/
+(void)invokePostApi:(NSString *)api args:(NSMutableDictionary*)dic Success:(void(^)(id responseDict))success Faild:(void(^)(id error))faild inLoadView:(UIView *)view AndLoadStr:(NSString *)loadStr;

/**
 *  @brief 网络请求Get  URL 完整
 *  @param api 域名后的地址 dic 所传参数
 *  @return void
 *  @blocks
 *              success:返回的NSDictionary中包含服务器的response信息，包括图片id（id）,url(url),宽度(width),高度(height)。使用括号中的名称从NSDictionary中获取。
 *              failed:返回error
 *  @warning
 **/
+(void)invokeGetCompleteApi:(NSString *)api args:(NSMutableDictionary*)dic Success:(void(^)(id responseDict))success Faild:(void(^)(id error))faild;

/**
 *  @brief 网络请求Post  URL 完整
 *  @param api 域名后的地址 dic
 *  @return void
 *  @blocks
 *              success:返回的NSDictionary中包含服务器的response信息，包括图片id（id）,url(url),宽度(width),高度(height)。使用括号中的名称从NSDictionary中获取。
 *              failed:返回error
 *  @warning
 **/
+(void)invokePostCompleteApi:(NSString *)api args:(NSMutableDictionary*)dic Success:(void(^)(id responseDict))success Faild:(void(^)(id error))faild;

/**
 *  @brief 网络请求Get 有加载旋转框 URL完整
 *  @param api 域名后的地址 dic 所传参数 view 旋转框加载的view loadStr  加载文字
 *  @return void
 *  @blocks
 *              success:返回的NSDictionary中包含服务器的response信息，包括图片id（id）,url(url),宽度(width),高度(height)。使用括号中的名称从NSDictionary中获取。
 *              failed:返回error
 *  @warning
 **/
+(void)invokeGetCompleteApi:(NSString *)api args:(NSMutableDictionary*)dic Success:(void(^)(id responseDict))success Faild:(void(^)(id error))faild inLoadView:(UIView *)view AndLoadStr:(NSString *)loadStr;

/**
 *  @brief 网络请求Post 有加载旋转框 URL完整
 *  @param api 域名后的地址 dic 所传参数 view 旋转框加载的view loadStr  加载文字
 *  @return void
 *  @blocks
 *              success:返回的NSDictionary中包含服务器的response信息，包括图片id（id）,url(url),宽度(width),高度(height)。使用括号中的名称从NSDictionary中获取。
 *              failed:返回error
 *  @warning
 **/
+(void)invokePostCompletetApi:(NSString *)api args:(NSMutableDictionary*)dic Success:(void(^)(id responseDict))success Faild:(void(^)(id error))faild inLoadView:(UIView *)view AndLoadStr:(NSString *)loadStr;

/**
 *  @brief 中断所有的网络请求
 *  @return void
 **/
+(void)stopAllRequest;

/**
 *  @brief 停止ViewController当前请求
 *  @return void
 **/
+(void)stopTheVcRequset:(UIViewController *)Vc;

/**
 *  @brief 给ViewController请求标注ID
 *  @return void
 **/
+(void)setVcRequestId:(UIViewController *)Vc;

@end
