//
//  faceNormalCell.h
//  baseXcode
//
//  Created by app on 2017/8/12.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "faceModel.h"

typedef void (^Myblock)();
@interface faceNormalCell : UITableViewCell
@property (nonatomic, copy) Myblock block;
@property (weak, nonatomic) IBOutlet UIButton *leftB;
@property (weak, nonatomic) IBOutlet UILabel *firstL;
@property (weak, nonatomic) IBOutlet UILabel *danjia;
@property (weak, nonatomic) IBOutlet UILabel *jine;
@property (weak, nonatomic) IBOutlet UILabel *mianji;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *shijian;
- (void)setCellWithDic:(NSMutableDictionary *)dic;

@end
