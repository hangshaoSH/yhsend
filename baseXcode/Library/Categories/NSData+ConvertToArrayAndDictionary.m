//
//  NSData+ConvertToArrayAndDictionary.m
//  XunChangApp
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 zhangyong. All rights reserved.
//

#import "NSData+ConvertToArrayAndDictionary.h"

@implementation NSData (ConvertToArrayAndDictionary)

- (NSMutableArray *)toArray {
    if (!self) return nil;
    return [[NSKeyedUnarchiver unarchiveObjectWithData:self] mutableCopy];
}

- (NSMutableDictionary *)toDictionary {
    if (!self) return nil;
    return [[NSKeyedUnarchiver unarchiveObjectWithData:self] mutableCopy];
}

- (NSString *)toString {
    if (!self) return nil;
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}
@end

@implementation NSString (ConvertToData)

- (NSData *)data {
    if (!self) return nil;
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

@end

@implementation NSDictionary (ConvertToData)

- (NSData *)data {
    if (!self) return nil;
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

@end

@implementation NSArray (ConvertToData)

- (NSData *)data {
    if (!self) return nil;
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

@end
