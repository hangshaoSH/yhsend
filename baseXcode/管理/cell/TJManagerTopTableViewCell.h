//
//  TJManagerTopTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/11/24.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJManagerTopDelegate <NSObject>

- (void)refreshAc;

@end

@interface TJManagerTopTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJManagerTopDelegate>  delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIView *bgview;
- (void)setDataWithString:(NSString *)str;
@end
