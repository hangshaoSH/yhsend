//
//  TJRepaireDetailElseViewController.h
//  baseXcode
//
//  Created by hangshao on 16/12/6.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJRepaireDetailElseViewController : BaseViewController
@property (nonatomic, copy) void(^MyBlock)();
@property (nonatomic,   copy) NSString     * billid;
@property (nonatomic,   assign) NSInteger  jumpFlag;//1报修受理详情 0  正常跳
@end
