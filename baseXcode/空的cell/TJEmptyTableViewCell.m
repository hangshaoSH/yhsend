//
//  TJEmptyTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/11/18.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJEmptyTableViewCell.h"

@implementation TJEmptyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJEmptyCell";
    TJEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJEmptyCell" owner:self options:nil] firstObject];
    }
    return cell;
}
- (void)setLabel:(NSString *)title andFont:(CGFloat)font andColor:(id)color
{
    _showLabel.text = title;
    _showLabel.font = [UIFont systemFontOfSize:font * ScaleModel];
    if ([color isKindOfClass:[NSString class]]) {
        NSString * str = color;
        if (str.length > 0) {
           _showLabel.textColor = [UIColor colorWithHexString:color];
        }
    }else {
       _showLabel.textColor = color;
    }
    if (title.length == 0) {
        _imageEmpty.hidden = NO;
    }else {
        _imageEmpty.hidden = YES;
    }
}
@end
