//
//  TJReserveTwoTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 17/1/10.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJReserveTwoTableViewCell.h"

@implementation TJReserveTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _label2.font = fifteenFont;
    _label3.font = fifteenFont;
    _label4.font = fifteenFont;
    _label5.font = fifteenFont;
    _label6.font = fifteenFont;
    _orderid.font = fifteenFont;
    _style.font = fifteenFont;
    _number.font = fifteenFont;
    _label0.textColor = fivelightColor;
    _style.textColor = fivelightColor;
    _number.textColor = fivelightColor;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJReserveTwoCell";
    TJReserveTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJReserveManagerCell" owner:self options:nil] objectAtIndex:2];
    }
    return cell;
}
- (void)setDataWithLabel:(NSMutableDictionary *)dic
{
    _style.text = dic[@"storetypename"];
    _number.text = dic[@"storecode"];
    _orderid.text = dic[@"orderid"];
    NSArray * dataarray = [dic[@"logstr"] componentsSeparatedByString:@"^"];
    if (dataarray.count > 0) {
        _label1.text = dataarray[0];
    }else {
        _label1.text = @"暂无";
    }
    if (dataarray.count > 1) {
        _label2.text = dataarray[1];
    }else {
        _label2.text = @"暂无";
    }
    if (dataarray.count > 2) {
        _label3.text = dataarray[2];
    }else {
        _label3.text = @"暂无";
    }
    if (dataarray.count > 3) {
        _label4.text = dataarray[3];
    }else {
        _label4.text = @"暂无";
    }
    if (dataarray.count > 4) {
        _label6.text = dataarray[4];
    }else {
        _label6.text = @"暂无";
    }
    if (dataarray.count > 5) {
        _label5.text = dataarray[5];
    }else {
        _label5.text = @"暂无";
    }
}

@end
