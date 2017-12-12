//
//  TJRepaireShowPeopleTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/6.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJRepaireShowPeopleTableViewCell.h"

@implementation TJRepaireShowPeopleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.font = fifteenFont;
    _label0.textColor = fivelightColor;
    _label1.font = fifteenFont;
    _label1.textColor = fivelightColor;
    _label2.font = fifteenFont;
    _label2.textColor = fivelightColor;
    _getorderpeople.font = fifteenFont;
    _weixiutime.font = fifteenFont;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJRepaireShowPeopleDataCell";
    TJRepaireShowPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepireDetailCell" owner:self options:nil] objectAtIndex:3];
    }
    return cell;
}
- (IBAction)addAc:(id)sender {
    if ([_delegate respondsToSelector:@selector(addStepAction)]) {
        [_delegate addStepAction];
    }
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        _getorderpeople.text = dic[@"acceptclerkname"];
        _weixiutime.text = dic[@"yufinishtime"];
    }else {
        _getorderpeople.text = @"";
        _weixiutime.text = @"";
    }
}
@end
