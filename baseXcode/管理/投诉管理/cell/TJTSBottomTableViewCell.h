//
//  TJTSBottomTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/12/14.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol tjTSBottomDelegate <NSObject>

- (void)chooseLIxiangPeople;
- (void)chooseZerenPeople;
- (void)chooseLixiangTime:(UITextField *)text;
- (void)sureLixiang;
- (void)textreturn:(NSString *)text;
- (void)textBeginEdit;
@end

@interface TJTSBottomTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<tjTSBottomDelegate>  delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setCellWithDic:(NSMutableDictionary *)dic;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIView *view0;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UITextField *text0;
@property (weak, nonatomic) IBOutlet UITextField *text1;
@property (weak, nonatomic) IBOutlet UITextField *text2;
@property (weak, nonatomic) IBOutlet UITextView *text3;
@property (weak, nonatomic) IBOutlet UILabel *hiddenLabel;
@property (weak, nonatomic) IBOutlet UIButton *surebut;

@end
