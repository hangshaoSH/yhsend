//
//  YHNetWorking.m
//  网络封装BolckDemo
//
//  Created by ZG-于欢 on 15/10/22.
//  Copyright © 2015年 于欢. All rights reserved.
//

#import "YHNetWorking.h"
#import "YHCheckNetworkMananger.h"

#define KTIMEOUT 60 //超时时间
#define KLoadViewTag 55555
static NSMutableArray   *httpQueen;		// 定义一个全局的堆栈，用于存放所有的Http请求
static NSString *setVcStr;   //定义当前的网络标签
static BOOL isCheckInternet;   //是否检查网络
@interface YHNetWorking ()

typedef enum {
    
    RequestTypeGet,
    RequestTypePost,
    
}RequestType;//请求类型

@property(nonatomic, copy) NSString *RequestVcID;//请求的Vc
@property(nonatomic, copy) NSString *requestApiStr;//ApiStr
@property(nonatomic, strong) UIView *loadView;//增加选装框的父视图
@property(nonatomic, strong) NSMutableDictionary *parameters;//所传字典参数
@end
@implementation YHNetWorking
#pragma -mark private

#pragma -mark -------------
#pragma -mark YHNetWorking 设置基本参数
/**
 *  @brief 设置基本参数
 *  @return YHNetWorking 
 **/
-(YHNetWorking *)setBase:(YHNetWorking *)network AndJoiningTogetherApi:(BOOL)isJoining{
    //1.判断存放所有的Http请求 是否为空
    if (httpQueen == nil) {
        httpQueen = [[NSMutableArray alloc] init];//初始化 httpQueen
        isCheckInternet=NO;
    }
    //2.设置该网络请求线程的vc标签
    network.RequestVcID=setVcStr;
    //3.拼接url
    if (isJoining) {
        network.requestApiStr=[NSString stringWithFormat:@"%@%@",[network baseURL],network.requestApiStr];
    }
    //4.设置超时时间
    network.requestSerializer.timeoutInterval =KTIMEOUT;
    //5.状态栏的网络旋转开启
    [UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
    //6.设置接收类型
    network.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    return network;
}
#pragma -mark YHNetWorking 得到基本Api域名
/**
 *  @brief 得到基本Api域名
 *  @return NSString
 **/
-(NSString *)baseURL{
    if ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"baseURL"]==nil) {
        return @"http://app.cqtianjiao.com/server/";
    }
    return  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"baseURL"];
}
#pragma -mark YHNetWorking 开始请求
-(void)startRequest:(YHNetWorking *)network AndType:(RequestType)type Success:(void(^)(id responseDict))success Faild:(void(^)(id error))faild{
    switch ([YHCheckNetworkMananger shareYHCheckNetworkMananger].netState) {
        case 0:{
            if (isCheckInternet==YES) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
                if(network.loadView!=nil){
                    [network hideWaiting:network];
                }
                NSMutableDictionary *eroinfo =[[NSMutableDictionary alloc]init];
                [eroinfo setValue:@"请检查您的网络" forKey:@"err"];
                [eroinfo setValue:[NSNumber numberWithInt:-1] forKey:@"flag"];
                faild(eroinfo);
            }else{
                [network netWorkStatusSetReachabilityStatusChangeBlock:^{
                    isCheckInternet=YES;
                    [network startRequest:network AndType:type Success:success Faild:faild];
                }];
            }
        }break;
        case -1:{
            [network netWorkStatusSetReachabilityStatusChangeBlock:^{
                isCheckInternet=YES;
                [network startRequest:network AndType:type Success:success Faild:faild];
            }];
        }break;
        default:{
            switch (type) {
                case RequestTypeGet:
                {
                    [network GET:network.requestApiStr
                      parameters:network.parameters
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             //解析
                             id jsonObject=[network JieXiJson:responseObject];
                             //状态栏的网络旋转关闭
                             [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
                             if(network.loadView!=nil){
                                 [network hideWaiting:network];
                             }
                             //返回成功数据
                             if ([network isSuccess:jsonObject]) {
                                 //返回成功数据
                                 success(jsonObject);
                             }else{
                                 faild(jsonObject);
                             }
                         }
                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             //状态栏的网络旋转关闭
                             [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
                             if(network.loadView!=nil){
                                 [network hideWaiting:network];
                             }
                             //返回失败数据
                             faild([network GetMessageWithFaild:error]);
                         }];
                }
                    break;
                case RequestTypePost:
                {
                    [network POST:network.requestApiStr
                       parameters:network.parameters
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              //解析
                              id jsonObject=[network JieXiJson:responseObject];
                              //状态栏的网络旋转关闭
                              [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
                              if(network.loadView!=nil){
                                  [network hideWaiting:network];
                              }
                              //返回成功数据
                              if ([network isSuccess:jsonObject]) {
                                  //返回成功数据
                                  success(jsonObject);
                              }else{
                                  faild(jsonObject);
                              }
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog ( @"operation: %@" , operation. responseString ); 
                              //状态栏的网络旋转关闭
                              [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
                              if(network.loadView!=nil){
                                  [network hideWaiting:network];
                              }
                              //返回失败数据
                              faild([network GetMessageWithFaild:error]);
                          }];
                }
                    break;
                default:
                    break;
            }
        }
        break;
    }
}
#pragma -mark 根据错误得到信息  处理error
/**
 *  @brief 根据错误得到信息
 *  @return NSDictionary 错误信息 key(键值)message为错误信息
 **/
