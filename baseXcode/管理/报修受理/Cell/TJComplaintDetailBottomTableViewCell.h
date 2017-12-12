//
//  TJComplaintDetailBottomTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/12/13.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJComplaintBottomDelegate <NSObject>

- (void)jumpDetail;

@end

@interface TJComplaintDetailBottomTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJComplaintBottomDelegate>  delegate;
- (void)setCellWithDic:(NSMutableDictionary *)dic;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *people;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *numberL;
@property (weak, nonatomic) IBOutlet UILabel *status;

@end
