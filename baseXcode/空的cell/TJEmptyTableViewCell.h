//
//  TJEmptyTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/11/18.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJEmptyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageEmpty;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setLabel:(NSString *)title andFont:(CGFloat)font andColor:(id)color;
@end
