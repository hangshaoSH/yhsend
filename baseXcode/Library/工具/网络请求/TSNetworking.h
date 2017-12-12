//
//  TSNetworking.h
//
//  Created by Seven on 15/8/29.
//  Copyright (c) 2015年 toocms. All rights reserved.
//  封装AFNetworking

#define API @""
#import <UIKit/UIKit.h>

@interface TSNetworking : NSObject

/**
 *  发送get请求
 *
 *  @param urlString url
 *  @param params    参数
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)GETWithURL:(NSString *)urlString
            params:(NSDictionary *)params
     completeBlock:(void(^)(id request))success
         failBlock:(void(^)(NSError * error))failure __deprecated_msg("Use `用模型包装参数发送get请求`");

/**
 *  发送post请求
 *
 *  @param urlString url
 *  @param params    参数
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)POSTWithURL:(NSString *)urlString
             params:(NSDictionary *)params
      completeBlock:(void(^)(id request))success
          failBlock:(void(^)(NSError * error))failure __deprecated_msg("Use `用模型包装参数发送post请求`");


/**
 *  上传图片
 *
 *  @param urlString  url
 *  @param params     请求参数
 *  @param image      图片(png格式，如果传的其它格式，需要改变mimeType)
 *  @param imageParam 图片对应参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)POSTImageWithURL:(NSString *)urlString
                  params:(NSDictionary *)params
                   image:(UIImage *)image
              imageParam:(NSString *)imageParam
           completeBlock:(void(^)(id request))success
               failBlock:(void(^)(NSError * error))failure __deprecated_msg("Use `用模型包装参数上传图片`");



/**
 *  获取文件的mineType（文件需要在mainBundle中）
 *
 *  @param fileName 文件名（含拓展名）
 *
 *  @return mineType
 */
+ (NSString *)getFileMineType:(NSString *)fileName;



/**
 *  用模型包装参数发送get请求
 *
 *  @param urlString url
 *  @param params    参数
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)GETWithURL:(NSString *)urlString
       paramsModel:(id)params
     completeBlock:(void(^)(id request))success
         failBlock:(void(^)(NSError * error))failure;

/**
 *  用模型包装参数发送post请求
 *
 *  @param urlString url
 *  @param params    参数
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)POSTWithURL:(NSString *)urlString
        paramsModel:(id)params
      completeBlock:(void(^)(id request))success
          failBlock:(void(^)(NSError * error))failure;

/**
 *  用模型包装参数上传图片
 *
 *  @param urlString  url
 *  @param params     请求参数
 *  @param image      图片(png格式，如果传的其它格式，需要改变mimeType)
 *  @param imageParam 图片对应参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)POSTImageWithURL:(NSString *)urlString
             paramsModel:(id)params
                   image:(UIImage *)image
              imageParam:(NSString *)imageParam
           completeBlock:(void(^)(id request))success
               failBlock:(void(^)(NSError * error))failure;

/// 用模型包装参数上传多张图片
///
/// @param urlString  url
/// @param params     请求参数
/// @param images     图片数组
/// @param imageParam 图片对应参数
/// @param success    成功回调
/// @param failure    失败回调
+ (void)POSTImagesWithURL:(NSString *)urlString
              paramsModel:(id)params
                   images:(NSArray *)images
               imageParam:(NSString *)imageParam
            completeBlock:(void(^)(id request))success
                failBlock:(void(^)(NSError * error))failure;
@end
