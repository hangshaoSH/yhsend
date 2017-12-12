//
//  TJRepaireManagerBaseTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/12.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJRepaireManagerBaseTableViewCell.h"

@implementation TJRepaireManagerBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.textColor = fivelightColor;
    _topstatus.textColor = fivelightColor;
//    _label3.textColor = fivelightColor;
//    _label4.textColor = fivelightColor;
    _label5.textColor = fivelightColor;
    _longtime.textColor = fivelightColor;
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _label2.font = fifteenFont;
    _label3.font = fifteenFont;
    _label4.font = fifteenFont;
    _label5.font = fifteenFont;
    _topstatus.font = fifteenFont;
    _style.font = fifteenFont;
    _longtime.font = fifteenFont;
    _content.font = fifteenFont;
    _addressl.font = fifteenFont;
    _timeL.font = fifteenFont;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJRepaireManagerBaseCell";
    TJRepaireManagerBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepaireManagerCell" owner:self options:nil] firstObject];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    _topstatus.text = dic[@"stastr"];
    _style.text = [NSString stringWithFormat:@"%@[%@]",dic[@"modname"],dic[@"ordertypename"]];
    _addressl.text = dic[@"housename"];
    _timeL.text = dic[@"ordertime"];
    _longtime.text = dic[@"accminstr"];
    if ([dic[@"msgcontent"] length] > 0) {
        _content.text = dic[@"msgcontent"];
        _content.hidden = NO;
    }else {
        _content.text = @"暂无";
        _content.hidden = YES;
    }
    if ([dic[@"sta"] integerValue] == 0) {
        _topstatus.textColor = [UIColor colorWithHexString:@"c9383a"];
        _label0.textColor = [UIColor colorWithHexString:@"c9383a"];
    } else {
        _topstatus.textColor = fivelightColor;
        _label0.textColor = fivelightColor;
    }
}

@end
