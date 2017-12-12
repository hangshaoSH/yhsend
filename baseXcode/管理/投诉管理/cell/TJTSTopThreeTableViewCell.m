//
//  TJTSTopThreeTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/15.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJTSTopThreeTableViewCell.h"

@implementation TJTSTopThreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.textColor = fivelightColor;
    _label1.textColor = fivelightColor;
    _label2.textColor = fivelightColor;
    _label3.textColor = fivelightColor;
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _label2.font = fifteenFont;
    _label3.font = fifteenFont;
    _time.font = fifteenFont;
    _lixiangren.font = fifteenFont;
    _content.font = fifteenFont;
    _name.font = fifteenFont;
    _bgview.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview.cornerRadius = 5.0;
    _bgview.borderColor = bordercolor;
    _bgview.borderWidth = 0.7;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJTSTopThreeCell";
    TJTSTopThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJTouSuDetailCell" owner:self options:nil] objectAtIndex:3];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    if ([dic[@"approveinfo"] isKindOfClass:[NSDictionary class]]) {
        _time.text = dic[@"approveinfo"][@"approvetime"];
        if ([dic[@"approveinfo"][@"approveproc"] length] == 0) {
            _content.text = @"无流程";
        }else {
            _content.text = dic[@"approveinfo"][@"approveproc"];
        }
        _name.text = dic[@"approveinfo"][@"approvecheckname"];
        _lixiangren.text = dic[@"approveinfo"][@"approveclerkname"];
    } else {
        _time.text = @"";
        _content.text = @"无流程";;
        _name.text = @"";
        _lixiangren.text = @"";
    }
}
@end
