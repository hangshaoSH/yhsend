//
//  YHNetWork.m
//  chlidfios
//
//  Created by ZG-YUH on 15/7/14.
//  Copyright (c) 2015年 yuhuan. All rights reserved.
//

#import "YHNetWork.h"
#import "YHAlerView.h"
static NSMutableArray   *httpQueen;		// 定义一个全局的堆栈，用于存放所有的Http请求
static NSMutableArray  *IDArry;
static NSString *setVcStr;
static YHAlerView *netAler;
@implementation YHNetWork
#pragma mark -netWork
+ (NSData *)HTTPBodyWithParma:(NSDictionary *)parma
{
    
    NSMutableString  *string = [[NSMutableString alloc]init];
    
    [parma enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        [string appendString:[NSString stringWithFormat:@"%@=%@&",key,obj]];
        
    }];
    
    return [string dataUsingEncoding:NSUTF8StringEncoding];
    
}
+(void)invokeApi:(NSString *)api args:(NSMutableDictionary*)dic target:(id)_target succ:(SEL)success error:(SEL)error{
    YHNetWork *__instance=[[YHNetWork alloc]init];
    __instance.target=_target;
    __instance.suc=success;
    __instance.failErro=error;
    if (httpQueen == nil) {
        httpQueen = [[NSMutableArray alloc] init];
    }
    __instance.RequestVcID=setVcStr;

    [UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval =15;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",[__instance baseURL],api];
    [httpQueen addObject:__instance];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if(![responseObject isKindOfClass:[NSDictionary class]]){
            if (responseObject!=nil) {
                [__instance performSelectorSucc:success and:responseObject];
            }
        }else{
            int status=[[responseObject objectForKey:@"flag"] intValue];
            if ( status==0 ){
                [__instance performSelectorSucc:success and:responseObject];
            }else{
                [__instance performSelectorError:error and:responseObject];
                
            }
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *failError) {
        NSLog(@"Error: %@", failError);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSMutableDictionary *eroinfo = nil;
        if (failError != nil) {
            eroinfo = [[NSMutableDictionary alloc] init];
            [eroinfo setValue:[failError description] forKey:@"err"];
            [eroinfo setValue:[NSNumber numberWithInt:-1] forKey:@"flag"];
            if (failError.code == -1001) {
                [netAler removeFromSuperview];
                netAler=[[YHAlerView alloc]initAlerTitle:@"提示" AndMessage:@"请求超时,请检查你的网络" AndCancleBtn:@"确定" AndOtherCancle:nil];
                [netAler show];
//                [eroinfo setValue:@"请求超时,请检查你的网络" forKey:@"err"];
//                [__instance performSelectorError:error and:eroinfo];
            }
            if (failError.code == -1004) {
                [netAler removeFromSuperview];
                netAler=[[YHAlerView alloc]initAlerTitle:@"提示" AndMessage:@"不能连接网络,请检查你的网络" AndCancleBtn:@"确定" AndOtherCancle:nil];
                [netAler show];
//                [eroinfo setValue:@"不能连接网络,请检查你的网络" forKey:@"err"];
//                [__instance performSelectorError:error and:eroinfo];
            }
            if (failError.code==-1005) {
//                [eroinfo setValue:@"网络连接中断" forKey:@"message"];
//                [__instance performSelectorError:error and:eroinfo];   //此处是你调用函数的地方
            }
        }else{
            
        }
        NSLog(@"%@",failError);
    }];
}
+(void)invokeApi:(NSString *)api args:(id)dic target:(id)_target completeBlock:(void(^)(id request))success failBlock:(void(^)(NSError * error))failure
{
    YHNetWork *__instanceAler=[[YHNetWork alloc]init];
    __instanceAler.target=_target;
    if (httpQueen == nil) {
        httpQueen = [[NSMutableArray alloc] init];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval =15;
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",[__instanceAler baseURL],api];
    [httpQueen addObject:__instanceAler];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            TSLog(responseObject);
            if (success) {
                success(responseObject);
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *failError) {
        NSMutableDictionary *eroinfo = nil;
        if (failError != nil) {
            eroinfo = [[NSMutableDictionary alloc] init];
            [eroinfo setValue:[failError description] forKey:@"err"];
            [eroinfo setValue:[NSNumber numberWithInt:-1] forKey:@"flag"];
            if (failError.code == -1001) {
                //                [eroinfo setValue:@"请求超时,请检查你的网络" forKey:@"err"];
                [netAler removeFromSuperview];
                //                        netAler=[[YHAlerView alloc]initAlerTitle:@"提示" AndMessage:@"请求超时,请检查你的网络" AndCancleBtn:@"确定" AndOtherCancle:nil];
                //                        [netAler show];
                TSLog(@"请求超时,请检查你的网络");
                //                [__instanceAler performSelectorError:error and:eroinfo];
            }
            if (failError.code == -1004) {
                [netAler removeFromSuperview];
                //                        netAler=[[YHAlerView alloc]initAlerTitle:@"提示" AndMessage:@"不能连接网络,请检查你的网络" AndCancleBtn:@"确定" AndOtherCancle:nil];
                //                        [netAler show];
                TSLog(@"不能连接网络,请检查你的网络");
                //                [eroinfo setValue:@"不能连接网络,请检查你的网络" forKey:@"err"];
                //                [__instanceAler performSelectorError:error and:eroinfo];
                
            }
            if (failError.code==-1005) {
                
                //                [eroinfo setValue:@"网络连接中断" forKey:@"message"];
                //                [__instanceAler performSelectorError:error and:eroinfo];   //此处是你调用函数的地方
            }
            if (failError.code == -1009) {
                TSLog(@"不能连接网络,请检查你的网络");
            }
            if (failure) {
                failure(failError);
            }
        }else{
            
        }
    }];
}
+ (void)invokeApiAndLoadAlter:(NSString *)api args:(id)dic target:(id)_target completeBlock:(void (^)(id))success failBlock:(void (^)(NSError *))failure
{
    YHNetWork *__instanceAler=[[YHNetWork alloc]init];
    [__instanceAler showWaiting];
    __instanceAler.target=_target;
    if (httpQueen == nil) {
        httpQueen = [[NSMutableArray alloc] init];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval =15;
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",[__instanceAler baseURL],api];
    [httpQueen addObject:__instanceAler];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [__instanceAler hideWaiting];
        dispatch_async(dispatch_get_main_queue(), ^{
            TSLog(responseObject);
            if (success) {
                success(responseObject);
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *failError) {
        [__instanceAler hideWaiting];
        TSLog(failError);
        NSMutableDictionary *eroinfo = nil;
        if (failError != nil) {
            eroinfo = [[NSMutableDictionary alloc] init];
            [eroinfo setValue:[failError description] forKey:@"err"];
            [eroinfo setValue:[NSNumber numberWithInt:-1] forKey:@"flag"];
            if (failError.code == -1001) {
                //                [eroinfo setValue:@"请求超时,请检查你的网络" forKey:@"err"];
                [netAler removeFromSuperview];
                //                        netAler=[[YHAlerView alloc]initAlerTitle:@"提示" AndMessage:@"请求超时,请检查你的网络" AndCancleBtn:@"确定" AndOtherCancle:nil];
                //                        [netAler show];
                SVShowError(@"请求超时,请检查你的网络");
                //                [__instanceAler performSelectorError:error and:eroinfo];
            }
            if (failError.code == -1004) {
                [netAler removeFromSuperview];
                //                        netAler=[[YHAlerView alloc]initAlerTitle:@"提示" AndMessage:@"不能连接网络,请检查你的网络" AndCancleBtn:@"确定" AndOtherCancle:nil];
                //                        [netAler show];
                SVShowError(@"不能连接网络,请检查你的网络");
                //                [eroinfo setValue:@"不能连接网络,请检查你的网络" forKey:@"err"];
                //                [__instanceAler performSelectorError:error and:eroinfo];
                
            }
            if (failError.code==-1005) {
                [netAler removeFromSuperview];
                //                [eroinfo setValue:@"网络连接中断" forKey:@"message"];
                //                [__instanceAler performSelectorError:error and:eroinfo];   //此处是你调用函数的地方
            }
            if (failError.code == -1009) {
                [netAler removeFromSuperview];
                //                        netAler=[[YHAlerView alloc]initAlerTitle:@"提示" AndMessage:@"不能连接网络,请检查你的网络" AndCancleBtn:@"确定" AndOtherCancle:nil];
                //                        [netAler show];
                SVShowError(@"不能连接网络,请检查你的网络");
                //                [eroinfo setValue:@"不能连接网络,请检查你的网络" forKey:@"err"];
                //                [__instanceAler performSelectorError:error and:eroinfo];
                
            }
            if (failure) {
                failure(failError);
            }
        }else{
            
        }
    }];
}
+(void)invokeApiAndLoadAlter:(NSString *)api args:(id)dic target:(id)_target succ:(SEL)success error:(SEL)error {
        YHNetWork *__instanceAler=[[YHNetWork alloc]init];
//    [__instanceAler hideWaiting];//先隐藏之前的view
    [User sharedUser].stopLoading = NO;
        [__instanceAler showWaiting];
        __instanceAler.target=_target;
        __instanceAler.suc=success;
        __instanceAler.failErro=error;
        if (httpQueen == nil) {
            httpQueen = [[NSMutableArray alloc] init];
        }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        manager.requestSerializer.timeoutInterval =15;
        NSString *urlStr=[NSString stringWithFormat:@"%@%@",[__instanceAler baseURL],api];
        [httpQueen addObject:__instanceAler];
        [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [__instanceAler hideWaiting];
            dispatch_async(dispatch_get_main_queue(), ^{
                TSLog(responseObject);
                if(![responseObject isKindOfClass:[NSDictionary class]]){
                    if (responseObject!=nil) {
                        [__instanceAler performSelectorSucc:success and:responseObject];
                    }
                }else{
                    int status=[[responseObject objectForKey:@"flag"] intValue];
                    if ( status==0 )
                    {
                        [__instanceAler performSelectorSucc:success and:responseObject];
                    }else{
                        [__instanceAler performSelectorError:error and:responseObject];
                    }
                }
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *failError) {
            [__instanceAler hideWaiting];
            TSLog(failError);
                NSMutableDictionary *eroinfo = nil;
                if (failError != nil) {
                    eroinfo = [[NSMutableDictionary alloc] init];
                    [eroinfo setValue:[failError description] forKey:@"err"];
                    [eroinfo setValue:[NSNumber numberWithInt:-1] forKey:@"flag"];
                    if (failError.code == -1001) {
                        //                [eroinfo setValue:@"请求超时,请检查你的网络" forKey:@"err"];
                        [netAler removeFromSuperview];
//                        netAler=[[YHAlerView alloc]initAlerTitle:@"提示" AndMessage:@"请求超时,请检查你的网络" AndCancleBtn:@"确定" AndOtherCancle:nil];
//                        [netAler show];
                        SVShowError(@"请求超时,请检查你的网络");
                        //                [__instanceAler performSelectorError:error and:eroinfo];
                    }
                    if (failError.code == -1004) {
                        [netAler removeFromSuperview];
//                        netAler=[[YHAlerView alloc]initAlerTitle:@"提示" AndMessage:@"不能连接网络,请检查你的网络" AndCancleBtn:@"确定" AndOtherCancle:nil];
//                        [netAler show];
                        SVShowError(@"不能连接网络,请检查你的网络");
                        //                [eroinfo setValue:@"不能连接网络,请检查你的网络" forKey:@"err"];
                        //                [__instanceAler performSelectorError:error and:eroinfo];
                        
                    }
                    if (failError.code==-1005) {
                        
                        //                [eroinfo setValue:@"网络连接中断" forKey:@"message"];
                        //                [__instanceAler performSelectorError:error and:eroinfo];   //此处是你调用函数的地方
                    }
                    
                }else{
                }
                NSLog(@"%@",failError);
        }];
}

#pragma -mark 上传图片
+(void)invokeApiAndImgae:(NSString *)api AndImgae:(UIImage *)image AndImageKey:(NSString *)imageKey args:(id)dic target:(id)_target succ:(SEL)success error:(SEL)error {
    YHNetWork *__instanceAler=[[YHNetWork alloc]init];
    __instanceAler.target=_target;
    __instanceAler.suc=success;
    __instanceAler.failErro=error;
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",[__instanceAler baseURL],api];
    [[FSSummitFile shareInstance] httpRequestWithURL:urlStr params:dic fileKey:imageKey fileName:@"image" fireFormat:@"png" filePath:nil];
    [[FSSummitFile shareInstance] setLoadFinsh:^(NSDictionary *resultDic) {
        int statu= [[resultDic objectForKey:@"status"] intValue];
        if (statu==200) {
            [__instanceAler performSelectorSucc:success and:resultDic];

        }else{
            [__instanceAler performSelectorError:error and:resultDic];
        }
    }];
}
-(void)performSelectorSucc:(SEL)success and:(NSDictionary *)responseObject{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if(self.target!=nil&&self.suc!=nil){
        [self.target performSelector:success withObject:responseObject];   //此处是你调用函数的地方
    }
    #pragma clang diagnostic pop
}
-(void)performSelectorError:(SEL)error and:(NSDictionary *)responseObject{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([User sharedUser].stopLoading == YES) {
        return ;
    }
    if(self.target!=nil&&self.failErro!=nil){
        [self.target performSelector:error withObject:responseObject];   //此处是你调用函数的地方
    }
    #pragma clang diagnostic pop
}
#pragma mark--显示进度滚轮指示器--
-(void)showWaiting {
    UIView * aboveActivity=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [aboveActivity setTag:55555];
    [aboveActivity setBackgroundColor:[UIColor blackColor]];
    [aboveActivity.layer setCornerRadius:5.0];
    [aboveActivity.layer setMasksToBounds:YES];
    [aboveActivity setCenterX:[[[UIApplication sharedApplication] delegate] window].centerX];
    [aboveActivity setCenterY:[[[UIApplication sharedApplication] delegate] window].centerY];
    [aboveActivity setAlpha:0.8];
    if ([User sharedUser].netFlag == 1) {
        
    } else {
        [[[[UIApplication sharedApplication] delegate] window] addSubview:aboveActivity];
    }
    UIActivityIndicatorView * activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activity setFrame:CGRectMake(35, 28, 30, 30)];
    if ([User sharedUser].netFlag == 1) {
        
    } else {
        [aboveActivity addSubview:activity];
    }
    UILabel *theLabel=[[UILabel alloc]initWithFrame:CGRectMake(10 ,activity.endY+5, 80 , 30)];
    theLabel.text=@"请稍后..";
    theLabel.font=[UIFont systemFontOfSize:16];
    theLabel.textAlignment=NSTextAlignmentCenter;
    theLabel.textColor=[UIColor whiteColor];
    if ([User sharedUser].netFlag == 1) {
        
    } else {
        [aboveActivity addSubview:theLabel];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [User sharedUser].netFlag = 1;
    [activity startAnimating];
    
}
+(void)stopAllRequest{
    [self hideWaiting];
    for (YHNetWork *ntewWork in httpQueen) {
        [ntewWork.manager.operationQueue cancelAllOperations];
    }
    [httpQueen removeAllObjects];
}
+(void)stopTheVcRequset:(UIViewController *)Vc{
    [self hideWaiting];
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    for (YHNetWork *ntewWork in httpQueen) {
        if ([ntewWork.RequestVcID isEqualToString:Vc.debugDescription]) {
            [ntewWork.manager.operationQueue cancelAllOperations];
            [arr addObject:ntewWork];
        }
    }
    [httpQueen removeObject:arr];
}
+(void)setVcRequestId:(UIViewController *)Vc{
    setVcStr=Vc.debugDescription;
}
//消除滚动轮指示器
-(void)hideWaiting
{
    [User sharedUser].netFlag = 0;
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    [[window viewWithTag:55555] removeFromSuperview];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
+ (void)hideWaiting
{
    [User sharedUser].netFlag = 0;
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    [[window viewWithTag:55555] removeFromSuperview];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
-(NSString *)baseURL{
    if ([User sharedUser].urlFlag == 1) {
        return @"http://app.cqtianjiao.com/server/sincere/";
    }
    return  @"http://wy.cqtianjiao.com/guanjia/sincere/";
}
@end
