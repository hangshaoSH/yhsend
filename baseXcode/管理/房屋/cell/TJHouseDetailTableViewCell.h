//
//  TJHouseDetailTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/11/21.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJHouseDetailDelegate <NSObject>

- (void)editYeZhuxinxi:(UIButton *)button;
- (void)deleteYeZhuxinxi:(UIButton *)button;

@end

@interface TJHouseDetailTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJHouseDetailDelegate>  delegate;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UILabel *styleL;
@property (weak, nonatomic) IBOutlet UILabel *shenfenzheng;
@property (weak, nonatomic) IBOutlet UILabel *deleteL;
@property (weak, nonatomic) IBOutlet UILabel *editeL;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *line3;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setDataWithLabel:(NSMutableDictionary *)dic;
@end
