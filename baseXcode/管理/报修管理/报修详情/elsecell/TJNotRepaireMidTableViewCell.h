//
//  TJNotRepaireMidTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/12/6.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJNotRepaireMidTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *weixiutime;
@property (weak, nonatomic) IBOutlet UILabel *countL;
- (void)setCellWithDic:(NSMutableDictionary *)dic;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
