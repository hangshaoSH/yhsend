//
//  TJHouseListTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/11/18.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJHouseListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *wyStyle;
@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UILabel *wyStatus;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *huxing;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *areaL;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setDataWithLabel:(NSMutableDictionary *)dic;
@end
