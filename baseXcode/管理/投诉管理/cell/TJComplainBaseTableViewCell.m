//
//  TJComplainBaseTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/1.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJComplainBaseTableViewCell.h"

@implementation TJComplainBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label1.textColor = fivelightColor;
    _label2.textColor = fivelightColor;
    _label3.textColor = fivelightColor;
    _label4.textColor = fivelightColor;
    _label5.textColor = fivelightColor;
    _numberL.textColor = fivelightColor;
    _contentL.textColor = fivelightColor;
    _addressl.textColor = fivelightColor;
    _timel.textColor = fivelightColor;
    _style.textColor = fivelightColor;
    _number.textColor = fivelightColor;
    _titlel.textColor = fivelightColor;
    _rightStatus.textColor = [UIColor colorWithHexString:@"999999"];
    
    _label1.font = fifteenFont;
    _label2.font = fifteenFont;
    _label3.font = fifteenFont;
    _label4.font = fifteenFont;
    _label5.font = fifteenFont;
    _numberL.font = fifteenFont;
    _contentL.font = fifteenFont;
    _addressl.font = fifteenFont;
    _timel.font = fifteenFont;
    _style.font = fifteenFont;
    _number.font = fifteenFont;
    _titlel.font = fifteenFont;
    _rightStatus.font = fifteenFont;
    _leftLabel.font = fifteenFont;
    _statusL.font = fifteenFont;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJComplainBaseCell";
    TJComplainBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJCpomplainMainCell" owner:self options:nil] firstObject];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    if ([dic[@"isyun"] integerValue] == 1) {
        _rightStatus.text = @"线上";
    }else if ([dic[@"isyun"] integerValue] == 0){
        _rightStatus.text = @"线下";
    } else {
        _rightStatus.text = @"未知";
    }
//    0:未立项   1:已立项未完成  2:已完成未回访  3: 已完成已回访
    if ([dic[@"staname"] isEqualToString:@"未立项"]) {
        _leftLabel.textColor = [UIColor colorWithHexString:@"c9383a"];
        _statusL.textColor = [UIColor colorWithHexString:@"c9383a"];
    }else if ([dic[@"staname"] isEqualToString:@"已立项未完成"]){
        _leftLabel.textColor = [UIColor colorWithHexString:@"57bdb9"];
        _statusL.textColor = [UIColor colorWithHexString:@"57bdb9"];
    }else if ([dic[@"staname"] isEqualToString:@"已完成已回访"]){
        _leftLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _statusL.textColor = [UIColor colorWithHexString:@"999999"];
    }else {
        _leftLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _statusL.textColor = [UIColor colorWithHexString:@"000000"];
    }
    _statusL.text = dic[@"staname"];
    _number.text = dic[@"billcode"];
    _style.text = dic[@"modname"];
    _addressl.text = dic[@"cpname"];
    _timel.text = dic[@"calltime"];
    _titlel.text = dic[@"tousutitle"];
    if ([dic[@"msgcontent"] length] > 0) {
        _contentL.text = dic[@"msgcontent"];
        _contentL.hidden = NO;
    }else {
        _contentL.text = @"暂无";
        _contentL.hidden = YES;
    }
}
@end
