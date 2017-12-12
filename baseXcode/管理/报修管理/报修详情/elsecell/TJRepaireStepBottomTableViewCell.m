//
//  TJRepaireStepBottomTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/7.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJRepaireStepBottomTableViewCell.h"

@implementation TJRepaireStepBottomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.font = fifteenFont;
    _label0.textColor = fivelightColor;
    _content.font = fifteenFont;
    _bgview.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview.cornerRadius = 5.0;
    _bgview.borderColor = bordercolor;
    _bgview.borderWidth = 0.7;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJRepaireStepBottomCell";
    TJRepaireStepBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepaireElseDetailCell" owner:self options:nil] objectAtIndex:5];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    if ([dic[@"hiddenStep"] integerValue] == 1) {
        _imageS.image = [UIImage imageNamed:@"manager_hidden"];
        _lineview.hidden = YES;
    }else {
        _imageS.image = [UIImage imageNamed:@"manager_show"];
        _lineview.hidden = NO;
    }
    if ([dic[@"backreply"] length] == 0) {
        _content.text = @"无说明";
    } else {
        _content.text = dic[@"backreply"];
    }
}
- (IBAction)hiddenAc:(id)sender {
    if ([_delegate respondsToSelector:@selector(hiddenOrShowStep)]) {
        [_delegate hiddenOrShowStep];
    }
}
@end
