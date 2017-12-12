//
//  TJMemberHeaderTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/11/28.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJMemberHeaderTableViewCell.h"

@implementation TJMemberHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleL.font = seventeenFont;
    _titleL.textColor = [UIColor colorWithHexString:@"010101"];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJMemberHeaderCell";
    TJMemberHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJPersonManagerCell" owner:self options:nil] objectAtIndex:0];
    }
    return cell;
}
- (void)setButTag:(NSInteger)tag andData:(NSMutableDictionary *)dic
{
    _selectB.tag = tag;
    _titleL.text = dic[@"deptname"];
    if ([dic[@"clerklist"] count] == 0) {
        _showImage.image = [UIImage imageNamed:@"person_rightgary"];
        _selectB.userInteractionEnabled = NO;
    }else {
        _selectB.userInteractionEnabled = YES;
        if ([dic[@"flag"] integerValue] == 1) {//打开状态
            _showImage.image = [UIImage imageNamed:@"person_bottomBlue"];
        } else {//关闭状态
            _showImage.image = [UIImage imageNamed:@"person_rightBlue"];
        }
    }
}
- (IBAction)buttonAc:(id)sender {
    if ([_delegate respondsToSelector:@selector(touchWithTag:)]) {
        [_delegate touchWithTag:_selectB.tag];
    }
}
@end
