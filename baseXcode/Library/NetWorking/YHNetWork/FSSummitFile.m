//
//  FSSummitFile.m
//  qinghaishiguang
//
//  Created by mac on 14-6-25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "FSSummitFile.h"
static FSSummitFile * summitFile;

@implementation FSSummitFile

+(FSSummitFile *) shareInstance{
    if (!summitFile) {
        summitFile=[[FSSummitFile alloc] init];
    }
    return summitFile;
}
-(void)httpRequestWithURL:(NSString *)url params:(NSMutableDictionary *)params fileKey:(NSString *)fileKey fileName:(NSString *)name fireFormat:(NSString *)format filePath:(NSString *)path{
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //********************图片********************//
    //要上传的图片
    UIImage *image=[params objectForKey:fileKey];
    //得到图片的data
    NSData* data = UIImagePNGRepresentation(image);
    //********************其他文件***************//
//    NSData * data=[NSData dataWithContentsOfFile:path];
    //******************************************//
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:fileKey])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        }
    }
    
   
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
     if (data) {
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.%@\"\r\n",fileKey,name,format];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: %@/%@\r\n\r\n",[self judgeFileWithFormat:format],format];
    }
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    if (data) {
        [myRequestData appendData:data];
    }
    
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%zi", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    
    //设置接受response的data
    if (conn) {
       NSData * mResponseData = [NSMutableData data];
        NSLog(@"%@",mResponseData);
    }
    //菊花
    
    
    [self startActivityIndicator];
}

-(NSString *)judgeFileWithFormat:(NSString *)format{
    if ([format isEqualToString:@"png"]||[format isEqualToString:@"jpg"]) {
        return @"image";
    }else if([format isEqualToString:@"aac"]){
        return @"audio";
    }else if([format isEqualToString:@"mp4"]){
        return @"vedio";
    }else{
        return @"image";
    }
}
-(void)httpRequestWithURLPostImageArray:(NSString *)url params:(NSMutableDictionary *)params fileKey:(NSString *)fileKey fileName:(NSString *)name fireFormat:(NSString *)format filePath:(NSString *)path{
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //********************图片********************//

//    要上传的图片
//    UIImage *image=[params objectForKey:fileKey];
    //得到图片的data
    //********************其他文件***************//
    //    NSData * data=[NSData dataWithContentsOfFile:path];
    //******************************************//
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];

    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
//        if(![key isEqualToString:fileKey])
//        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
//        }
    }


//    ////添加分界线，换行
//    [body appendFormat:@"%@\r\n",MPboundary];
//    //声明pic字段，文件名为boris.png
//    NSMutableArray* imageArry=[[NSMutableArray alloc] init];
//    for (UIImage *image in [params objectForKey:fileKey]) {
//        if (UIImagePNGRepresentation(image)) {
//            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.%@\"\r\n",fileKey,name,format];
//            //声明上传文件的格式
//            [body appendFormat:@"Content-Type: %@/%@\r\n\r\n",[self judgeFileWithFormat:format],format];
//            [imageArry addObject:UIImagePNGRepresentation(image)];
//        }
//    }
    //添加字段名称，换2行
//    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",fileKey];
    //添加字段的值
//    [body appendFormat:@"%@\r\n",imageArry];
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    //将image的data加入
//    if (data) {
//        [myRequestData appendData:data];
//    }

    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];

    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%zi", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];

    //建立连接，设置代理
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];


    //设置接受response的data
    if (conn) {
        NSData * mResponseData = [NSMutableData data];
        NSLog(@"%@",mResponseData);
    }
    //菊花


    [self startActivityIndicator];
}
#pragma mark -创建菊花-

-(void)startActivityIndicator{
    UIView * aboveView=[[UIView alloc] initWithFrame:Rect(0, 65, [[[UIApplication sharedApplication] delegate] window].frame.size.width, [[[UIApplication sharedApplication] delegate] window].frame.size.height - 65)];
    [aboveView setTag:1101];
    [aboveView setBackgroundColor:[UIColor clearColor]];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:aboveView];
    //
    UIView * aboveActivity=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [aboveActivity setBackgroundColor:[UIColor blackColor]];
    [aboveActivity.layer setCornerRadius:5.0];
    [aboveActivity.layer setMasksToBounds:YES];
    [aboveActivity setCenterX:aboveView.centerX];
    [aboveActivity setCenterY:aboveView.centerY - 65];
    [aboveActivity setAlpha:0.6];
    [aboveView addSubview:aboveActivity];
    
    UIActivityIndicatorView * activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activity setFrame:CGRectMake(35, 28, 30, 30)];
    
    [aboveActivity addSubview:activity];
   
    
    UILabel *theLabel=[[UILabel alloc]initWithFrame:CGRectMake(10 ,activity.endY+5, 80 , 30)];
    theLabel.text=@"请稍后..";
    theLabel.font=[UIFont systemFontOfSize:16];
    theLabel.textAlignment=NSTextAlignmentCenter;
    theLabel.textColor=[UIColor whiteColor];
    [aboveActivity addSubview:theLabel];
    
    //
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //
    [activity startAnimating];
    


}


-(void)stopActivityIndicator{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    
    [[window viewWithTag:1101] removeFromSuperview];
  
}
#pragma mark -NSURLConnectDelegate  NSURLConnectDataDelegate-

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"the connect error is %@",error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self stopActivityIndicator];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"the response is %@",response);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"the receive data is %@",data);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //
    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    NSData * resultData=[result dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error=nil;
    NSDictionary * resultDic=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingAllowFragments error:&error];
    if (!error) {
        self.loadFinsh(resultDic);
    }
    [self stopActivityIndicator];
}

@end
