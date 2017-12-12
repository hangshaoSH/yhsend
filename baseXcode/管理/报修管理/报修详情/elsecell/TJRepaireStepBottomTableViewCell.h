//
//  TJRepaireStepBottomTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/12/7.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TJRepaireStepBottomDelegate <NSObject>

- (void)hiddenOrShowStep;

@end

@interface TJRepaireStepBottomTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJRepaireStepBottomDelegate>  delegate;
- (void)setCellWithDic:(NSMutableDictionary *)dic;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageS;
@property (weak, nonatomic) IBOutlet UIButton *hiddenAc;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UIView *lineview;


@end
