//
//  TJTouSuMidTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/14.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJTouSuMidTableViewCell.h"

@implementation TJTouSuMidTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _label2.font = fifteenFont;
    _label3.font = fifteenFont;
    _label0.textColor = fivelightColor;
    _label1.textColor = fivelightColor;
    _label2.textColor = fivelightColor;
    _label3.textColor = fivelightColor;
    _address.font = fifteenFont;
    _time.font = fifteenFont;
    _nameL.font = fifteenFont;
    _phone.font = fifteenFont;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJTouSuDetailMidCell";
    TJTouSuMidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJComplaintAcceptCell" owner:self options:nil] objectAtIndex:2];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    _nameL.text = [NSString stringWithFormat:@"%@－%@",dic[@"fromtypename"],dic[@"callname"]];
    _time.text = dic[@"calltime"];
    _address.text = dic[@"fromname"];
    _phone.text = dic[@"calltel"];
}
- (IBAction)phoneAc:(id)sender {
    if (_phone.text.length == 0) {
        return;
    }
    [[User sharedUser] callUp:_phone.text];
}

@end
