//
//  SKRecordNormalTV.m
//  baseXcode
//
//  Created by app on 2017/8/13.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "SKRecordNormalTV.h"

@implementation SKRecordNormalTV

- (void)awakeFromNib {
    [super awakeFromNib];
    _label2.textColor = fivelightColor;
    _label3.textColor = fivelightColor;
    _label4.textColor = fivelightColor;
    _label1.textColor = fivelightColor;
    _numberL.textColor = fivelightColor;
    _styleL.textColor = fivelightColor;
    _addressL.textColor = fivelightColor;
    _timeL.textColor = fivelightColor;
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _label2.font = fifteenFont;
    _label3.font = fifteenFont;
    _label4.font = fifteenFont;
    _label5.font = fifteenFont;
    _moneyL.font = fifteenFont;
    _nameL.font = fifteenFont;
    _numberL.font = fifteenFont;
    _styleL.font = fifteenFont;
    _addressL.font = fifteenFont;
    _timeL.font = fifteenFont;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"sKRecordNormalTV";
    SKRecordNormalTV *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"shoukuanRecord" owner:self options:nil] firstObject];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    _moneyL.text = [NSString stringWithFormat:@"¥%@",dic[@"billpay"]];
    _nameL.text = dic[@"dealname"];
    _numberL.text = dic[@"billcode"];
    _styleL.text = dic[@"paymode"];
    _addressL.text = dic[@"housename"];
    _timeL.text = dic[@"billdate"];
}
@end
