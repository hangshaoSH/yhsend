//
//  FSSummitFile.h
//  qinghaishiguang
//
//  Created by mac on 14-6-25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol FSHTTPRequestDelegate <NSObject>
-(void)httpRequestResult:(NSDictionary *)result;
@end
@interface FSSummitFile : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@property (copy, nonatomic) void (^loadFinsh)(NSDictionary *resultDic);
+(FSSummitFile *) shareInstance;
-(void)httpRequestWithURL:(NSString *)url params:(NSMutableDictionary *)params fileKey:(NSString *)fileKey fileName:(NSString *)name fireFormat:(NSString *)format filePath:(NSString *)path;
-(void)httpRequestWithURLPostImageArray:(NSString *)url params:(NSMutableDictionary *)params fileKey:(NSString *)fileKey fileName:(NSString *)name fireFormat:(NSString *)format filePath:(NSString *)path;
@end
