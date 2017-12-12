//
//  TJMemberDetailTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/11/20.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJMemberDetailTableViewCell.h"

@implementation TJMemberDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _label0.textColor = [UIColor colorWithHexString:@"626262"];
    _label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _label1.textColor = [UIColor colorWithHexString:@"626262"];
    _label2.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _label2.textColor = [UIColor colorWithHexString:@"626262"];
    _label3.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _label3.textColor = [UIColor colorWithHexString:@"626262"];
    _label4.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _label4.textColor = [UIColor colorWithHexString:@"626262"];
    _name1.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _name1.textColor = [UIColor colorWithHexString:@"626262"];
    _name2.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _name2.textColor = [UIColor colorWithHexString:@"626262"];
    _addressl.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _addressl.textColor = [UIColor colorWithHexString:@"626262"];
    _time.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _time.textColor = [UIColor colorWithHexString:@"626262"];
    _phonel.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _phonel.textColor = [UIColor colorWithHexString:@"626262"];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJMemberDetailTopManagecell";
    TJMemberDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJMemberManagecell" owner:self options:nil] objectAtIndex:2];
    }
    return cell;
}
- (void)setDataWithDic:(NSMutableDictionary *)dic
{
    _name1.text = dic[@"memname"];
    _name2.text = dic[@"xingming"];
    _time.text = dic[@"reqtime"];
    _addressl.text = [NSString stringWithFormat:@"%@－%@－%@",dic[@"cpname"],dic[@"buildname"],dic[@"housename"]];
    _phonel.text = dic[@"mobile"];
}
- (IBAction)phoneAc:(id)sender {
    if (self.phonel.text.length == 0) {
        return;
    }
    [[User sharedUser] callUp:self.phonel.text];
}
- (IBAction)jumpAddress:(id)sender {
    if ([_delegate respondsToSelector:@selector(chooseAddress)]) {
        [_delegate chooseAddress];
    }
}

@end
