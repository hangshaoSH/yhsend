//
//  TJTouSuBottomTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/12/14.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TJTousuBottomDelegate <NSObject>

- (void)jumpDetail;

@end
@interface TJTouSuBottomTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJTousuBottomDelegate>  delegate;
- (void)setCellWithDic:(NSMutableDictionary *)dic;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *people;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *numberL;
@property (weak, nonatomic) IBOutlet UILabel *status;


@end
