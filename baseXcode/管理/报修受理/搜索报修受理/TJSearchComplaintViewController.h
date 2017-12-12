//
//  TJSearchComplaintViewController.h
//  baseXcode
//
//  Created by hangshao on 16/12/13.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJSearchComplaintViewController : BaseViewController
@property (nonatomic, copy) void(^MyBlock)(NSMutableDictionary * dic);
@property (nonatomic, copy) void(^refreshBlock)();
@property (nonatomic,   assign) NSInteger   jumpFlag;//0报修单列表  1投诉单列表
@end
