//
//  SKMViewController.h
//  baseXcode
//
//  Created by app on 2017/8/13.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface SKMViewController : BaseViewController

@property (nonatomic, assign) NSInteger jumpFlag;//0欠费  1预缴费
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * money;
@property (nonatomic, strong) NSMutableDictionary * jumpDic;
@property (nonatomic, strong) NSMutableArray * sendArray;
@property (nonatomic, strong) NSMutableDictionary  * wydic;
@end
