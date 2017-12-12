//
//  TJHomeNormalTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/11/25.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJHomeNormalTableViewCell.h"

@implementation TJHomeNormalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bgview.borderWidth = 0.7;
    _bgview.borderColor = [UIColor colorWithHexString:@"d0d0d0"];
    _bgview.cornerRadius = 5.0;
    _timeL.font = fourteenFont;
    _timeL.textColor = [UIColor colorWithHexString:@"888888"];
    _addreeL.font = fourteenFont;
    _addreeL.textColor = [UIColor colorWithHexString:@"888888"];
    _contentL.font = fourteenFont;
    _contentL.textColor = [UIColor colorWithHexString:@"2c2c2c"];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJHomebaseCell";
    TJHomeNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJHomeMainXib" owner:self options:nil] lastObject];
    }
    return cell;
}
- (void)setdataWithDic:(NSMutableDictionary *)dic
{
    _timeL.text = dic[@"reqtime"];
    _addreeL.text = dic[@"cpname"];
    _contentL.text = dic[@"content"];
}
@end
