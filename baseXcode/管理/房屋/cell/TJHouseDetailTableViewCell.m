//
//  TJHouseDetailTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/11/21.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJHouseDetailTableViewCell.h"

@implementation TJHouseDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.font = fifteenFont;
    _label0.textColor = sevenlightColor;
    _label1.font = fifteenFont;
    _label1.textColor = sevenlightColor;
    _label2.font = fifteenFont;
    _label2.textColor = sevenlightColor;
    _label3.font = fifteenFont;
    _label3.textColor = sevenlightColor;
    _editeL.font = fifteenFont;
    _editeL.textColor = fiveblueColor;
    _deleteL.font = fifteenFont;
    _deleteL.textColor = fiveblueColor;
    _line1.backgroundColor = sixblueColor;
    _line1.cornerRadius = 2;
    _line2.backgroundColor = sixblueColor;
    _line2.cornerRadius = 2;
    _line3.backgroundColor = sixblueColor;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJHouseDetailBaseTableViewCell";
    TJHouseDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJHouseCell" owner:self options:nil] objectAtIndex:2];
    }
    return cell;
}
- (void)setDataWithLabel:(NSMutableDictionary *)dic
{
    _nameL.text = dic[@"ownername"];
    _styleL.text = [NSString stringWithFormat:@"%@  %@",dic[@"anjie"],dic[@"isfirst"]];
    if ([dic[@"cardno"] length] > 0) {
        _shenfenzheng.text = dic[@"cardno"];
    }else {
        _shenfenzheng.text = @"暂无";
    }
    if ([dic[@"mobile"] length] > 0) {
        _phoneL.text = dic[@"mobile"];
    }else {
        _phoneL.text = @"暂无";
    }
}
- (IBAction)deletAc:(id)sender {
    [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"是否删除" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if ([_delegate respondsToSelector:@selector(deleteYeZhuxinxi:)]) {
                [_delegate deleteYeZhuxinxi:sender];
            }
        }
    }];
}
- (IBAction)editeAc:(id)sender {
    if ([_delegate respondsToSelector:@selector(editYeZhuxinxi:)]) {
        [_delegate editYeZhuxinxi:sender];
    }
}
@end
