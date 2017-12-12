//
//  TSNetworking.m
//
//  Created by Seven on 15/8/29.
//  Copyright (c) 2015年 toocms. All rights reserved.
//  封装AFNetworking




#import "TSNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import "MJExtension.h"

@implementation TSNetworking

#pragma mark - Public

+ (void)GETWithURL:(NSString *)urlString params:(NSDictionary *)params completeBlock:(void (^)(id))success failBlock:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", API, urlString];
    TSLog(params);
    
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)POSTWithURL:(NSString *)urlString params:(NSDictionary *)params completeBlock:(void (^)(id))success failBlock:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", API, urlString];
    TSLog(params);
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)POSTImageWithURL:(NSString *)urlString params:(NSDictionary *)params image:(UIImage *)image imageParam:(NSString *)imageParam completeBlock:(void (^)(id))success failBlock:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", API, urlString];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData * data = UIImageJPEGRepresentation(image, 0.1);
        NSString * fileName = [self getfileName];
        
        [formData appendPartWithFileData:data name:imageParam fileName:fileName mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
/**
 *  获取文件的mineType（文件需要在mainBundle中）
 *
 *  @param fileName 文件名（含拓展名）
 *
 *  @return mineType
 */
+ (NSString *)getFileMineType:(NSString *)fileName {
    
    NSURL * url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse * response = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    return response.MIMEType;
}

+ (void)GETWithURL:(NSString *)urlString paramsModel:(id)params completeBlock:(void (^)(id))success failBlock:(void (^)(NSError *))failure
{

    [self GETWithURL:urlString params:[params keyValues] completeBlock:success failBlock:failure];
}

+ (void)POSTWithURL:(NSString *)urlString paramsModel:(id)params completeBlock:(void (^)(id))success failBlock:(void (^)(NSError *))failure
{    [self POSTWithURL:urlString params:[params keyValues] completeBlock:success failBlock:failure];
}

+ (void)POSTImageWithURL:(NSString *)urlString paramsModel:(id)params image:(UIImage *)image imageParam:(NSString *)imageParam completeBlock:(void (^)(id))success failBlock:(void (^)(NSError *))failure
{
    [self POSTImageWithURL:urlString params:[params keyValues] image:image imageParam:imageParam completeBlock:success failBlock:failure];

}

+ (void)POSTImagesWithURL:(NSString *)urlString paramsModel:(id)params images:(NSArray *)images imageParam:(NSString *)imageParam completeBlock:(void (^)(id))success failBlock:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", API, urlString];
    
    [manager POST:url parameters:[params keyValues] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i = 0; i < images.count; i++) {
            
            UIImage * image = images[i];
            NSData * data = UIImageJPEGRepresentation(image, 0.1);
            
            // 生成图片名字
            NSDateFormatter * format = [[NSDateFormatter alloc] init];
            format.dateFormat = @"yyyyMMddHHmmss";
            NSString * date = [format stringFromDate:[NSDate date]];
            NSString * fileName = [date stringByAppendingFormat:@"%@%d.jpg",date, i];
            
            // 图片对应的参数
            NSString * imageP = [NSString stringWithFormat:@"%@%d", imageParam, i];
            
            // 拼接图片数据
            [formData appendPartWithFileData:data name:imageP fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - Private
/**
 *  产生图片名字
 */
+ (NSString *)getfileName
{
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyyMMddHHmmss";
    NSString * date = [format stringFromDate:[NSDate date]];
    return [date stringByAppendingFormat:@"%@.jpg",date];
}

@end