-(NSDictionary *)GetMessageWithFaild:(NSError *)error{
    NSMutableDictionary *eroinfo = nil;
    if (error != nil) {
        eroinfo = [[NSMutableDictionary alloc] init];
        [eroinfo setValue:[error description] forKey:@"err"];
        [eroinfo setValue:[NSNumber numberWithInt:-1] forKey:@"flag"];
        if (error.code == -1001) {
            [eroinfo setValue:@"请求超时,请检查你的网络" forKey:@"err"];
        }
        if (error.code == -1004) {
            [eroinfo setValue:@"无法连接到服务器" forKey:@"err"];
        }
        if (error.code==-1005) {
            [eroinfo setValue:@"网络连接中断" forKey:@"err"];
        }else{
            [eroinfo setValue:@"网络异常!" forKey:@"err"];
        }
    }
    return eroinfo;
}
#pragma -mark Json解析
/**
 *  @brief Json解析
 *  @param所传参数 id responseObject 接收数据
 *  @return id  解析之后的数据
 **/
-(id)JieXiJson:(id )responseObject{
    id jsonObject;
    if([responseObject isKindOfClass:[NSData class]]){
        //解析
        NSError *error = nil;
        jsonObject= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
    }else{
        jsonObject=responseObject;
    }
    return jsonObject;
}
#pragma -mark 判断是否成功
/**
 *  @brief 判断是否成功 //succeed 1为成功
 *  @param所传参数 NSDictionary *dic 字典
 *  @return BOOL
 **/
-(BOOL)isSuccess:(id )dic{
    BOOL _isSuccess;
    if ([dic isKindOfClass:[NSDictionary class]]) {
        int status=[[dic objectForKey:@"flag"] intValue];
        if ([dic objectForKey:@"flag"]==nil||[dic objectForKey:@"flag"]==NULL||[[dic objectForKey:@"flag"] isKindOfClass:[NSNull class]]||[[dic objectForKey:@"flag"] isEqualToString:@""]) {
            _isSuccess=YES;
        }else {
            if ( status==-1 )
            {
                _isSuccess=NO;
            }else{
                _isSuccess=YES;
            }
        }
    }else{
        _isSuccess=YES;
    }
    return _isSuccess;
}
#pragma mark 显示进度滚轮指示器
/**
 *  @brief 根据错误得到信息
 *  @param所传参数 view 旋转框加载的view loadStr  加载文字
 *  @return void
 **/
