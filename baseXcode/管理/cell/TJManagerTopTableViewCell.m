//
//  TJManagerTopTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/11/24.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJManagerTopTableViewCell.h"

@interface TJManagerTopTableViewCell ()

@property (nonatomic,   weak) UILabel     * showLabel;

@end

@implementation TJManagerTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bgview.borderWidth = 0.7;
    _bgview.borderColor = TopBgColor;
    
    UIView * redView = [[UIView alloc] initWithFrame:Rect(0, 0, 114*ScaleModel, 40*ScaleModel)];
    [_bgview addSubview:redView];
    UIImageView * image = [[UIImageView alloc] initWithFrame:Rect(0, 0, redView.width, redView.height)];
    image.image = [UIImage imageNamed:@"redlineBg"];
    [redView addSubview:image];
    
    UILabel * daiban = [[UILabel alloc] initWithFrame:Rect(0, 0, redView.width, redView.height)];
    daiban.centerX = redView.width/2;
    daiban.centerY = redView.height/2;
    daiban.text = @"待办";
    daiban.textColor = [UIColor whiteColor];
    daiban.textAlignment = NSTextAlignmentCenter;
    daiban.font = seventeenFont;
    [redView addSubview:daiban];
    
    UILabel * showLabel = [[UILabel alloc] initWithFrame:Rect(128*ScaleModel, 0, kScreenWidth-56-140*ScaleModel, 30)];
    showLabel.centerY = redView.height/2;
    showLabel.textColor = [UIColor redColor];
    showLabel.text = @"当前共有6条待办事项";
    showLabel.font = sixteentFont;
    showLabel.attributedText = [[HSUser sharedUser] attributedstringWithText:showLabel.text range1:NSMakeRange(0, 4) font1:16*ScaleModel color1:zeroblackColor range2:NSMakeRange(5, 5) font2:16*ScaleModel color2:zeroblackColor];
    [redView addSubview:showLabel];
    self.showLabel = showLabel;
}
- (void)setDataWithString:(NSString *)str
{
    self.showLabel.text = str;
    if (str.length < 10) {
        return;
    }
    self.showLabel.attributedText = [[HSUser sharedUser] attributedstringWithText:self.showLabel.text range1:NSMakeRange(0, 4) font1:16*ScaleModel color1:zeroblackColor range2:NSMakeRange([str length] - 5, 5) font2:16*ScaleModel color2:zeroblackColor];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"managertopcell";
    TJManagerTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJManagerMainCell" owner:self options:nil] firstObject];
    }
    return cell;
}
- (IBAction)refreshAc:(id)sender {
    if ([_delegate respondsToSelector:@selector(refreshAc)]) {
        [_delegate refreshAc];
    }
}
@end
