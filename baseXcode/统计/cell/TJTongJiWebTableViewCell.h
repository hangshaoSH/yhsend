//
//  TJTongJiWebTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/11/25.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJWebDelegate <NSObject>

- (void)touchTitle:(NSString *)title;

@end

@interface TJTongJiWebTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJWebDelegate>  delegate;
@property (weak, nonatomic) IBOutlet UIWebView *tongjiweb;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)seturlWithStr:(NSString *)str;
@end
