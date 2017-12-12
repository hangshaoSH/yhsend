//
//  TJComplaintDetailViewController.h
//  baseXcode
//
//  Created by hangshao on 16/12/14.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJComplaintDetailViewController : BaseViewController
@property (nonatomic,   strong) NSString     * orderid;
@property (nonatomic, copy) void(^MyBlock)();
@end
