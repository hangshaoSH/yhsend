//
//  NSData+ConvertToArrayAndDictionary.h
//  XunChangApp
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 zhangyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ConvertToArrayAndDictionary)

///  把Data转换成array
- (NSMutableArray *)toArray;
///  把Data转换成dictionary
- (NSMutableDictionary *)toDictionary;
///  把Data转换成string
- (NSString *)toString;

@end

@interface NSDictionary (ConvertToData)
///  转换成data
- (NSData *)data;

@end

@interface NSArray (ConvertToData)

///  转换成data
- (NSData *)data;

@end

@interface NSString (ConvertToData)

///  转换成data
- (NSData *)data;
@end
