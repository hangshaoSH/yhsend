//
//  YHCheckNetworkMananger.h
//  网络封装BolckDemo
//
//  Created by ZG-YUH on 15/10/23.
//  Copyright © 2015年 yuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface YHCheckNetworkMananger : NSObject

singleton_Interface(YHCheckNetworkMananger)

@property (nonatomic,assign) int netState;

@end
