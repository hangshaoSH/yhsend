//
//  TJTSTopTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/12/14.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJTSTopDelegate <NSObject>

- (void)selectImageFromCollectionview:(UICollectionView *)collectionView andIndex:(NSInteger)index andImageArray:(NSMutableArray *)imageArray;
@end

@interface TJTSTopTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJTSTopDelegate>  delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setCellWithDic:(NSMutableDictionary *)dic;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *countL;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *style;
@property (weak, nonatomic) IBOutlet UILabel *xiaoqu;
@property (weak, nonatomic) IBOutlet UILabel *titlel;
@property (weak, nonatomic) IBOutlet UILabel *ontent;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (weak, nonatomic) IBOutlet UIView *bgview;

@end
