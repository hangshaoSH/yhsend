//
//  TJNotRepaireBottomTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/7.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJNotRepaireBottomTableViewCell.h"

@implementation TJNotRepaireBottomTableViewCell

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
    _people.font = fifteenFont;
    _timeL.font = fifteenFont;
    _yijianL.font = fifteenFont;
    _jianyiL.font = fifteenFont;
    _bgview.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview.cornerRadius = 5.0;
    _bgview.borderColor = bordercolor;
    _bgview.borderWidth = 0.7;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJNotRepaireBottomCell";
    TJNotRepaireBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepaireElseDetailCell" owner:self options:nil] objectAtIndex:3];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    _people.text = dic[@"visitclerkname"];
    _timeL.text = dic[@"visittime"];
    _jianyiL.text = dic[@"commtypename"];
    if ([dic[@"commspec"] length] == 0) {
        _yijianL.text = @"无意见";
    }else {
        _yijianL.text = dic[@"commspec"];
    }
}


@end
