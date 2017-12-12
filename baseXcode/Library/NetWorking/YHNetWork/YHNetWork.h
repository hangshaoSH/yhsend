//
//  YHNetWork.h
//  chlidfios
//
//  Created by ZG-YUH on 15/7/14.
//  Copyright (c) 2015年 yuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "FSSummitFile.h"
@interface YHNetWork : NSObject
//无加载框
+(void)invokeApi:(NSString *)api args:(NSMutableDictionary*)dic target:(id)_target succ:(SEL)success error:(SEL)error;
+(void)invokeApi:(NSString *)api args:(id)dic target:(id)_target completeBlock:(void(^)(id request))success
                   failBlock:(void(^)(NSError * error))failure;
//增加旋转框
+(void)invokeApiAndLoadAlter:(NSString *)api args:(id)dic target:(id)_target succ:(SEL)success error:(SEL)error;
+(void)invokeApiAndLoadAlter:(NSString *)api args:(id)dic target:(id)_target completeBlock:(void(^)(id request))success
failBlock:(void(^)(NSError * error))failure;
//图片
+(void)invokeApiAndImgae:(NSString *)api AndImgae:(UIImage *)image AndImageKey:(NSString *)imageKey args:(id)dic target:(id)_target succ:(SEL)success error:(SEL)error;
@property(assign) id target;
@property(nonatomic, assign) SEL suc;
@property(nonatomic, assign) SEL failErro;
@property(nonatomic, copy) NSString *RequestVcID;//请求的Vc
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;//停止所有请求
+(void)stopAllRequest;
//停止Vc当前请求
+(void)stopTheVcRequset:(UIViewController *)Vc;
+(void)setVcRequestId:(UIViewController *)Vc;
+ (void)hideWaiting;
@property (nonatomic,   assign) BOOL stopLoading;
@end
