//
//  HSChooseCityView.h
//  baseXcode
//
//  Created by hangshao on 16/11/22.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^cityblock)(NSMutableDictionary * dic);
@interface HSChooseCityView : UIView
+(instancetype)sharedInstance;
- (void)clickAtIndex:(cityblock)block;
@end
