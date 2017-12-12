//
//  TJRepaireDetailBottomTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/8.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJRepaireDetailBottomTableViewCell.h"

@implementation TJRepaireDetailBottomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.font = fifteenFont;
    _label0.textColor = fivelightColor;
    _label1.font = fifteenFont;
    _label1.textColor = fivelightColor;
    _label2.font = fifteenFont;
    _label2.textColor = fivelightColor;
    _label3.font = fifteenFont;
    _label3.textColor = fivelightColor;
    _rengongfay.font = fifteenFont;
    _cailiaofei.font = fifteenFont;
    _otherfay.font = fifteenFont;
    _allfay.font = fifteenFont;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJRepaireDetailBottomCell";
    TJRepaireDetailBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepaireElseDetailCell" owner:self options:nil] objectAtIndex:9];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    if ([dic count] > 0) {
        _rengongfay.text = [NSString stringWithFormat:@"%.2f",[dic[@"rengongfee"] floatValue]];
        _cailiaofei.text = [NSString stringWithFormat:@"%.2f",[dic[@"cailiaofee"] floatValue]];
        _otherfay.text = [NSString stringWithFormat:@"%.2f",[dic[@"otherfee"] floatValue]];
        _allfay.text = [NSString stringWithFormat:@"%.2f",[dic[@"totalfee"] floatValue]];
    } else {
        _rengongfay.text = @"";
        _cailiaofei.text = @"";
        _otherfay.text = @"";
        _allfay.text = @"";
    }
}
- (IBAction)hiddenOrShow:(id)sender {
    if ([_delegate respondsToSelector:@selector(showOrhiddenDetail)]) {
        [_delegate showOrhiddenDetail];
    }
}
@end
