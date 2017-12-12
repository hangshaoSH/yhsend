//
//  TJChooseAddressViewController.h
//  baseXcode
//
//  Created by hangshao on 16/11/22.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJChooseAddressViewController : BaseViewController
@property (nonatomic, copy) void(^MyBlock)(NSMutableDictionary * dic);
@property (nonatomic,   assign) NSInteger  cankuJump;
@end
