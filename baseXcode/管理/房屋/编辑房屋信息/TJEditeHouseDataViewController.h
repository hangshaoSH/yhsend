//
//  TJEditeHouseDataViewController.h
//  baseXcode
//
//  Created by hangshao on 16/11/23.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJEditeHouseDataViewController : BaseViewController
@property (nonatomic,   copy) NSString     * houseId;
@property (nonatomic,   copy) NSString     * navTitle;
@property (nonatomic,   copy) NSMutableDictionary     * oldDataDic;
@property (nonatomic, copy) void(^refreshBlock)();
@end
