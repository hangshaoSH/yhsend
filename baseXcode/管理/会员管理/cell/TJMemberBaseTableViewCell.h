//
//  TJMemberBaseTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/11/20.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJMemberDelegate <NSObject>

- (void)jiebangOrShanchu:(UIButton *)button andStr:(NSString *)title;

@end

@interface TJMemberBaseTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJMemberDelegate>  delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timel;
@property (weak, nonatomic) IBOutlet UILabel *addressl;
@property (weak, nonatomic) IBOutlet UIImageView *jiantou;
@property (weak, nonatomic) IBOutlet UIButton *normalBut;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setDataWithDic:(NSMutableDictionary *)dic;
@end
