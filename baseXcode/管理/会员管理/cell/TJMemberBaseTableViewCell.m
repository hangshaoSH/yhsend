//
//  TJMemberBaseTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/11/20.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJMemberBaseTableViewCell.h"

@implementation TJMemberBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _normalBut.cornerRadius = 15.0f;
    _label0.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _label0.textColor = [UIColor colorWithHexString:@"575757"];
    _label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _label1.textColor = [UIColor colorWithHexString:@"575757"];
    _label2.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _label2.textColor = [UIColor colorWithHexString:@"575757"];
    _nameL.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _nameL.textColor = [UIColor colorWithHexString:@"575757"];
    _addressl.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _addressl.textColor = [UIColor colorWithHexString:@"575757"];
    _timel.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _timel.textColor = [UIColor colorWithHexString:@"575757"];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJMemberBaseManagecell";
    TJMemberBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJMemberManagecell" owner:self options:nil] objectAtIndex:1];
    }
    return cell;
}
- (void)setDataWithDic:(NSMutableDictionary *)dic
{
    //57bdb9   ff9c00解绑   ffb400删除
    _nameL.text = dic[@"memname"];
    _timel.text = dic[@"reqtime"];
    _addressl.text = [NSString stringWithFormat:@"%@－%@－%@",dic[@"cpname"],dic[@"buildname"],dic[@"houseaddr"]];
    if ([dic[@"checksta"] integerValue] == 0) {
        _jiantou.hidden = NO;
        _normalBut.hidden = YES;
    }
    if ([dic[@"checksta"] integerValue] == 1) {
        _jiantou.hidden = YES;
        _normalBut.hidden = NO;
        _normalBut.title = @"解绑";
        _normalBut.backgroundColor = [UIColor colorWithHexString:@"ff9c00"];
    }
    if ([dic[@"checksta"] integerValue] == 2) {
        _jiantou.hidden = YES;
        _normalBut.hidden = NO;
        _normalBut.title = @"删除";
        _normalBut.backgroundColor = [UIColor colorWithHexString:@"ffb400"];
    }
}
- (IBAction)butAc:(id)sender {
    UIButton * button = sender;
    [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:[NSString stringWithFormat:@"是否%@",button.title] titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if ([_delegate respondsToSelector:@selector(jiebangOrShanchu:andStr:)]) {
                [_delegate jiebangOrShanchu:button andStr:button.title];
            }
        }
    }];
}

@end
