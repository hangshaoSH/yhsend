//
//  TJComplaintDetailBottomTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/13.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJComplaintDetailBottomTableViewCell.h"

@implementation TJComplaintDetailBottomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _label3.font = seventeenFont;
    _label0.textColor = fivelightColor;
    _label1.textColor = fivelightColor;
    _time.font = fifteenFont;
    _people.font = fifteenFont;
    _status.font = fifteenFont;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJComplaintDetailBottomCell";
    TJComplaintDetailBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepaireManagerCell" owner:self options:nil] objectAtIndex:3];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    _people.text = dic[@"acceptclerkname"];
    _time.text = dic[@"accepttime"];
    if ([dic[@"billinfo"] isKindOfClass:[NSDictionary class]]) {
        _numberL.text = dic[@"billinfo"][@"billcode"];
        _status.text = dic[@"billinfo"][@"billstaname"];
    }else {
         _numberL.text = @"缺省";
        _status.text = @"缺省";
    }
}
- (IBAction)goToAc:(id)sender {
    if ([_delegate respondsToSelector:@selector(jumpDetail)]) {
        [_delegate jumpDetail];
    }
}
@end
