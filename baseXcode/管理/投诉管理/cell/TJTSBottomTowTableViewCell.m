//
//  TJTSBottomTowTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/19.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJTSBottomTowTableViewCell.h"

@interface TJTSBottomTowTableViewCell ()<UITextFieldDelegate>

@end

@implementation TJTSBottomTowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.textColor = fivelightColor;
    _label1.textColor = fivelightColor;
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _content.font = fifteenFont;
    _bgview.cornerRadius = 5.0;
    _bgview.borderColor = bordercolor;
    _bgview.borderWidth = 0.7;
    _bgview0.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview0.cornerRadius = 5.0;
    _bgview0.borderColor = bordercolor;
    _bgview0.borderWidth = 0.7;
    _surebutton.cornerRadius = 5.0;
    _surebutton.backgroundColor = [UIColor colorWithHexString:@"ffb400"];
    _surebutton.titleFont = 15 * ScaleModel;
    _content.delegate = self;
    _content.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJTSBottomTowCell";
    TJTSBottomTowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJTouSuDetailCell" owner:self options:nil] objectAtIndex:7];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    _time.text = dic[@"finishtime"];
    _content.text = dic[@"finishcontent"];
}
- (IBAction)sureAc:(id)sender {
    if (_time.text.length == 0) {
        SVShowError(@"请选择完成时间!");
        return;
    }
    if (_content.text.length == 0) {
        SVShowError(@"请输入完成结果!");
        return;
    }
    [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"是否提交信息，确认后将无法修改!" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if ([_delegate respondsToSelector:@selector(finishSure)]) {
                [_delegate finishSure];
            }
        }
    }];
}
- (IBAction)choosetime:(id)sender {
    if ([_delegate respondsToSelector:@selector(choosefinishtime:)]) {
        [_delegate choosefinishtime:_time];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(finishTextreturn:)]) {
        [_delegate finishTextreturn:textField.text];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(finishTextBeginEdit)]) {
        [_delegate finishTextBeginEdit];
    }
}
@end
