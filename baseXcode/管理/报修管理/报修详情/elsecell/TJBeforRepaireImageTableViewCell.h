//
//  TJBeforRepaireImageTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/12/8.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJRepaireBeforImageDelegate <NSObject>

- (void)selectImageFromCollectionview:(UICollectionView *)collectionView andIndex:(NSInteger)index andImageArray:(NSMutableArray *)imageArray;

@end

@interface TJBeforRepaireImageTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJRepaireBeforImageDelegate>  delegate;
- (void)setCellWithDic:(NSMutableDictionary *)dic;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UICollectionView *collectonview;

@end