-(void)showWaitingWithView:(UIView *)view AndStr:(NSString *)loadString{
    //1.增加背景view
    UIView * aboveView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,view.frame.size.width, view.frame.size.height)];
    [aboveView setTag:KLoadViewTag];
    [aboveView setBackgroundColor:[UIColor clearColor]];
    [view addSubview:aboveView];
    //2.增加旋转背景view
    UIView * aboveActivity=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [aboveActivity setBackgroundColor:[UIColor blackColor]];
    [aboveActivity.layer setCornerRadius:5.0];
    [aboveActivity.layer setMasksToBounds:YES];
    [aboveActivity setCenter:aboveView.center];
    [aboveActivity setAlpha:0.8];
    [aboveView addSubview:aboveActivity];
    //3.增加旋转框
    UIActivityIndicatorView * activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.color=[UIColor whiteColor];
    [activity startAnimating]; // 开始旋转
    activity.center = aboveActivity.center;//只能设置中心，不能设置大小
    [aboveView addSubview:activity];
    //4.增加提示文字
    UILabel *theLabel=[[UILabel alloc]initWithFrame:CGRectMake(10 ,aboveActivity.frame.size.height-30, aboveActivity.frame.size.width-20 , 30)];
    theLabel.text=loadString;
    theLabel.font=[UIFont systemFontOfSize:14];
    theLabel.textAlignment=NSTextAlignmentCenter;
    theLabel.textColor=[UIColor whiteColor];
    [aboveActivity addSubview:theLabel];
}
#pragma mark 消除滚动轮指示器
-(void)hideWaiting:(YHNetWorking *)network
{
    [[network.loadView viewWithTag:KLoadViewTag] removeFromSuperview];
}
#pragma -mark 检查网络状态
/**
 *  @brief 检查网络状态
 *  @return void
 **/
-(void)netWorkStatusSetReachabilityStatusChangeBlock:(void(^)()) block
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这是单利＋模型，用来记录网络状态
        [YHCheckNetworkMananger shareYHCheckNetworkMananger].netState=status;
        block();
//        NSLog(@"-----网络状态----%ld---%d", status,manager.netState);
        NSLog(@"-----网络状态----%ld", (long)status);
    }];
}
#pragma -mark public

#pragma -mark -------------
#pragma -mark Get  URL拼接
/**
 *  @brief 网络请求Get URL拼接
 *  @param api 域名后的地址 dic 所传参数
 *  @return void
 *  @blocks
 *              success:返回的NSDictionary中包含服务器的response信息，包括图片id（id）,url(url),宽度(width),高度(height)。使用括号中的名称从NSDictionary中获取。
 *              failed:返回error
 *  @warning
 **/
+(void)invokeGetApi:(NSString *)api args:(NSMutableDictionary*)dic Success:(void(^)(id responseDict))success Faild:(void(^)(id error))faild{
    //1.初始化
    YHNetWorking *__instance=[[YHNetWorking alloc]init];
    //2.设置__instance
    __instance=[__instance setBase:__instance AndJoiningTogetherApi:YES];
    __instance.requestApiStr=api;
    __instance.parameters=dic;
    //3.Get
    [__instance startRequest:__instance AndType:RequestTypeGet Success:success Faild:faild];
}
#pragma -mark Post  URL拼接
/**
 *  @brief 网络请Post URL拼接
 *  @param api 域名后的地址 dic 所传参数
 *  @return void
 *  @blocks
 *              success:返回的NSDictionary中包含服务器的response信息，包括图片id（id）,url(url),宽度(width),高度(height)。使用括号中的名称从NSDictionary中获取。
 *              failed:返回error
 *  @warning
 **/

