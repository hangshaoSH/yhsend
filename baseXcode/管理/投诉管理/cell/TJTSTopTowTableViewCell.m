//
//  TJTSTopTowTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/14.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJTSTopTowTableViewCell.h"

@implementation TJTSTopTowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.textColor = fivelightColor;
    _label1.textColor = fivelightColor;
    _label2.textColor = fivelightColor;
    _label3.textColor = fivelightColor;
    _label4.textColor = fivelightColor;
    _label5.textColor = fivelightColor;
    _label6.textColor = fivelightColor;
    _label7.textColor = fivelightColor;
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _label2.font = fifteenFont;
    _label3.font = fifteenFont;
    _label4.font = fifteenFont;
    _label5.font = fifteenFont;
    _label6.font = fifteenFont;
    _label7.font = fifteenFont;
    _time.font = fifteenFont;
    _time1.font = fifteenFont;
    _people.font = fifteenFont;
    _phone1.font = fifteenFont;
    _phone.font = fifteenFont;
    _phone1.font = fifteenFont;
    _address.font = fifteenFont;
    _address1.font = fifteenFont;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJTouSuTopTowCell";
    TJTSTopTowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJTouSuDetailCell" owner:self options:nil] objectAtIndex:1];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic andHidden:(NSInteger)hidden
{
    if (hidden == 0) {
        _bgview.hidden = YES;
        _image1.image = [UIImage imageNamed:@"manager_hidden"];
    } else {
        _bgview.hidden = NO;
        _image1.image = [UIImage imageNamed:@"manager_show"];
    }
    _time.text = dic[@"calltime"];
    _time1.text = dic[@"yufinishtime"];
    if ([dic[@"totype"] integerValue] == 0) {
        _people1.text = @"业户";
    }else if ([dic[@"totype"] integerValue] == 1){
        _people1.text = @"员工";
    }else {
        _people1.text = @"其他";
    }
    if ([dic[@"fromtype"] integerValue] == 0) {
        _people.text = @"业户";
    }else if ([dic[@"fromtype"] integerValue] == 1){
        _people.text = @"员工";
    }else {
        _people.text = @"其他";
    }
    _address.text = dic[@"fromhousename"];
    _address1.text = dic[@"tohousename"];
    _phone.text = dic[@"fromtel"];
    _phone1.text = dic[@"totel"];
}
- (IBAction)topphone:(id)sender {
    if (_phone.text.length == 0) {
        return;
    }
    [[User sharedUser] callUp:_phone.text];
}
- (IBAction)phoneAc:(id)sender {
    if (_phone1.text.length == 0) {
        return;
    }
    [[User sharedUser] callUp:_phone.text];
}
- (IBAction)hiddenOrShow:(id)sender {
    if ([_delegate respondsToSelector:@selector(hiddenOrShowTop)]) {
        [_delegate hiddenOrShowTop];
    }
}

@end
