//
//  TJMemberHeaderTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/11/28.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJPersonHeaderDeleagte <NSObject>

- (void)touchWithTag:(NSInteger)tag;

@end

@interface TJMemberHeaderTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJPersonHeaderDeleagte>  delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIButton *selectB;
- (void)setButTag:(NSInteger)tag andData:(NSMutableDictionary *)dic;
@end
