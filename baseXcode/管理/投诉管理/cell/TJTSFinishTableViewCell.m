//
//  TJTSFinishTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/15.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJTSFinishTableViewCell.h"

@implementation TJTSFinishTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.textColor = fivelightColor;
    _label1.textColor = fivelightColor;
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _content.font = fifteenFont;
    _bgview.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview.cornerRadius = 5.0;
    _bgview.borderColor = bordercolor;
    _bgview.borderWidth = 0.7;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJTSFinifshCell";
    TJTSFinishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJTouSuDetailCell" owner:self options:nil] objectAtIndex:6];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    if ([dic[@"finishinfo"] isKindOfClass:[NSDictionary class]]) {
        _time.text = dic[@"finishinfo"][@"finishtime"];
        if ([dic[@"finishinfo"][@"finishproc"] length] == 0) {
            _content.text = @"暂无";
        }else {
            _content.text = dic[@"finishinfo"][@"finishproc"];
        }
    } else {
        _time.text = @"";
        _content.text = @"无结果";
    }
}
@end
