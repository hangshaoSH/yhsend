//
//  faceNormalCell.m
//  baseXcode
//
//  Created by app on 2017/8/12.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "faceNormalCell.h"

@implementation faceNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (IBAction)butAc:(id)sender {
    if (self.block) {
        self.block();
    }
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    if ([dic[@"flag"] integerValue] == 1) {
        _leftB.selected = YES;
    }else {
        _leftB.selected = NO;
    }
    _firstL.text = dic[@"itemname"];
    _shijian.text = dic[@"ysperiod"];
    _mianji.text = dic[@"usingnum"];
    _danjia.text = dic[@"perprice"];
    _jine.text = dic[@"yingshou"];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"faceToFaceNormalCell";
    faceNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"faceToFaceCell" owner:self options:nil] objectAtIndex:4];
    }
    return cell;
}

@end
