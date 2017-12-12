//
//  TJBeforRepaireImageTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/8.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJBeforRepaireImageTableViewCell.h"
#import "TJRepaireImageCollectionViewCell.h"

@interface TJBeforRepaireImageTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic,   strong) NSMutableArray     * dataArray;


@end
@implementation TJBeforRepaireImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.font = fifteenFont;
    _label0.textColor = fivelightColor;
    [_collectonview registerClass:[TJRepaireImageCollectionViewCell class] forCellWithReuseIdentifier:@"TJRepaireImageCell"];
    _collectonview.backgroundColor =[ UIColor clearColor];
    _collectonview.showsHorizontalScrollIndicator = NO;
    _collectonview.showsVerticalScrollIndicator = NO;
    _collectonview.scrollEnabled = NO;
    _collectonview. delegate = self ;
    _collectonview. dataSource = self ;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJBeforRepaireImageMainCell";
    TJBeforRepaireImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepaireElseDetailCell" owner:self options:nil] objectAtIndex:11];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    if ([dic[@"wxinfo"][@"beforepics"] length] > 0) {
        NSArray * array = [dic[@"wxinfo"][@"beforepics"] componentsSeparatedByString:@"^"];
        self.dataArray = [NSMutableArray arrayWithArray:array];
        _collectonview.hidden = NO;
        [_collectonview reloadData];
    }else {
        _collectonview.hidden = YES;
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TJRepaireImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TJRepaireImageCell" forIndexPath:indexPath];
    [cell.imageC sd_setImageWithURL:self.dataArray[indexPath.row] placeholderImage:[UIImage imageNamed:@"home_photo"]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(63, 63);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(6, 0, 0,10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(selectImageFromCollectionview:andIndex:andImageArray:)]) {
        [_delegate selectImageFromCollectionview:collectionView andIndex:indexPath.row andImageArray:self.dataArray];
    }
}

@end
