//
//  TJMemberFooterTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/11/20.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJMemberFooterTableViewCell.h"

@interface TJMemberFooterTableViewCell ()

@property (nonatomic,   assign) NSInteger   flag;

@end

@implementation TJMemberFooterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _yezhuxinxi.font = [UIFont systemFontOfSize:17 * ScaleModel];
    _yezhuxinxi.textColor = [UIColor colorWithHexString:@"c9383a"];
    _label0.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _label0.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    _label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _label1.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    _label2.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _label2.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    _nameL.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _nameL.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    _phoneL.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _phoneL.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    _addressT.font = [UIFont systemFontOfSize:15 * ScaleModel];
    _addressT.userInteractionEnabled = NO;
    _shouli.cornerRadius = 5.0;
    _shouli.backgroundColor = [UIColor colorWithHexString:@"ffb400"];
    _shouli.titleFont = 15 * ScaleModel;
    _bushouli.cornerRadius = 5.0;
    _bushouli.backgroundColor = [UIColor colorWithHexString:@"b5b5b5"];
    _bushouli.titleFont = 15 * ScaleModel;
    _redView.backgroundColor = [UIColor colorWithHexString:@"c9383a"];
    _bgview.cornerRadius = 5.0;
    _bgview.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview.borderWidth = 0.7;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJMemberDetailFooterManagecell";
    TJMemberFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJMemberManagecell" owner:self options:nil] objectAtIndex:3];
    }
    return cell;
}
- (void)setDataWithDic:(NSMutableDictionary *)dic dic1:(NSMutableDictionary *)dic1
{
    if ([dic1 count] > 0) {
        self.phoneL.text = dic1[@"mobile"];
        self.nameL.text = dic1[@"ownername"];
    }
    if ([dic count] > 0) {
        self.addressT.text = [NSString stringWithFormat:@"%@－%@－%@",dic[@"cpname"],dic[@"buildname"],dic[@"housename"]];
    }
}
- (void)isshowHouseId:(BOOL)show
{
    if (show == YES) {
        self.flag = 1;
    } else {
        self.flag = 0;
    }
}
- (IBAction)chooseAddress:(id)sender {
    if ([_delegate respondsToSelector:@selector(chooseAddressAction)]) {
        [_delegate chooseAddressAction];
    }
}
- (IBAction)playPhone:(id)sender {
    if (self.phoneL.text.length == 0) {
        return;
    }
    [[User sharedUser] callUp:self.phoneL.text];
}
- (IBAction)shouli:(id)sender {
    if (self.flag == 1) {
        if (self.addressT.text.length == 0) {
            SVShowError(@"请选择准确地址!");
            return;
        }
    }
    if ([_delegate respondsToSelector:@selector(yesOrNoShouliAc:)]) {
        [_delegate yesOrNoShouliAc:1];
    }
}
- (IBAction)bushouli:(id)sender {
    if (self.flag == 1) {
        if (self.addressT.text.length == 0) {
            SVShowError(@"请选择准确地址!");
            return;
        }
    }
    if ([_delegate respondsToSelector:@selector(yesOrNoShouliAc:)]) {
        [_delegate yesOrNoShouliAc:2];
    }
}

@end
