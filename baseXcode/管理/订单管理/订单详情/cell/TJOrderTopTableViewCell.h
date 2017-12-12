//
//  TJOrderTopTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 17/1/9.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJOrderTopTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setDataWithLabel:(NSMutableDictionary *)dic;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *countt;
@property (weak, nonatomic) IBOutlet UILabel *allpay;
@property (weak, nonatomic) IBOutlet UILabel *guwen;
@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UILabel *orderstatus;
@property (weak, nonatomic) IBOutlet UILabel *orderlast;
@property (weak, nonatomic) IBOutlet UIView *bgview1;
@property (weak, nonatomic) IBOutlet UIView *bgview2;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
