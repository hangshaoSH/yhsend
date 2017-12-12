//
//  TJKeepBaseTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 17/1/3.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJKeepBaseTableViewCell.h"

@implementation TJKeepBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _label2.font = fifteenFont;
    _label3.font = fifteenFont;
    _label1.textColor = fivelightColor;
    _label2.textColor = fivelightColor;
    _label3.textColor = fivelightColor;
    _time.font = fifteenFont;
    _title.font = fifteenFont;
    _name.font = fifteenFont;
    _content.font = fifteenFont;
    _content.textColor = fivelightColor;
    _name.textColor = fivelightColor;
    _time.textColor = fivelightColor;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJKeepCell";
    TJKeepBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJKeepBaseCell" owner:self options:nil] firstObject];
    }
    return cell;
}
- (void)setDataWithDic:(NSMutableDictionary *)dic
{
    if ([dic[@"newsspec"] length] == 0) {
        _content.text = @"暂无";
    }else {
        _content.text = dic[@"newsspec"];
    }
    _title.text = dic[@"newstitle"];
    _time.text = dic[@"newsdate"];
    _name.text = dic[@"newspub"];
}
@end
