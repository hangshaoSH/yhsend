//
//  TJReserveThreeTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 17/1/10.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJReserveThreeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *xiaoqu;
@property (weak, nonatomic) IBOutlet UILabel *goods;
@property (weak, nonatomic) IBOutlet UILabel *countt;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setDataWithLabel:(NSMutableDictionary *)dic;
@end
