//
//  TJEditeYezhuDataViewController.h
//  baseXcode
//
//  Created by hangshao on 16/11/21.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJEditeYezhuDataViewController : BaseViewController
@property (nonatomic,   copy) NSString     * houseId;
@property (nonatomic,   copy) NSMutableDictionary     * olddataDic;
@property (nonatomic,   copy) NSString     * navTitle;
@property (nonatomic, copy) void(^MyBlock)(NSMutableDictionary * dic);
@end
