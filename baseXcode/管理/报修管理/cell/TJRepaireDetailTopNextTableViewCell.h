//
//  TJRepaireDetailTopNextTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/12/6.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJRepaireDetailNextTopDelegate <NSObject>

- (void)hiddenAction;

@end

@interface TJRepaireDetailTopNextTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJRepaireDetailNextTopDelegate>  delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UILabel *lable0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *people;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UIImageView *hiddenimage;
- (void)setCellWithDic:(NSMutableDictionary *)dic;
@end
