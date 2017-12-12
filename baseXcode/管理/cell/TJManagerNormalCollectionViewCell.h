//
//  TJManagerNormalCollectionViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/11/24.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJManagerCollectionDelegate <NSObject>

- (void)buttonAc:(UIButton *)button;

@end

@interface TJManagerNormalCollectionViewCell : UICollectionViewCell
@property (nonatomic,   assign) id<TJManagerCollectionDelegate>  delegate;
@property (weak, nonatomic) IBOutlet UILabel *midlabel;
@property (weak, nonatomic) IBOutlet UIImageView *redview;
@property (weak, nonatomic) IBOutlet UILabel *redcount;
@property (weak, nonatomic) IBOutlet UIButton *showbutton;

@end
