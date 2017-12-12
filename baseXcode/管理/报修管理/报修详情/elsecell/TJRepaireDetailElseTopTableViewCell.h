//
//  TJRepaireDetailElseTopTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/12/8.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJRepaireDetailElseTopDelegate <NSObject>



@end

@interface TJRepaireDetailElseTopTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJRepaireDetailElseTopDelegate>  delegate;
- (void)setCellWithDic:(NSMutableDictionary *)dic;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *weixiuren;
@property (weak, nonatomic) IBOutlet UILabel *weixiuxiangmu;
@property (weak, nonatomic) IBOutlet UILabel *weixiujieguo;
@property (weak, nonatomic) IBOutlet UIView *bgview;


@end
