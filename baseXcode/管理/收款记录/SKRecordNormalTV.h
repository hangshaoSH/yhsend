//
//  SKRecordNormalTV.h
//  baseXcode
//
//  Created by app on 2017/8/13.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKRecordNormalTV : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *numberL;
@property (weak, nonatomic) IBOutlet UILabel *styleL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
- (void)setCellWithDic:(NSMutableDictionary *)dic;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
