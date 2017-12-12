//
//  TJOrderLabelTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 17/1/9.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJOrderLabelTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setDataWithLabel:(NSMutableDictionary *)dic;
@property (weak, nonatomic) IBOutlet UILabel *concent;

@end
