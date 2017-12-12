//
//  TJOrderGoodsTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 17/1/6.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJOrderGoodsTableViewCell.h"

@interface TJOrderGoodsTableViewCell ()<UITextFieldDelegate>
@property (nonatomic,   assign) NSInteger  index;
@end

@implementation TJOrderGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _allcount.font = thirteenFont;
    _allcount.textColor = [UIColor colorWithHexString:@"989898"];
    _price.font = fourteenFont;
    _countT.font = fourteenFont;
    _title.font = fourteenFont;
    _label0.font = fourteenFont;
    _label1.font = fourteenFont;
    _label2.font = fourteenFont;
    _label3.font = fourteenFont;
    _bgview1.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview1.borderWidth = 1.0;
    _bgview1.cornerRadius = 5.0;
    _bgview2.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview2.borderWidth = 1.0;
    _bgview2.cornerRadius = 5.0;
    _price.delegate = self;
    _countT.delegate = self;
    _deleteL.textColor = fiveblueColor;
    _countT.keyboardType = UIKeyboardTypeNumberPad;
    _price.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    _countT.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    _price.tag = 11110;
    _countT.tag = 11111;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJOrderGoodsBaseCell";
    TJOrderGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJManagerOrderCell" owner:self options:nil] objectAtIndex:4];
    }
    return cell;
}
- (void)setDataWithLabel:(NSMutableDictionary *)dic andindex:(NSInteger)index
{
    self.index = index;
    
    _countT.text = dic[@"count"];
    _price.text = dic[@"price"];
    if ([dic[@"allcount"] length] == 0) {
        _allcount.text = @"库存数量：0";
    }else {
        _allcount.text = [NSString stringWithFormat:@"库存数量：%@",dic[@"allcount"]];
    }
    if ([dic[@"billtitle"] length] == 0) {
        _title.text = @"未知";
    }else {
       _title.text = dic[@"billtitle"];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 11110) {
        if ([_delegate respondsToSelector:@selector(textendchange:andIndex:andFlag:)]) {
            [_delegate textendchange:textField andIndex:self.index andFlag:0];
        }
    }else {
        if ([_delegate respondsToSelector:@selector(textendchange:andIndex:andFlag:)]) {
            [_delegate textendchange:textField andIndex:self.index andFlag:1];
        }
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 11110) {
        if ([_delegate respondsToSelector:@selector(textBeginchange:andIndex:andFlag:)]) {
            [_delegate textBeginchange:textField andIndex:self.index andFlag:0];
        }
    }else {
        if ([_delegate respondsToSelector:@selector(textBeginchange:andIndex:andFlag:)]) {
            [_delegate textBeginchange:textField andIndex:self.index andFlag:1];
        }
    }
}
- (IBAction)deleteAc:(id)sender {
    [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"是否删除该商品?" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if ([_delegate respondsToSelector:@selector(deleteGoods:)]) {
                [_delegate deleteGoods:self.index];
            }
        }
    }];
}
@end
