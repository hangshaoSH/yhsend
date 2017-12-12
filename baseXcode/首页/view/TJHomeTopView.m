//
//  TJHomeTopView.m
//  baseXcode
//
//  Created by hangshao on 16/11/18.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJHomeTopView.h"

@implementation TJHomeTopView
- (void)awakeFromNib
{
    [super awakeFromNib];
    _nowDayShow.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _xingqi.font = [UIFont systemFontOfSize:16 * ScaleModel];
    _rightBut.titleFont = 14 * ScaleModel;
    _rightBut.cornerRadius = 5.0;
    _rightBut.borderColor = [UIColor whiteColor];
    _rightBut.borderWidth = 1;
}

- (IBAction)rightAc:(id)sender {
    [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"是否切换用户" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if ([_delegate respondsToSelector:@selector(changePerson)]) {
                [_delegate changePerson];
            }
        }
    }];
}

@end