+(void)invokePostApi:(NSString *)api args:(NSMutableDictionary*)dic Success:(void(^)(id responseDict))success Faild:(void(^)(id error))faild{
    //1.初始化
    YHNetWorking *__instance=[[YHNetWorking alloc]init];
    //2.设置__instance
    __instance.requestApiStr=api;
    __instance.parameters=dic;
    __instance=[__instance setBase:__instance AndJoiningTogetherApi:YES];
    //3.Post
    [__instance startRequest:__instance AndType:RequestTypePost Success:success Faild:faild];
}
#pragma -mark Get  URL拼接 增加旋转框
/**
 *  @brief 网络请求Get 有加载旋转框 URL拼接
 *  @param api 域名后的地址 dic 所传参数 view 旋转框加载的view loadStr  加载文字
 *  @return void
 *  @blocks
 *              success:返回的NSDictionary中包含服务器的response信息，包括图片id（id）,url(url),宽度(width),高度(height)。使用括号中的名称从NSDictionary中获取。
 *              failed:返回error
 *  @warning
 **/
+(void)invokeGetApi:(NSString *)api args:(NSMutableDictionary*)dic Success:(void(^)(id responseDict))success Faild:(void(^)(id error))faild inLoadView:(UIView *)view AndLoadStr:(NSString *)loadStr{
    //1.初始化
    YHNetWorking *__instance=[[YHNetWorking alloc]init];
    //2.设置__instance
    __instance.requestApiStr=api;
    __instance.loadView=view;
    __instance.parameters=dic;
    __instance=[__instance setBase:__instance AndJoiningTogetherApi:YES];
    [__instance showWaitingWithView:view AndStr:loadStr];
    //3.Get
    [__instance startRequest:__instance AndType:RequestTypeGet Success:success Faild:faild];
}
#pragma -mark Post URL拼接 增加旋转框
/**
 *  @brief 网络请求Post 有加载旋转框 URL拼接
 *  @param api 域名后的地址 dic 所传参数 view 旋转框加载的view loadStr  加载文字
 *  @return void
 *  @blocks
 *              success:返回的NSDictionary中包含服务器的response信息，包括图片id（id）,url(url),宽度(width),高度(height)。使用括号中的名称从NSDictionary中获取。
 *              failed:返回error
 *  @warning
 **/
+(void)invokePostApi:(NSString *)api args:(NSMutableDictionary*)dic Success:(void(^)(id responseDict))success Faild:(void(^)(id error))faild inLoadView:(UIView *)view AndLoadStr:(NSString *)loadStr{
    //1.初始化
    YHNetWorking *__instance=[[YHNetWorking alloc]init];
    //2.设置__instance
    __instance.requestApiStr=api;
    __instance.loadView=view;
    __instance.parameters=dic;
    __instance=[__instance setBase:__instance AndJoiningTogetherApi:YES];
    [__instance showWaitingWithView:view AndStr:loadStr];
    //3.Post
    [__instance startRequest:__instance AndType:RequestTypePost Success:success Faild:faild];
}
#pragma mark Get Url完整
/**
 *  @brief 网络请求Get  URL 完整
 *  @param api 域名后的地址 dic 所传参数
 *  @return void
 *  @blocks
 *              success:返回的NSDictionary中包含服务器的response信息，包括图片id（id）,url(url),宽度(width),高度(height)。使用括号中的名称从NSDictionary中获取。
 *              failed:返回error
 *  @warning
 **/
+(void)invokeGetCompleteApi:(NSString *)api args:(NSMutableDictionary*)dic Success:(void(^)(id responseDict))success Faild:(void(^)(id error))faild{
    //1.初始化
    YHNetWorking *__instance=[[YHNetWorking alloc]init];
    //2.设置__instance
     __instance.requestApiStr=api;
    __instance.parameters=dic;
    __instance=[__instance setBase:__instance AndJoiningTogetherApi:NO];
    //3.Get
    [__instance startRequest:__instance AndType:RequestTypeGet Success:success Faild:faild];
}
#pragma mark Post Url完整
/**
 *  @brief 网络请求Post  URL 完整
 *  @param api 域名后的地址 dic 所传参数
 *  @return void
 *  @blocks
 *              success:返回的NSDictionary中包含服务器的response信息，包括图片id（id）,url(url),宽度(width),高度(height)。使用括号中的名称从NSDictionary中获取。
 *              failed:返回error
 *  @warning
 **/
