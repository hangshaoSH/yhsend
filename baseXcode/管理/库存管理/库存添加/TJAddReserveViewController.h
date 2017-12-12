//
//  TJAddReserveViewController.h
//  baseXcode
//
//  Created by hangshao on 17/1/11.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJAddReserveViewController : BaseViewController
@property (nonatomic, copy) void(^refreshBlock)(NSInteger flag);
@end
