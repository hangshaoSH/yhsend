//
//  TJTSTopTowTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/12/14.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJTSTopTowDelegate <NSObject>

- (void)hiddenOrShowTop;
@end

@interface TJTSTopTowTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJTSTopTowDelegate>  delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setCellWithDic:(NSMutableDictionary *)dic andHidden:(NSInteger)hidden;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *time1;
@property (weak, nonatomic) IBOutlet UILabel *people;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *people1;
@property (weak, nonatomic) IBOutlet UILabel *address1;
@property (weak, nonatomic) IBOutlet UILabel *phone1;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UIImageView *image1;

@end
