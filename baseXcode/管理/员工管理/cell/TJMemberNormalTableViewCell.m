//
//  TJMemberNormalTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/11/28.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJMemberNormalTableViewCell.h"

@implementation TJMemberNormalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _nameL.font = seventeenFont;
    _nameL.textColor = [UIColor colorWithHexString:@"3e3e3e"];
    _zhiwei.font = seventeenFont;
    _zhiwei.textColor = [UIColor colorWithHexString:@"3e3e3e"];
    _phoneL.font = seventeenFont;
    _phoneL.textColor = [UIColor colorWithHexString:@"3e3e3e"];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJMemberNormalCell";
    TJMemberNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJPersonManagerCell" owner:self options:nil] objectAtIndex:1];
    }
    return cell;
}
- (void)setdataWithDic:(NSMutableDictionary *)dic
{
    _nameL.text = dic[@"clerkname"];
    _zhiwei.text = dic[@"dutyname"];
    _phoneL.text = dic[@"mobile"];
    if ([dic[@"hidden"] integerValue] == 1) {
        _gouImage.hidden = YES;
    } else {
        _gouImage.hidden = NO;
    }
    if ([dic[@"otherHidden"] integerValue] == 1) {
        _jiantouImage.hidden = YES;
    } else {
        _jiantouImage.hidden = NO;
    }
    if ([[dic allKeys] containsObject:@"select"]) {
        if ([dic[@"select"] integerValue] == 1) {
            _gouImage.image = [UIImage imageNamed:@"house_gouxuan_select"];
        }else {
            _gouImage.image = [UIImage imageNamed:@"house_gouxuan_normal"];
        }
    }else {
        _gouImage.image = [UIImage imageNamed:@"house_gouxuan_normal"];
    }
}

@end