+(void)invokePostCompleteApi:(NSString *)api args:(NSMutableDictionary*)dic Success:(void(^)(id responseDict))success Faild:(void(^)(id error))faild{
    //1.初始化
    YHNetWorking *__instance=[[YHNetWorking alloc]init];
    //2.设置__instance
    __instance.requestApiStr=api;
    __instance.parameters=dic;
    __instance=[__instance setBase:__instance AndJoiningTogetherApi:NO];
    //3.Post
    [__instance startRequest:__instance AndType:RequestTypePost Success:success Faild:faild];
}
#pragma -mark Get  URL完整 增加旋转框
/**
 *  @brief 网络请求Get 有加载旋转框 URL完整
 *  @param api 域名后的地址 dic 所传参数 view 旋转框加载的view loadStr  加载文字
 *  @return void
 *  @blocks
 *              success:返回的NSDictionary中包含服务器的response信息，包括图片id（id）,url(url),宽度(width),高度(height)。使用括号中的名称从NSDictionary中获取。
 *              failed:返回error
 *  @warning
 **/
+(void)invokeGetCompleteApi:(NSString *)api args:(NSMutableDictionary*)dic Success:(void(^)(id responseDict))success Faild:(void(^)(id error))faild inLoadView:(UIView *)view AndLoadStr:(NSString *)loadStr{
    //1.初始化
    YHNetWorking *__instance=[[YHNetWorking alloc]init];
    //2.设置__instance
    __instance.requestApiStr=api;
    __instance.loadView=view;
    __instance.parameters=dic;
    __instance=[__instance setBase:__instance AndJoiningTogetherApi:NO];
    [__instance showWaitingWithView:view AndStr:loadStr];
    //3.Get
    [__instance startRequest:__instance AndType:RequestTypeGet Success:success Faild:faild];
}

#pragma -mark Post  URL完整 增加旋转框
/**
 *  @brief 网络请求Post 有加载旋转框 URL完整
 *  @param api 域名后的地址 dic 所传参数 view 旋转框加载的view loadStr  加载文字
 *  @return void
 *  @blocks
 *              success:返回的NSDictionary中包含服务器的response信息，包括图片id（id）,url(url),宽度(width),高度(height)。使用括号中的名称从NSDictionary中获取。
 *              failed:返回error
 *  @warning
 **/
+(void)invokePostCompletetApi:(NSString *)api args:(NSMutableDictionary*)dic Success:(void(^)(id responseDict))success Faild:(void(^)(id error))faild inLoadView:(UIView *)view AndLoadStr:(NSString *)loadStr{
    //1.初始化
    YHNetWorking *__instance=[[YHNetWorking alloc]init];
    //2.设置__instance
    __instance.requestApiStr=api;
    __instance.loadView=view;
    __instance.parameters=dic;
    __instance=[__instance setBase:__instance AndJoiningTogetherApi:NO];
    [__instance showWaitingWithView:view AndStr:loadStr];
    //3.Post
    [__instance startRequest:__instance AndType:RequestTypePost Success:success Faild:faild];
}
#pragma -mark 中断所有的网络请求
/**
 *  @brief 中断所有的网络请求
 *  @return void
 **/
+(void)stopAllRequest{
    for (YHNetWorking *ntewWork in httpQueen) {
        [ntewWork.operationQueue cancelAllOperations];
    }
    [httpQueen removeAllObjects];
}
#pragma -mark 停止ViewController当前请求
/**
 *  @brief 停止ViewController当前请求
 *  @return void
 **/
+(void)stopTheVcRequset:(UIViewController *)Vc{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    for (YHNetWorking *ntewWork in httpQueen) {
        if ([ntewWork.RequestVcID isEqualToString:Vc.debugDescription]) {
            [ntewWork.operationQueue cancelAllOperations];
            [arr addObject:ntewWork];
        }
    }
    [httpQueen removeObject:arr];
}
#pragma -mark 给ViewController请求标注ID
/**
 *  @brief 给ViewController请求标注ID
 *  @return void
 **/
+(void)setVcRequestId:(UIViewController *)Vc{
    setVcStr=Vc.debugDescription;
}
@end
