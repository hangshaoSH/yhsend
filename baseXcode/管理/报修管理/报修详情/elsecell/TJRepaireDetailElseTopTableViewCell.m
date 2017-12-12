//
//  TJRepaireDetailElseTopTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/8.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJRepaireDetailElseTopTableViewCell.h"


@interface TJRepaireDetailElseTopTableViewCell ()


@end
@implementation TJRepaireDetailElseTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.font = fifteenFont;
    _label0.textColor = fivelightColor;
    _label1.font = fifteenFont;
    _label1.textColor = fivelightColor;
    _label2.font = fifteenFont;
    _label3.font = fifteenFont;
    _label3.textColor = fivelightColor;
    _weixiuren.font = fifteenFont;
    _weixiuxiangmu.font = fifteenFont;
    _weixiujieguo.font = fifteenFont;
    _bgview.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview.cornerRadius = 5.0;
    _bgview.borderColor = bordercolor;
    _bgview.borderWidth = 0.7;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJRepaireDetailElseTopCell";
    TJRepaireDetailElseTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepaireElseDetailCell" owner:self options:nil] objectAtIndex:7];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    if ([dic[@"wxinfo"] count] == 0) {
        _weixiuren.text = @"暂无";
        _weixiuxiangmu.text = @"暂无";
        _weixiujieguo.text = @"暂无";
    }else {
        _weixiuren.text = dic[@"wxinfo"][@"wxclerkname"];
        _weixiuxiangmu.text = dic[@"wxinfo"][@"wxmodname"];
        if ([dic[@"wxinfo"][@"wxresult"] length] == 0) {
            _weixiujieguo.text = @"暂无";
        } else{
            _weixiujieguo.text = dic[@"wxinfo"][@"wxresult"];
        }
    }
}

@end
