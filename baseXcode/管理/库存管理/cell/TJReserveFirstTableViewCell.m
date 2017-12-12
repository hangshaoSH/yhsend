//
//  TJReserveFirstTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 17/1/10.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJReserveFirstTableViewCell.h"
#import "TJRepaireImageCollectionViewCell.h"
@interface TJReserveFirstTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@end
@implementation TJReserveFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _label2.font = fifteenFont;
    _label3.font = fifteenFont;
    _label4.font = fifteenFont;
    _label5.font = fifteenFont;
    _label6.font = fifteenFont;
    _label7.font = fifteenFont;
    _label8.font = fifteenFont;
    _label9.font = fifteenFont;
    _label10.font = fifteenFont;
    _status.font = fifteenFont;
    _time.font = fifteenFont;
    _time.textColor = fivelightColor;
    _sure.cornerRadius = 15.0f;
    _sure.backgroundColor = orangeElseColor;
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
    static NSString * ID = @"TJReserveFirstCell";
    TJReserveFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJReserveManagerCell" owner:self options:nil] objectAtIndex:3];
    }
    return cell;
}
- (void)setDataWithLabel:(NSMutableDictionary *)dic
{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    if ([dic[@"logpic"] length] == 0) {
        _bgview.hidden = YES;
        _collectionview.hidden = YES;
        _lineView.hidden = YES;
    }else {
        _lineView.hidden = NO;
        _bgview.hidden = NO;
        _collectionview.hidden = NO;
        NSArray * array = [NSArray array];
        array = [dic[@"logpic"] componentsSeparatedByString:@","];
        self.dataArray = [NSMutableArray arrayWithArray:array];
        [_collectionview reloadData];
    }
    if ([dic[@"procsta"] integerValue] == 1) {
        _status.textColor = fivelightColor;
        _label0.textColor = fivelightColor;
        _sure.hidden = YES;
    }else {
        _sure.hidden = NO;
        _status.textColor = [UIColor colorWithHexString:@"c9383a"];
        _label0.textColor = [UIColor colorWithHexString:@"c9383a"];
    }
    _status.text = dic[@"procstaname"];
    _time.text = dic[@"delaytime"];
    NSArray * dataarray = [dic[@"sendstr"] componentsSeparatedByString:@"^"];
    if (dataarray.count > 0) {
        _label1.text = dataarray[0];
    }else {
        _label1.text = @"暂无";
    }
    if (dataarray.count > 1) {
        _label2.text = dataarray[1];
    }else {
        _label2.text = @"暂无";
    }
    if (dataarray.count > 2) {
        _label3.text = dataarray[2];
    }else {
        _label3.text = @"暂无";
    }
    if (dataarray.count > 3) {
        _label4.text = dataarray[3];
    }else {
        _label4.text = @"暂无";
    }
    if (dataarray.count > 4) {
        _label5.text = dataarray[4];
    }else {
        _label5.text = @"暂无";
    }
    if (dataarray.count > 5) {
        _label6.text = dataarray[5];
    }else {
        _label6.text = @"暂无";
    }
    if (dataarray.count > 7) {
        _label8.text = dataarray[7];
    }else {
        _label8.text = @"暂无";
    }
    if (dataarray.count > 6) {
        _label7.text = dataarray[6];
    }else {
        _label7.text = @"暂无";
    }
    if (dataarray.count > 8) {
        _label9.text = dataarray[8];
    }else {
        _label9.text = @"暂无";
    }
    if (dataarray.count > 9) {
        _label10.text = dataarray[9];
    }else {
        _label10.text = @"暂无";
    }
}
- (IBAction)sureAc:(id)sender {
    if ([_delegate respondsToSelector:@selector(sureNow:)]) {
        [_delegate sureNow:sender];
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
    return UIEdgeInsetsMake(0, 1, 1,10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(selectImageFromCollectionview:andIndex:andImageArray:)]) {
        [_delegate selectImageFromCollectionview:collectionView andIndex:indexPath.row andImageArray:self.dataArray];
    }
}
@end
