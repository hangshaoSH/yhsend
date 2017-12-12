//
//  TJCache.h
//  XiaoAHelp
//
//  Created by hangshao on 16/10/9.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYCache.h"

@interface TJCache : NSObject

@property (nonatomic,   strong) YYCache     * yyCache;

+ (instancetype)shareCache;

@end
