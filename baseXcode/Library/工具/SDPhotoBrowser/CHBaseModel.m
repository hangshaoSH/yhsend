//
//  CHBaseModel.m
//  CollectableHome
//
//  Created by dengjingzhong on 16/5/10.
//  Copyright © 2016年 dengjingzhong. All rights reserved.
//

#import "CHBaseModel.h"

@implementation CHBaseModel

+ (BOOL) isSuccess:(id) s{
    NSDictionary *ary = s;
    return [[ary objectForKey:@"success"] boolValue];
}

+ (NSString*) message:(id) s{
    NSDictionary *ary = s;
    return [ary objectForKey:@"message"];
}

- (NSDictionary*) getEntityData{
    return [self.originDic objectForKey:@"entity"];
}

@end


@implementation CHZImage

@end


@implementation CHReplys

@end

@implementation CHZDianzan

@end


