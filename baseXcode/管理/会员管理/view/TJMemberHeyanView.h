//
//  TJMemberHeyanView.h
//  baseXcode
//
//  Created by hangshao on 16/12/1.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^myBlock)(NSString * text);
@interface TJMemberHeyanView : UIView
+(instancetype)sharedInstance;
- (void)setMidViewWithTitle:(NSString *)title returnString:(myBlock)myBlock;
@end
