//
//  TJManagerNormalCollectionViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/11/24.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJManagerNormalCollectionViewCell.h"

@implementation TJManagerNormalCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"TJManagerCollectionCell" owner:nil options:nil] firstObject];
//        self.borderColor = [UIColor groupTableViewBackgroundColor];
//        
//        self.borderWidth = 1;
    }
    
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    _redview.backgroundColor = [UIColor redColor];
    _redview.cornerRadius = 8;
    _redcount.textColor = [UIColor whiteColor];
    _redcount.font = twelveFont;
    _midlabel.font = fourteenFont;
}
- (IBAction)buttonAc:(id)sender {
    if ([_delegate respondsToSelector:@selector(buttonAc:)]) {
        [_delegate buttonAc:sender];
    }
}

@end
