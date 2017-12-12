//
//  TJProjectSearchViewController.h
//  baseXcode
//
//  Created by hangshao on 16/12/19.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJProjectSearchViewController : BaseViewController
@property (nonatomic, copy) void(^MyBlock)(NSMutableDictionary * dic);
@property (nonatomic, copy) void(^refreshBlock)();
@property (nonatomic,   assign) NSInteger   jumpFlag;//0工程抢单  1工程维修
@end
