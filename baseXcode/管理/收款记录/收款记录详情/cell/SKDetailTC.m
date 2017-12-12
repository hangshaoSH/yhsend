//
//  SKDetailTC.m
//  baseXcode
//
//  Created by app on 2017/8/13.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "SKDetailTC.h"

@implementation SKDetailTC

- (void)awakeFromNib {
    [super awakeFromNib];
    _label2.textColor = fivelightColor;
    _label3.textColor = fivelightColor;
    _label4.textColor = fivelightColor;
    _label1.textColor = fivelightColor;
    _label0.textColor = fivelightColor;
    _label5.textColor = fivelightColor;
    _label6.textColor = fivelightColor;
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _label2.font = fifteenFont;
    _label3.font = fifteenFont;
    _label4.font = fifteenFont;
    _label5.font = fifteenFont;
    _label6.font = fifteenFont;
    _moneyL.font = fifteenFont;
    _nameL.font = fifteenFont;
    _yezhu.font = fifteenFont;
    _styleL.font = fifteenFont;
    _addressL.font = fifteenFont;
    _timeL.font = fifteenFont;
    _numebL.font = fifteenFont;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"SKDetailCell";
    SKDetailTC *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SKDetailCell" owner:self options:nil] firstObject];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    _moneyL.text = [NSString stringWithFormat:@"¥%@",dic[@"billpay"]];
    _nameL.text = dic[@"dealname"];
    _numebL.text = dic[@"billcode"];
    _styleL.text = dic[@"paymode"];
    _addressL.text = dic[@"housename"];
    _timeL.text = dic[@"billdate"];
    _yezhu.text = dic[@"houseowner"];
}

@end
