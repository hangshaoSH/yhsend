//
//  TJTSBottomTowTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/12/19.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJBottomTowDelegate <NSObject>

- (void)choosefinishtime:(UITextField *)text;
- (void)finishTextreturn:(NSString *)text;
- (void)finishTextBeginEdit;
- (void)finishSure;
@end

@interface TJTSBottomTowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *content;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIView *bgview0;
@property (weak, nonatomic) IBOutlet UIButton *surebutton;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setCellWithDic:(NSMutableDictionary *)dic;
@property (nonatomic,   assign) id<TJBottomTowDelegate>  delegate;
@end
