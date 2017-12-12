//
//  TJHomeTopTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/11/25.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJHomeTopTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIView *topline;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIView *bottomline;
- (void)setTitle:(NSString *)title andHidden:(BOOL)hidden;
@end
