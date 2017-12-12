//
//  TJComplaintDetailTopTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/13.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJComplaintDetailTopTableViewCell.h"
#import "TJRepaireImageCollectionViewCell.h"

@interface TJComplaintDetailTopTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@end

@implementation TJComplaintDetailTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _label2.font = fifteenFont;
    _label3.font = fifteenFont;
    _label4.font = fifteenFont;
    _label0.textColor = fivelightColor;
    _label1.textColor = fivelightColor;
    _label2.textColor = fivelightColor;
    _label4.textColor = fivelightColor;
    _label3.textColor = fivelightColor;
    _status.font = fifteenFont;
    _style.font = fifteenFont;
    _zhonglei.font = fifteenFont;
    _fangshi.font = fifteenFont;
    _content.font = fifteenFont;
    _bgview.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview.cornerRadius = 5.0;
    _bgview.borderColor = bordercolor;
    _bgview.borderWidth = 0.7;
    [_collevtionview registerClass:[TJRepaireImageCollectionViewCell class] forCellWithReuseIdentifier:@"TJRepaireImageCell"];
    _collevtionview.backgroundColor =[ UIColor clearColor];
    _collevtionview.showsHorizontalScrollIndicator = NO;
    _collevtionview.showsVerticalScrollIndicator = NO;
    _collevtionview.scrollEnabled = NO;
    _collevtionview. delegate = self ;
    _collevtionview. dataSource = self ;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJComplaintDetailTopCell";
    TJComplaintDetailTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepaireManagerCell" owner:self options:nil] objectAtIndex:1];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    if ([dic[@"pics"] length] > 0) {
        NSArray * array = [dic[@"pics"] componentsSeparatedByString:@"^"];
        self.dataArray = [NSMutableArray arrayWithArray:array];
        _collevtionview.hidden = NO;
        [self.collevtionview reloadData];
    } else {
        _collevtionview.hidden = YES;
    }
    _zhonglei.text = dic[@"ordertypename"];
    _style.text = dic[@"modname"];
    _content.text = dic[@"msgcontent"];
    _fangshi.text = dic[@"typename"];
    _status.text = dic[@"isacceptname"];
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
