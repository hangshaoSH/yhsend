//
//  TJHomeNormalTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/11/25.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJHomeNormalTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIView *topline;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UIView *bottomline;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *addreeL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
- (void)setdataWithDic:(NSMutableDictionary *)dic;
@end
