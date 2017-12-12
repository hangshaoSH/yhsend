//
//  TJManagerOrderBaseTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 17/1/5.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJManagerOrderBaseTableViewCell.h"

@implementation TJManagerOrderBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label1.textColor = fivelightColor;
    _label2.textColor = fivelightColor;
    _label3.textColor = fivelightColor;
    _label4.textColor = fivelightColor;
    _label5.textColor = fivelightColor;
    _label6.textColor = fivelightColor;
    _label7.textColor = fivelightColor;
    _numbert.textColor = [UIColor colorWithHexString:@"999999"];
    
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _label2.font = fifteenFont;
    _label3.font = fifteenFont;
    _label4.font = fifteenFont;
    _label5.font = fifteenFont;
    _label6.font = fifteenFont;
    _label7.font = fifteenFont;
    
    _style.font = fifteenFont;
    _numbert.font = fifteenFont;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJManagerOrderBaseCell";
    TJManagerOrderBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJManagerOrderCell" owner:self options:nil] firstObject];
    }
    return cell;
}
- (void)setDataWithLabel:(NSMutableDictionary *)dic
{
    _numbert.text = dic[@"ordercode"];
    NSArray * array = [dic[@"orderstr"] componentsSeparatedByString:@"^"];
    _label1.text = array[0];
    _label2.text = array[1];
    _label3.text = array[2];
    _label4.text = array[3];
    _label5.text = array[4];
    _label6.text = array[5];
    _label7.text = array[6];
    if (_label6.text.length == 0) {
        _label6.text = @"客户：";
    }else {
        _label6.text = array[5];
    }
    _style.text = dic[@"orderstaname"];
    if ([dic[@"ordersta"] integerValue] == 1) {
        _label0.textColor = [UIColor colorWithHexString:@"c9383a"];
        _style.textColor = [UIColor colorWithHexString:@"c9383a"];
    }else if ([dic[@"ordersta"] integerValue] == 2) {
        _label0.textColor = [UIColor colorWithHexString:@"57bdb9"];
        _style.textColor = [UIColor colorWithHexString:@"57bdb9"];
    }else {
        _label0.textColor = [UIColor colorWithHexString:@"999999"];
        _style.textColor = [UIColor colorWithHexString:@"999999"];
    }
}
@end
