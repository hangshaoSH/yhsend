//
//  TJReserveThreeTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 17/1/10.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJReserveThreeTableViewCell.h"

@implementation TJReserveThreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _label2.font = fifteenFont;
    _xiaoqu.font = fifteenFont;
    _goods.font = fifteenFont;
    _countt.font = fifteenFont;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJReserveThreeCell";
    TJReserveThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJReserveManagerCell" owner:self options:nil] objectAtIndex:1];
    }
    return cell;
}
- (void)setDataWithLabel:(NSMutableDictionary *)dic
{
    _xiaoqu.text = dic[@"cpname"];
    _goods.text = dic[@"billname"];
    _countt.text = dic[@"storenum"];
}

@end
