//
//  TJOrderBottomTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 17/1/9.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJOrderBottomTableViewCell.h"

@implementation TJOrderBottomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.textColor = fivelightColor;
    _label0.font = fifteenFont;
    _time.font = fifteenFont;
    _countt.font = fifteenFont;
    _name.font = fifteenFont;
    _phone.font = fifteenFont;
    _remark.font = fifteenFont;
    _sureno.font = fifteenFont;
    _surepeople.font = fifteenFont;
    _suretime.font = fifteenFont;
    _bgview.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview.cornerRadius = 5.0;
    _bgview.borderColor = bordercolor;
    _bgview.borderWidth = 0.7;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJOrderDetailBottomCell";
    TJOrderBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJOrderDetailCell" owner:self options:nil] objectAtIndex:3];
    }
    return cell;
}
- (void)setDataWithLabel:(NSString *)str andFlag:(NSInteger)flag
{
    if (flag == 0) {
        _label0.text = @"配送信息";
    }else
    if (flag == 1) {
        _label0.text = @"换货信息";
    }else{
        _label0.text = @"退货信息";
    }
    NSArray * dataarray = [str componentsSeparatedByString:@"^"];
    if (dataarray.count > 0) {
        _time.text = dataarray[0];
    }
    if (dataarray.count > 1) {
        _countt.text = dataarray[1];
    }
    if (dataarray.count > 2) {
        _name.text = dataarray[2];
    }
    if (dataarray.count > 3) {
        _phone.text = dataarray[3];
    }
    if (dataarray.count > 4) {
        _remark.text = dataarray[4];
    }
    if (dataarray.count > 5) {
        _sureno.text = dataarray[5];
    }
    if (dataarray.count > 6) {
        _surepeople.text = dataarray[6];
    }
    if (dataarray.count > 7) {
        _suretime.text = dataarray[7];
    }
}

@end
