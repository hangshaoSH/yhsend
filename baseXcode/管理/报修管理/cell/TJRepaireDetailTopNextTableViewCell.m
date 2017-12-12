//
//  TJRepaireDetailTopNextTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/6.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJRepaireDetailTopNextTableViewCell.h"

@implementation TJRepaireDetailTopNextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lable0.font = fifteenFont;
    _lable0.textColor = fivelightColor;
    _label1.font = fifteenFont;
    _label1.textColor = fivelightColor;
    _label2.font = fifteenFont;
    _label2.textColor = fivelightColor;
    _label3.font = fifteenFont;
    _label3.textColor = fivelightColor;
    _address.font = fifteenFont;
    _time.font = fifteenFont;
    _people.font = fifteenFont;
    _phone.font = fifteenFont;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJRepaireDetailTopNextCell";
    TJRepaireDetailTopNextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepireDetailCell" owner:self options:nil] objectAtIndex:1];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    if ([dic[@"hiddenTop"] integerValue] == 1) {
        _bgview.hidden = YES;
        _hiddenimage.image = [UIImage imageNamed:@"manager_hidden"];
    }else {
        _bgview.hidden = NO;
        _hiddenimage.image = [UIImage imageNamed:@"manager_show"];
    }
    _address.text = dic[@"housename"];
    _time.text = dic[@"calltime"];
    _people.text = dic[@"callname"];
    _phone.text = dic[@"calltel"];
}
- (IBAction)hiddenOrNoHidden:(id)sender {
    if ([_delegate respondsToSelector:@selector(hiddenAction)]) {
        [_delegate hiddenAction];
    }
}
- (IBAction)phoneAc:(id)sender {
    if (_phone.text.length == 0) {
        return;
    }
    [[User sharedUser] callUp:_phone.text];
}
@end
