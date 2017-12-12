//
//  TJRepairBaseTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/1.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJRepairBaseTableViewCell.h"

@implementation TJRepairBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.textColor = fivelightColor;
    _label1.textColor = fivelightColor;
    _label2.textColor = fivelightColor;
    _label3.textColor = fivelightColor;
    _label4.textColor = fivelightColor;
    _numberL.textColor = fivelightColor;
    _contentL.textColor = fivelightColor;
    _addressL.textColor = fivelightColor;
    _timeL.textColor = fivelightColor;
    _styleL.textColor = fivelightColor;
    _rightStatus.textColor = [UIColor colorWithHexString:@"999999"];
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _label2.font = fifteenFont;
    _label3.font = fifteenFont;
    _label4.font = fifteenFont;
    _statusL.font = fifteenFont;
    _rightStatus.font = fifteenFont;
    _leftTitle.font = fifteenFont;
    _numberL.font = fifteenFont;
    _contentL.font = fifteenFont;
    _addressL.font = fifteenFont;
    _timeL.font = fifteenFont;
    _styleL.font = fifteenFont;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJRepairBaseCell";
    TJRepairBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepairMainCell" owner:self options:nil] firstObject];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic flag:(NSInteger)flag
{
    if (flag == 0) {//保修列表
        if ([dic[@"isyun"] integerValue] == 0){
            _rightStatus.text = @"线下";
        } else {
            _rightStatus.text = @"线上";
        }
    } else if (flag == 1) {//工程抢单列表
        _rightStatus.text = @"未接单";
    } else if (flag == 2){//工程维修列表
        _rightStatus.text = dic[@"acceptclerkname"];
    } else {
        
    }
    //0:未派单   1:已派单  2:待修中  3:进行中  5:已完成未回访
//    6:已完成已回访  9:不维修
    if ([dic[@"sta"] integerValue] == 0) {
        _leftTitle.textColor = [UIColor colorWithHexString:@"c9383a"];
        _statusL.textColor = [UIColor colorWithHexString:@"c9383a"];
    }else if ([dic[@"sta"] integerValue] == 1) {
        _leftTitle.textColor = [UIColor colorWithHexString:@"57bdb9"];
        _statusL.textColor = [UIColor colorWithHexString:@"57bdb9"];
    }else if ([dic[@"sta"] integerValue] == 2) {
        _leftTitle.textColor = [UIColor colorWithHexString:@"57bdb9"];
        _statusL.textColor = [UIColor colorWithHexString:@"57bdb9"];
    }else  if ([dic[@"sta"] integerValue] == 3) {
        _leftTitle.textColor = [UIColor colorWithHexString:@"57bdb9"];
        _statusL.textColor = [UIColor colorWithHexString:@"57bdb9"];
    }else if ([dic[@"sta"] integerValue] == 5) {
        _leftTitle.textColor = [UIColor colorWithHexString:@"2c2c2c"];
        _statusL.textColor = [UIColor colorWithHexString:@"2c2c2c"];
    }else if ([dic[@"sta"] integerValue] == 6) {
        _leftTitle.textColor = [UIColor colorWithHexString:@"999999"];
        _statusL.textColor = [UIColor colorWithHexString:@"999999"];
    }else if ([dic[@"sta"] integerValue] == 9) {
        _leftTitle.textColor = [UIColor colorWithHexString:@"999999"];
        _statusL.textColor = [UIColor colorWithHexString:@"999999"];
    }else {
        _leftTitle.textColor = [UIColor colorWithHexString:@"000000"];
        _statusL.textColor = [UIColor colorWithHexString:@"000000"];
    }
    _statusL.text = dic[@"staname"];
    _numberL.text = dic[@"billcode"];
    _styleL.text = [NSString stringWithFormat:@"%@[%@]",dic[@"modname"],dic[@"ordertypename"]];
    _contentL.text = dic[@"msgcontent"];
    _addressL.text = dic[@"housename"];
    _timeL.text = dic[@"calltime"];
}
@end
