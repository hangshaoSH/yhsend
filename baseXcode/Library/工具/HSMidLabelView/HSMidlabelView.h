//
//  HSMidlabelView.h
//  baseXcode
//
//  Created by hangshao on 16/11/21.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^myblock)(NSMutableDictionary * dic);
@interface HSMidlabelView : UIView
+(instancetype)sharedInstance;
- (void)setOriginX:(CGFloat)x andOriginY:(CGFloat)y andWidth:(CGFloat)w andHeight:(CGFloat)h andData:(NSMutableArray *)dataArray withString:(NSString *)colorString clickAtIndex:(myblock)indexBlock;
@end
