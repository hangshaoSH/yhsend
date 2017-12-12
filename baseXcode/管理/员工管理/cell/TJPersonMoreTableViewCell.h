//
//  TJPersonMoreTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/11/28.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJPersonMoreDelegate <NSObject>

- (void)touchMoreCell:(NSInteger)index withDic:(NSMutableDictionary *)dic;
- (void)selectCell:(NSUInteger)index WithDic:(NSMutableDictionary *)dic;
@end

@interface TJPersonMoreTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJPersonMoreDelegate>  delegate;
- (void)setButTag:(NSInteger)tag andData:(NSMutableDictionary *)dic;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
