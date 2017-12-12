//
//  TJPersonEditDataViewController.h
//  baseXcode
//
//  Created by hangshao on 16/11/29.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJPersonEditDataViewController : BaseViewController
@property (nonatomic,   copy) NSMutableDictionary     * personOldData;
@property (nonatomic,   copy) NSString     * navTitle;
@property (nonatomic,   copy) NSString     * personID;
@property (nonatomic, copy) void(^MyBlock)(NSMutableDictionary * dic);
@end
