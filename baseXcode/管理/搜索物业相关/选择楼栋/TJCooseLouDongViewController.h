//
//  TJCooseLouDongViewController.h
//  baseXcode
//
//  Created by hangshao on 16/11/22.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJCooseLouDongViewController : BaseViewController
@property (nonatomic,   copy) NSString     *  cpcode;
@property (nonatomic, copy) void(^MyBlock)(NSMutableDictionary * dic);
@end
