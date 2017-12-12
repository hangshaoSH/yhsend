//
//  TJMemberNormalTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/11/28.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMemberNormalTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *zhiwei;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UIImageView *gouImage;
@property (weak, nonatomic) IBOutlet UIImageView *jiantouImage;
- (void)setdataWithDic:(NSMutableDictionary *)dic;
@end
