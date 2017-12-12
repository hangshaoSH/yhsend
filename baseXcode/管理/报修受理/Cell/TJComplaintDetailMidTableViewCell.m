//
//  TJComplaintDetailMidTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/13.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJComplaintDetailMidTableViewCell.h"

@implementation TJComplaintDetailMidTableViewCell

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
    _people.font = fifteenFont;
    _phone.font = fifteenFont;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJComplaintDetailMidCell";
    TJComplaintDetailMidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepaireManagerCell" owner:self options:nil] objectAtIndex:2];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    _address.text = dic[@"housename"];
    _time.text = dic[@"calltime"];
    _people.text = dic[@"callname"];
    _phone.text = dic[@"calltel"];
}
- (IBAction)phoneAc:(id)sender {
    if (_phone.text.length == 0) {
        return;
    }
    [[User sharedUser] callUp:_phone.text];
}
@end
