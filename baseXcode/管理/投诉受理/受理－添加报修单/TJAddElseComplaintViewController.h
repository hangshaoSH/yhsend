//
//  TJAddElseComplaintViewController.h
//  baseXcode
//
//  Created by hangshao on 16/12/14.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJAddElseComplaintViewController : BaseViewController
@property (nonatomic, copy) void(^MyBlock)();
@property (nonatomic,   assign) NSInteger   jumpFlag;//1受理   0添加
@property (nonatomic,   strong) NSMutableDictionary     * jumpDic;
@end
