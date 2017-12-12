//
//  YHLabel.m
//  chlidfios
//
//  Created by ZG-WANQ on 15/8/7.
//  Copyright (c) 2015年 yuhuan. All rights reserved.
//

#import "YHLabel.h"
@implementation YHLabel
+(void)LabelToFit:(UILabel *)laebl{
    [laebl setNumberOfLines:0];
    NSDictionary *attribute = @{NSFontAttributeName: laebl.font};
    CGSize retSize = [laebl.text boundingRectWithSize:laebl.size
                                              options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                           attributes:attribute
                                              context:nil].size;
    laebl.frame=CGRectMake(laebl.X, laebl.y, retSize.width, retSize.height);
}
@end
