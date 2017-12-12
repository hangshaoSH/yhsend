//
//  TJRepaireDetailViewController.h
//  baseXcode
//
//  Created by hangshao on 16/12/2.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJRepaireDetailViewController : BaseViewController
@property (nonatomic,   copy) NSString     * billid;
@property (nonatomic,   assign) NSInteger   count;//上传图片限制张数
@property (nonatomic, copy) void(^MyBlock)();
@property (nonatomic, copy) void(^jumpBlock)(NSMutableDictionary * dic);//1不维修刷新  2维修刷新
@property (nonatomic,   assign) NSInteger  jumpFlag;//1报修受理详情 0  正常跳  2工程抢单 强制性自己接取
@end
