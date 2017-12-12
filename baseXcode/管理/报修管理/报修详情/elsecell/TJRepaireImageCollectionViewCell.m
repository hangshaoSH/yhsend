//
//  TJRepaireImageCollectionViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/7.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJRepaireImageCollectionViewCell.h"

@implementation TJRepaireImageCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"TJRepaireimageCell" owner:nil options:nil] firstObject];
        
        
    }
    
    return self;
}
@end
