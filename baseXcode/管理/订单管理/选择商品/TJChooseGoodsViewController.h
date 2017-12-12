//
//  TJChooseGoodsViewController.h
//  baseXcode
//
//  Created by hangshao on 17/1/5.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJChooseGoodsViewController : BaseViewController
@property (nonatomic, copy) void(^MyBlock)(NSMutableDictionary * dic);
@property (nonatomic,   copy) NSString     * cpcode;
@property (nonatomic,   assign) NSInteger   cangkuJump;
@end
