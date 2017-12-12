//
//  TJPubMessageDetailViewController.h
//  baseXcode
//
//  Created by hangshao on 17/1/3.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJPubMessageDetailViewController : BaseViewController
@property (nonatomic,   copy) NSString     * navTitle;
@property (nonatomic,   copy) NSString     * urlStr;
@property (nonatomic,   copy) NSString     * newsid;
@property (nonatomic, copy) void(^refreshBlock)();
@end
