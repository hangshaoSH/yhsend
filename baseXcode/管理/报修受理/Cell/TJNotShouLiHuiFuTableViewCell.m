//
//  TJNotShouLiHuiFuTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/14.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJNotShouLiHuiFuTableViewCell.h"

@implementation TJNotShouLiHuiFuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.font = seventeenFont;
    _label0.textColor = fivelightColor;
    _content.font = fifteenFont;
    _bgview.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview.cornerRadius = 5.0;
    _bgview.borderColor = bordercolor;
    _bgview.borderWidth = 0.7;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJNotSayCell";
    TJNotShouLiHuiFuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepaireManagerCell" owner:self options:nil] objectAtIndex:5];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    if ([dic[@"backreply"] length] == 0) {
        _content.text = @"暂无";
    }else {
        _content.text = dic[@"backreply"];
    }
}
@end
