//
//  TJTouSuDetailViewController.h
//  baseXcode
//
//  Created by hangshao on 16/12/14.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJTouSuDetailViewController : BaseViewController
@property (nonatomic,   strong) NSString     * billid;
@property (nonatomic, copy) void(^MyBlock)();
@property (nonatomic,   assign) NSInteger jumpFlag;
@end
