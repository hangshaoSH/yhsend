//
//  TJOrderGoodsTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 17/1/6.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJOrderGoodsDelegate <NSObject>

- (void)deleteGoods:(NSInteger)index;
- (void)textBeginchange:(UITextField *)text andIndex:(NSInteger)index andFlag:(NSInteger)flag;
- (void)textendchange:(UITextField *)text andIndex:(NSInteger)index andFlag:(NSInteger)flag;
@end

@interface TJOrderGoodsTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJOrderGoodsDelegate>  delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setDataWithLabel:(NSMutableDictionary *)dic andindex:(NSInteger)index;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *allcount;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIView *bgview1;
@property (weak, nonatomic) IBOutlet UIView *bgview2;
@property (weak, nonatomic) IBOutlet UILabel *deleteL;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *countT;

@end
