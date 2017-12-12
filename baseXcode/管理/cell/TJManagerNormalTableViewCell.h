//
//  TJManagerNormalTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/11/24.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJManagerNormalDelegate <NSObject>

- (void)collectionSelect:(NSInteger)index andCollectionview:(UICollectionView *)collectionview;

@end

@interface TJManagerNormalTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJManagerNormalDelegate>  delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UIView *collectionview;
- (void)setCollectionviewWithData:(NSMutableArray *)array andTopLabel:(NSString *)title;
@property (weak, nonatomic) IBOutlet UICollectionView *viewcoll;
@end
