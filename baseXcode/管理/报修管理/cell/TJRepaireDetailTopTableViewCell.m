//
//  TJRepaireDetailTopTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/6.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJRepaireDetailTopTableViewCell.h"
#import "TJRepaireImageCollectionViewCell.h"
@interface TJRepaireDetailTopTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@end

@implementation TJRepaireDetailTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.font = fifteenFont;
    _label0.textColor = fivelightColor;
    _label1.font = fifteenFont;
    _label1.textColor = fivelightColor;
    _label2.font = fifteenFont;
    _label2.textColor = fivelightColor;
    _label3.font = fifteenFont;
    _label3.textColor = fivelightColor;
    _orderNumber.font = fifteenFont;
    _repairCount.font = fifteenFont;
    _status.font = fifteenFont;
    _style.font = fifteenFont;
    _content.font = fifteenFont;
    _bgview.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview.cornerRadius = 5.0;
    _bgview.borderColor = bordercolor;
    _bgview.borderWidth = 0.7;
    [_collectionview registerClass:[TJRepaireImageCollectionViewCell class] forCellWithReuseIdentifier:@"TJRepaireImageCell"];
    _collectionview.backgroundColor =[ UIColor clearColor];
    _collectionview.showsHorizontalScrollIndicator = NO;
    _collectionview.showsVerticalScrollIndicator = NO;
    _collectionview.scrollEnabled = NO;
    _collectionview. delegate = self ;
    _collectionview. dataSource = self ;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJRepaireDetailTopCell";
    TJRepaireDetailTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepireDetailCell" owner:self options:nil] firstObject];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    _orderNumber.text = dic[@"billcode"];
    _repairCount.text = [NSString stringWithFormat:@"报修%@次",dic[@"callnum"]];
    _status.text = dic[@"billstaname"];
    _style.text = [NSString stringWithFormat:@"%@[%@]",dic[@"modname"],dic[@"ordertypename"]];
    _content.text = dic[@"msgcontent"];
    if ([dic[@"hiddenImage"] integerValue] == 1) {
        _collectionview.hidden = YES;
    } else {
        _collectionview.hidden = NO;
        NSArray * array = [NSArray array];
        array = [dic[@"pics"] componentsSeparatedByString:@"^"];
        self.dataArray = [NSMutableArray arrayWithArray:array];
        [_collectionview reloadData];
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
