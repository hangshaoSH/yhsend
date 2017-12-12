//
//  TJAddImageCollectionViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/12/9.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJAddImageDelegate <NSObject>

- (void)cancelDidClicked:(NSInteger)index;

@end

@interface TJAddImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (nonatomic,   assign) id<TJAddImageDelegate>  delegate;
@property (weak, nonatomic) IBOutlet UIImageView *addImage;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UIButton *hiddenBut;
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (nonatomic, assign) NSInteger row;

- (void)setPhotoUrl:(NSURL *)url;
- (void)setImage:(UIImage *)image hidden:(BOOL)hidden;
- (void)setCancelHidden:(BOOL)hidden;
- (void)setImage1:(id)image hidden:(BOOL)hidden;
@end
