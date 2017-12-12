//
//  TJMemberDetailViewController.h
//  baseXcode
//
//  Created by hangshao on 16/11/20.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJMemberDetailViewController : BaseViewController
@property (nonatomic,   copy) NSString     * reqid;
@property (nonatomic, copy) void(^MyBlock)();
@end
