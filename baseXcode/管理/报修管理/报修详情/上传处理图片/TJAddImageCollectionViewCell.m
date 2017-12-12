//
//  TJAddImageCollectionViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/9.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJAddImageCollectionViewCell.h"

@implementation TJAddImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"TJAddImageCell" owner:nil options:nil] firstObject];
        _label0.font = twelveFont;
        _label0.textColor = fivelightColor;
        _bgview.cornerRadius = 5.0;
        _bgview.borderWidth = 0.7;
        _bgview.borderColor = bordercolor;
        [_showImage.layer setMasksToBounds:YES];
        [_showImage setContentMode:UIViewContentModeScaleAspectFill];
        [self setCancelHidden:YES];
        [self setClipsToBounds:NO];
    }
    return self;
}
- (IBAction)deleteAc:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancelDidClicked:)]) {
        [self.delegate cancelDidClicked:_row];
    }
}
- (void)setCancelHidden:(BOOL)hidden
{
    [_hiddenBut setHidden:hidden];
}

- (void)setPhotoUrl:(NSURL *)url
{
    [_showImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"home_photo"]];
}

- (void)setImage:(UIImage *)image hidden:(BOOL)hidden
{
    _label0.hidden = NO;
    _addImage.hidden = NO;
    [_showImage setImage:image];
    _showImage.hidden = hidden;
}
- (void)setImage1:(id)image hidden:(BOOL)hidden
{
    if ([image isKindOfClass:[NSString class]]) {
        _label0.hidden = YES;
        _addImage.hidden = YES;
        [_showImage sd_setImageWithURL:image placeholderImage:[UIImage imageNamed:@"home_photo"]];
    } else {
        _label0.hidden = NO;
        _addImage.hidden = NO;
         [_showImage setImage:image];
    }
    _showImage.hidden = hidden;
}
@end
