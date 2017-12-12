//
//  TJOrderMidTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 17/1/9.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJOrderMidDelegate <NSObject>

- (void)editOrSave;
- (void)chooseTime;
- (void)beginTextview:(UITextView *)text;
- (void)endTextview:(UITextView *)text;
@end

@interface TJOrderMidTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJOrderMidDelegate>  delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setDataWithLabel:(NSMutableDictionary *)dic;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *editeBut;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *bgiew1;
@property (weak, nonatomic) IBOutlet UITextField *changetime;
@property (weak, nonatomic) IBOutlet UIButton *choosetime;
@property (weak, nonatomic) IBOutlet UIView *bgview2;
@property (weak, nonatomic) IBOutlet UILabel *ploharlabel;
@property (weak, nonatomic) IBOutlet UITextView *remark;

@end
