//
//  TJOrderLabelTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 17/1/9.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJOrderLabelTableViewCell.h"

@implementation TJOrderLabelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _concent.font = fifteenFont;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJOrderLabelCell";
    TJOrderLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJOrderDetailCell" owner:self options:nil] objectAtIndex:6];
    }
    return cell;
}
- (void)setDataWithLabel:(NSMutableDictionary *)dic
{
}
@end
