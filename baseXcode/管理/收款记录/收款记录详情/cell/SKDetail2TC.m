//
//  SKDetail2TC.m
//  baseXcode
//
//  Created by app on 2017/8/13.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "SKDetail2TC.h"

@implementation SKDetail2TC

- (void)awakeFromNib {
    [super awakeFromNib];
    _leftL.textColor = fivelightColor;
    _midL.textColor = fivelightColor;
    _rightL.textColor = fivelightColor;
    _leftL.font = twelveFont;
    _midL.font = twelveFont;
    _rightL.font = twelveFont;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"SKDetailCell2";
    SKDetail2TC *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SKDetailCell" owner:self options:nil] objectAtIndex:2];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    _leftL.text = dic[@"itemname"];
    _midL.text = dic[@"ysperiod"];
    _rightL.text = [NSString stringWithFormat:@"¥%@",dic[@"ysval"]];
}

@end
