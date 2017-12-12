//
//  TJRepaireComplaintDetailViewController.h
//  baseXcode
//
//  Created by hangshao on 16/12/13.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJRepaireComplaintDetailViewController : BaseViewController
@property (nonatomic,   strong) NSString     * orderid;
@property (nonatomic, copy) void(^MyBlock)();
@end
