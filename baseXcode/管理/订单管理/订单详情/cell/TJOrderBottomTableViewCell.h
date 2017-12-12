//
//  TJOrderBottomTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 17/1/9.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJOrderBottomTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setDataWithLabel:(NSString *)str andFlag:(NSInteger)flag;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *countt;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UILabel *sureno;
@property (weak, nonatomic) IBOutlet UILabel *surepeople;
@property (weak, nonatomic) IBOutlet UILabel *suretime;
@property (weak, nonatomic) IBOutlet UIView *bgview;

@end
