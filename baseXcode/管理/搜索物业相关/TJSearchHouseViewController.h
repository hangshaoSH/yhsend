//
//  TJSearchHouseViewController.h
//  baseXcode
//
//  Created by hangshao on 16/11/21.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJSearchHouseViewController : BaseViewController
@property (nonatomic, copy) void(^MyBlock)();
@property (nonatomic,   copy) NSString     * jumpFlag;//会员核验详情
@property (nonatomic,   copy) NSMutableDictionary     * jumpDic;
@end
