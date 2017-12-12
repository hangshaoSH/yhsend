//
//  TJManagerNormalTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/11/24.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJManagerNormalTableViewCell.h"
#import "TJManagerNormalCollectionViewCell.h"
@interface TJManagerNormalTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TJManagerCollectionDelegate>

@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   weak) UICollectionView     * collectionView;
@end

@implementation TJManagerNormalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bgview.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview.borderWidth = 0.5;
    _bgview.cornerRadius = 5.0;
    _topLabel.font = seventeenFont;
    
    [_viewcoll registerClass:[TJManagerNormalCollectionViewCell class] forCellWithReuseIdentifier:@"TJManagerCollectionNormalCell"];
    _viewcoll.backgroundColor =[ UIColor clearColor];
    _viewcoll.showsHorizontalScrollIndicator = NO;
    _viewcoll.showsVerticalScrollIndicator = NO;
    _viewcoll.scrollEnabled = NO;
    _viewcoll. delegate = self ;
    _viewcoll. dataSource = self ;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"managernormalcell";
    TJManagerNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJManagerMainCell" owner:self options:nil] objectAtIndex:1];
    }
    return cell;
}
- (void)setCollectionviewWithData:(NSMutableArray *)array andTopLabel:(NSString *)title
{
    _topLabel.text = title;
    self.dataArray = [NSMutableArray arrayWithArray:array];
    [_viewcoll reloadData];
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
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
    TJManagerNormalCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TJManagerCollectionNormalCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.midlabel.text = dic[@"title"];
    if ([dic[@"count"] integerValue] > 0) {
        cell.redview.hidden = NO;
        cell.redcount.hidden = NO;
        cell.redcount.text = dic[@"count"];
    }else {
        cell.redview.hidden = YES;
        cell.redcount.hidden = YES;
        cell.redcount.text = @"";
    }
    if ([dic[@"use"] integerValue] == 0) {
        [cell.showbutton setImage:[UIImage imageNamed:dic[@"noselect"]] forState:UIControlStateNormal];
        [cell.showbutton setImage:[UIImage imageNamed:dic[@"noselect"]] forState:UIControlStateSelected];
        [cell.showbutton setImage:[UIImage imageNamed:dic[@"noselect"]] forState:UIControlStateHighlighted];
        cell.midlabel.textColor = [UIColor colorWithHexString:@"adadad"];
    } else {
        [cell.showbutton setImage:[UIImage imageNamed:dic[@"normal"]] forState:UIControlStateNormal];
        [cell.showbutton setImage:[UIImage imageNamed:dic[@"select"]] forState:UIControlStateSelected];
        [cell.showbutton setImage:[UIImage imageNamed:dic[@"select"]] forState:UIControlStateHighlighted];
        cell.midlabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-24-60)/3, 112);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0,10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}
- (void)buttonAc:(UIButton *)button
{
    TJManagerNormalCollectionViewCell * cell = (TJManagerNormalCollectionViewCell *)[[[button superview] superview]superview];
     NSIndexPath * path = [_viewcoll indexPathForCell:cell];
    if ([_delegate respondsToSelector:@selector(collectionSelect:andCollectionview:)]) {
        [_delegate collectionSelect:path.row andCollectionview:_viewcoll];
    }
}
@end
