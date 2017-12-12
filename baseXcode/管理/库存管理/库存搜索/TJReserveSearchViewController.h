//
//  TJReserveSearchViewController.h
//  baseXcode
//
//  Created by hangshao on 17/1/11.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJReserveSearchViewController : BaseViewController
@property (nonatomic, copy) void(^MyBlock)(NSMutableDictionary * dic);
@property (nonatomic, copy) void(^refreshBlock)();
@end
