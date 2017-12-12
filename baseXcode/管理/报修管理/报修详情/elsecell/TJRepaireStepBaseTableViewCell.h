//
//  TJRepaireStepBaseTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/12/7.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJRepaireStepBaseDelegate <NSObject>

- (void)selectImageFromCollectionview:(UICollectionView *)collectionView andIndex:(NSInteger)index andImageArray:(NSMutableArray *)imageArray;

@end

@interface TJRepaireStepBaseTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJRepaireStepBaseDelegate>  delegate;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (weak, nonatomic) IBOutlet UIView *bgview;
- (void)setCellWithDic:(NSMutableDictionary *)dic withTag:(NSInteger)tag;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
