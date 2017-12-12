//
//  TJOrderMidTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 17/1/9.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJOrderMidTableViewCell.h"

@interface TJOrderMidTableViewCell ()<UITextViewDelegate>

@end

@implementation TJOrderMidTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label1.textColor = fivelightColor;
    _label2.textColor = fivelightColor;
    _label0.textColor = fivelightColor;
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _label2.font = fifteenFont;
    _time.font = fifteenFont;
    _changetime.font = fifteenFont;
    _editeBut.cornerRadius = 5;
    _editeBut.backgroundColor = orangecolor;
    _editeBut.titleFont = 15 * ScaleModel;
    _bgiew1.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgiew1.borderWidth = 1.0;
    _bgiew1.cornerRadius = 5.0;
    _bgview2.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview2.cornerRadius = 5.0;
    _bgview2.borderColor = bordercolor;
    _bgview2.borderWidth = 0.7;
    _ploharlabel.font = fifteenFont;
    _ploharlabel.textColor = [UIColor lightGrayColor];
    _ploharlabel.hidden = YES;
    _remark.delegate = self;
    _remark.font = fifteenFont;
    _remark.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJOrderDetailMidCell";
    TJOrderMidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJOrderDetailCell" owner:self options:nil] objectAtIndex:2];
    }
    return cell;
}
- (void)setDataWithLabel:(NSMutableDictionary *)dic
{
    if ([dic[@"flag"] integerValue] == 0) {//编辑
        _bgiew1.hidden = YES;
        _time.hidden = NO;
        _editeBut.title = @"编辑";
        _remark.userInteractionEnabled = NO;
    }else {//保存
        _bgiew1.hidden = NO;
        _time.hidden = YES;
         _editeBut.title = @"保存";
        _remark.userInteractionEnabled = YES;
    }
    _time.text = dic[@"ordertime"];
    _remark.text = dic[@"orderremark"];
    _changetime.text = dic[@"choosetime"];
}
- (IBAction)editeAc:(id)sender {
    if ([_delegate respondsToSelector:@selector(editOrSave)]) {
        [_delegate editOrSave];
    }
}
- (IBAction)choosetimeAc:(id)sender {
    if ([_delegate respondsToSelector:@selector(chooseTime)]) {
        [_delegate chooseTime];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([_delegate respondsToSelector:@selector(beginTextview:)]) {
        [_delegate beginTextview:textView];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([_delegate respondsToSelector:@selector(endTextview:)]) {
        [_delegate endTextview:textView];
    }
}
@end
