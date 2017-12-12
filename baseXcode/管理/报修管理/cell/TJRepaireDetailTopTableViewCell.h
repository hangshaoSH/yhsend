//
//  TJRepaireDetailTopTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/12/6.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJRepaireTopDelegate <NSObject>

- (void)selectImageFromCollectionview:(UICollectionView *)collectionView andIndex:(NSInteger)index andImageArray:(NSMutableArray *)imageArray;
@end

@interface TJRepaireDetailTopTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJRepaireTopDelegate>  delegate;
- (void)setCellWithDic:(NSMutableDictionary *)dic;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *repairCount;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *style;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@end
