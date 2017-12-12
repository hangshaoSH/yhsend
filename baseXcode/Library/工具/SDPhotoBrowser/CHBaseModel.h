//
//  CHBaseModel.h
//  CollectableHome
//
//  Created by dengjingzhong on 16/5/10.
//  Copyright © 2016年 dengjingzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface CHBaseModel : NSObject

@property (nonatomic, strong) NSDictionary *originDic;

@property (nonatomic, copy) NSString * code;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *message;

- (NSDictionary*) getEntityData;
+ (BOOL) isSuccess:(id) s;
+ (NSString*) message:(id) s;

@end

@interface CHZImage : NSObject

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, copy) NSString *path;

@property (nonatomic, assign) CGFloat height;

@end

@interface CHReplys : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger replyid;

@property (nonatomic, copy) NSString *name;

@end

@interface CHZDianzan : NSObject

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, assign) NSInteger memberid;

@end
