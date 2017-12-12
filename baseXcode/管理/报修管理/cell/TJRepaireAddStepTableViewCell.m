//
//  TJRepaireAddStepTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/12/9.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJRepaireAddStepTableViewCell.h"

@interface TJRepaireAddStepTableViewCell ()<UITextFieldDelegate>

@end

@implementation TJRepaireAddStepTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.font = fifteenFont;
    _label0.textColor = fivelightColor;
    _label1.font = fifteenFont;
    _label1.textColor = fivelightColor;
    _label2.font = fifteenFont;
    _label2.textColor = fivelightColor;
    _bgview0.cornerRadius = 5.0;
    _bgview0.borderColor = bordercolor;
    _bgview0.borderWidth = 0.7;
    _bgview1.cornerRadius = 5.0;
    _bgview1.borderColor = bordercolor;
    _bgview1.borderWidth = 0.7;
    _bgview2.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview2.cornerRadius = 5.0;
    _bgview2.borderColor = bordercolor;
    _bgview2.borderWidth = 0.7;
    _people.font = fifteenFont;
    _timeT.font = fifteenFont;
    _content.font = fifteenFont;
    _leftLabel.textColor = fiveblueColor;
    _leftLabel.font = fifteenFont;
    _rightBut.cornerRadius = 5.0;
    _rightBut.backgroundColor = orangecolor;
    _rightBut.titleFont = 15 * ScaleModel;
    _leftBut.cornerRadius = 5.0;
    _leftBut.borderWidth = 0.7;
    _leftBut.borderColor = fiveblueColor;
    _content.delegate = self;
    _content.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJRepaireAddStepCell";
    TJRepaireAddStepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepireDetailCell" owner:self options:nil] objectAtIndex:5];
    }
    return cell;
}
- (void)setCellWithDic:(NSMutableDictionary *)dic
{
    _people.text = dic[@"clerkname"];
    _timeT.text = dic[@"time"];
    _content.text = dic[@"content"];
    if ([dic[@"count"] integerValue] == 0) {
        _leftLabel.text = @"上传处理图片";
    }else if ([dic[@"count"] integerValue] == 1){
        _leftLabel.text = @"已上传1张";
    }else if ([dic[@"count"] integerValue] == 2){
        _leftLabel.text = @"已上传2张";
    }else {
        _leftLabel.text = @"已上传3张";
    }
}
- (IBAction)choosePeople:(id)sender {
    if ([_delegate respondsToSelector:@selector(chooseStepPeople)]) {
        [_delegate chooseStepPeople];
    }
}
- (IBAction)chooseTime:(id)sender {
    if ([_delegate respondsToSelector:@selector(chooseStepTime:)]) {
        [_delegate chooseStepTime:_timeT];
    }
}
- (IBAction)pushStep:(id)sender {
    if ([_delegate respondsToSelector:@selector(pushImage)]) {
        [_delegate pushImage];
    }
}
- (IBAction)sumbitstep:(id)sender {
    if ([_content.text length] == 0) {
        SVShowError(@"请输入处理内容!");
        return;
    }
    [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"是否添加步骤" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if ([_delegate respondsToSelector:@selector(submitStep)]) {
                [_delegate submitStep];
            }
        }
    }];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(textEditBegin)]) {
        [_delegate textEditBegin];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(textEditEnd:)]) {
        [_delegate textEditEnd:textField];
    }
}
@end
