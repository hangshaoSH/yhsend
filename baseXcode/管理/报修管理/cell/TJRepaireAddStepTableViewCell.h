//
//  TJRepaireAddStepTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/12/9.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJRepaireAddStepDelegate <NSObject>

- (void)pushImage;//上传图片

- (void)submitStep;//提交步骤

- (void)chooseStepPeople;

- (void)chooseStepTime:(UITextField *)text;

- (void)textEditBegin;

- (void)textEditEnd:(UITextField *)text;

@end

@interface TJRepaireAddStepTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJRepaireAddStepDelegate>  delegate;
- (void)setCellWithDic:(NSMutableDictionary *)dic;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIView *bgview0;
@property (weak, nonatomic) IBOutlet UIView *bgview1;
@property (weak, nonatomic) IBOutlet UIView *bgview2;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBut;
@property (weak, nonatomic) IBOutlet UITextField *content;
@property (weak, nonatomic) IBOutlet UITextField *people;
@property (weak, nonatomic) IBOutlet UITextField *timeT;
@property (weak, nonatomic) IBOutlet UIButton *leftBut;

@end
