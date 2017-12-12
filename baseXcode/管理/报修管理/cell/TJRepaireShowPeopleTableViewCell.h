//
//  TJRepaireShowPeopleTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/12/6.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJRepaireShowDelegate <NSObject>

- (void)addStepAction;

@end

@interface TJRepaireShowPeopleTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJRepaireShowDelegate>  delegate;
- (void)setCellWithDic:(NSMutableDictionary *)dic;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *getorderpeople;
@property (weak, nonatomic) IBOutlet UILabel *weixiutime;


@end
