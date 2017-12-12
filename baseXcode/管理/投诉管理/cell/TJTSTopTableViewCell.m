//
//  TJTSTopTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/14.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJTSTopTableViewCell.h"
#import "TJRepaireImageCollectionViewCell.h"

@interface TJTSTopTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@end
@implementation TJTSTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.textColor = fivelightColor;
    _label1.textColor = fivelightColor;
    _label2.textColor = fivelightColor;
    _label3.textColor = fivelightColor;
    _label4.textColor = fivelightColor;
    _label5.textColor = fivelightColor;
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _label2.font = fifteenFont;
    _label3.font = fifteenFont;
    _label4.font = fifteenFont;
    _label5.font = fifteenFont;
    _status.font = fifteenFont;
    _style.font = fifteenFont;
    _xiaoqu.font = fifteenFont;
    _titlel.font = fifteenFont;
    _ontent.font = fifteenFont;
    _number.font = fifteenFont;
    _countL.font = fifteenFont;
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
    static NSString * ID = @"TJTouSuTopCell";
    TJTSTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJTouSuDetailCell" owner:self options:nil] firstObject];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    _number.text = dic[@"billcode"];
    _status.text = dic[@"modname"];
    _style.text = dic[@"billstaname"];
    _xiaoqu.text = dic[@"cpname"];
    _titlel.text = dic[@"tousutitle"];
    _countL.text = [NSString stringWithFormat:@"投诉%@次",dic[@"callnum"]];
    if ([dic[@"msgcontent"] length] == 0) {
        _ontent.text = @"无内容";
    }else {
       _ontent.text = dic[@"msgcontent"];
    }
    if ([dic[@"pics"] length] > 0) {
        NSArray * array = [dic[@"pics"] componentsSeparatedByString:@"^"];
        self.dataArray = [NSMutableArray arrayWithArray:array];
        _collectionview.hidden = NO;
        [_collectionview reloadData];
    } else {
        _collectionview.hidden = YES;
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
    return CGSizeMake(73, 71);
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
