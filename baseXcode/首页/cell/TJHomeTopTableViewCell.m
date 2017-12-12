//
//  TJHomeTopTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/11/25.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJHomeTopTableViewCell.h"

@implementation TJHomeTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _topline.backgroundColor = fiveblueColor;
    _bottomline.backgroundColor = fiveblueColor;
    _titleL.font = [UIFont systemFontOfSize:17 * ScaleModel];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJHomeTopCell";
    TJHomeTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJHomeMainXib" owner:self options:nil] objectAtIndex:4];
    }
    return cell;
}
- (void)setTitle:(NSString *)title andHidden:(BOOL)hidden
{
    _titleL.text = title;
    _topline.hidden = hidden;
}
@end
