//
//  TJRepaireDetailBottomTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/12/8.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJRepaireDetailBottomDelegate <NSObject>

- (void)showOrhiddenDetail;

@end

@interface TJRepaireDetailBottomTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJRepaireDetailBottomDelegate>  delegate;
- (void)setCellWithDic:(NSMutableDictionary *)dic;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *rengongfay;
@property (weak, nonatomic) IBOutlet UILabel *cailiaofei;
@property (weak, nonatomic) IBOutlet UILabel *otherfay;
@property (weak, nonatomic) IBOutlet UILabel *allfay;
@property (weak, nonatomic) IBOutlet UIView *bgview;


@end
