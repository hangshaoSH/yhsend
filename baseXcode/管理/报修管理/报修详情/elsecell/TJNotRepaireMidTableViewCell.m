//
//  TJNotRepaireMidTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/6.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJNotRepaireMidTableViewCell.h"

@implementation TJNotRepaireMidTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.font = fifteenFont;
    _label0.textColor = fivelightColor;
    _label1.font = fifteenFont;
    _label1.textColor = fivelightColor;
    _label2.font = fifteenFont;
    _label2.textColor = fivelightColor;
    _label3.font = fifteenFont;
    _label3.textColor = fivelightColor;
    _nameL.font = fifteenFont;
    _countL.font = fifteenFont;
    _weixiutime.font = fifteenFont;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJNotRepaireMidCell";
    TJNotRepaireMidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepaireElseDetailCell" owner:self options:nil] objectAtIndex:0];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    if ([dic[@"acceptinfo"] isKindOfClass:[NSString class]]) {
        _nameL.text = @"";
        _weixiutime.text = @"";
        _countL.text = @"";
        return;
    }
    _nameL.text = dic[@"acceptinfo"][@"acceptclerkname"];
    _weixiutime.text = dic[@"acceptinfo"][@"yufinishtime"];
    _countL.text = [NSString stringWithFormat:@"%d步",[dic[@"procinfo"] count]];
}

@end
