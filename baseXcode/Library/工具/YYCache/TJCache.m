//
//  TJCache.m
//  XiaoAHelp
//
//  Created by hangshao on 16/10/9.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJCache.h"

static TJCache * _chche = nil;
@implementation TJCache

+ (instancetype)shareCache
{
    if (_chche == nil) {
        _chche = [[self alloc] init];
        NSString * path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HSPathName"];
        _chche->_yyCache = [[YYCache alloc] initWithPath:path];
    }
    return _chche;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _chche = [super allocWithZone:zone];
    });
    return _chche;
}
@end
