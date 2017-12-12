//
//  TJSearchOrderViewController.h
//  baseXcode
//
//  Created by hangshao on 17/1/5.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJSearchOrderViewController : BaseViewController
@property (nonatomic, copy) void(^myBlock)(NSMutableDictionary * dic);
@end
