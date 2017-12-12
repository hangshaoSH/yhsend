//
//  TJMemberDetailTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/11/20.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJMemberDetailDelegate <NSObject>

- (void)chooseAddress;

@end

@interface TJMemberDetailTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJMemberDetailDelegate>  delegate;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *name1;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *name2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *phonel;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *addressl;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setDataWithDic:(NSMutableDictionary *)dic;
@end
