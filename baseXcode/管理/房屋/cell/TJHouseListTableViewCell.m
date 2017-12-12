//
//  TJHouseListTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/11/18.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJHouseListTableViewCell.h"

@implementation TJHouseListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
     _addressL.font = fifteenFont;
    _label0.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _label2.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _label3.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _wyStyle.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _wyStatus.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _huxing.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _areaL.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _label0.textColor = [UIColor colorWithHexString:@"575757"];
    _label1.textColor = [UIColor colorWithHexString:@"575757"];
    _label2.textColor = [UIColor colorWithHexString:@"575757"];
    _label3.textColor = [UIColor colorWithHexString:@"575757"];
    _wyStyle.textColor = [UIColor colorWithHexString:@"575757"];
    _wyStatus.textColor = [UIColor colorWithHexString:@"575757"];
    _huxing.textColor = [UIColor colorWithHexString:@"575757"];
    _areaL.textColor = [UIColor colorWithHexString:@"575757"];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJHousenormalTableViewCell";
    TJHouseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJHouseCell" owner:self options:nil] firstObject];
    }
    return cell;
}
- (void)setDataWithLabel:(NSMutableDictionary *)dic
{
    _addressL.text = [NSString stringWithFormat:@"%@－%@－%@",dic[@"cpname"],dic[@"buildname"],dic[@"housename"]];
    _wyStyle.text = dic[@"housetype"];
    if ([dic[@"housesta"] length] > 0) {
        _wyStatus.text = dic[@"housesta"];
    }else {
        _wyStatus.text = @"未知";
    }
    if ([dic[@"unittype"] length] > 0) {
        _huxing.text = dic[@"unittype"];
    }else {
        _huxing.text = @"未知";
    }
    if ([dic[@"buildarea"] length] > 0) {
        _areaL.text = dic[@"buildarea"];
    }else {
        _areaL.text = @"未知";
    }
}
@end
