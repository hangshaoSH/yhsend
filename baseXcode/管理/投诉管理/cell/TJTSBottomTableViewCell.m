//
//  TJTSBottomTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/14.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJTSBottomTableViewCell.h"

@interface TJTSBottomTableViewCell ()<UITextViewDelegate>

@end

@implementation TJTSBottomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _text3.delegate = self;
    _label0.textColor = fivelightColor;
    _label1.textColor = fivelightColor;
    _label2.textColor = fivelightColor;
    _label3.textColor = fivelightColor;
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _label2.font = fifteenFont;
    _label3.font = fifteenFont;
    _text0.font = fifteenFont;
    _text1.font = fifteenFont;
    _text2.font = fifteenFont;
    _text3.font = fifteenFont;
    _surebut.titleFont = 15 * ScaleModel;
    _surebut.cornerRadius = 5.0;
    _surebut.backgroundColor = orangecolor;
    _view0.cornerRadius = 5.0;
    _view0.borderColor = bordercolor;
    _view0.borderWidth = 0.7;
    _view1.cornerRadius = 5.0;
    _view1.borderColor = bordercolor;
    _view1.borderWidth = 0.7;
    _view2.cornerRadius = 5.0;
    _view2.borderColor = bordercolor;
    _view2.borderWidth = 0.7;
    _view3.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _view3.cornerRadius = 5.0;
    _view3.borderColor = bordercolor;
    _view3.borderWidth = 0.7;
    _text3.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJTSBottomCell";
    TJTSBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJTouSuDetailCell" owner:self options:nil] objectAtIndex:2];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    _text0.text = dic[@"lixiangname"];
    _text1.text = dic[@"lixiangtime"];
    _text2.text = dic[@"zerenname"];
    _text3.text = dic[@"content"];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (_text3.text.length == 0) {
        _hiddenLabel.hidden = NO;
    } else {
        if ([_delegate respondsToSelector:@selector(textreturn:)]) {
            [_delegate textreturn:textView.text];
        }
        _hiddenLabel.hidden = YES;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _hiddenLabel.hidden = YES;
    if ([_delegate respondsToSelector:@selector(textBeginEdit)]) {
        [_delegate textBeginEdit];
    }
}
- (IBAction)button0Ac:(id)sender {
    if ([_delegate respondsToSelector:@selector(chooseLIxiangPeople)]) {
        [_delegate chooseLIxiangPeople];
    }
}
- (IBAction)button1Ac:(id)sender {
    if ([_delegate respondsToSelector:@selector(chooseLixiangTime:)]) {
        [_delegate chooseLixiangTime:_text1];
    }
}
- (IBAction)button2Ac:(id)sender {
    if ([_delegate respondsToSelector:@selector(chooseZerenPeople)]) {
        [_delegate chooseZerenPeople];
    }
}
- (IBAction)button3Ac:(id)sender {
    if (_text2.text.length == 0) {
        SVShowError(@"请选择责任人!");
        return;
    }
    if (_text3.text.length == 0) {
        SVShowError(@"请输入处理流程!");
        return;
    }
    [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"是否提交信息，确认后将无法修改!" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if ([_delegate respondsToSelector:@selector(sureLixiang)]) {
                [_delegate sureLixiang];
            }
        }
    }];
}
@end
