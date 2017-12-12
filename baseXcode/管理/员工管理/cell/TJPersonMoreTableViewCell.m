//
//  TJPersonMoreTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 16/11/28.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJPersonMoreTableViewCell.h"
#import "TJMemberHeaderTableViewCell.h"
#import "TJMemberNormalTableViewCell.h"

@interface TJPersonMoreTableViewCell ()<UITableViewDataSource,UITableViewDelegate,TJPersonHeaderDeleagte>

@property (nonatomic,   weak) UITableView     * tableView;
@property (weak, nonatomic) IBOutlet UITableView *mytableview;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@end

@implementation TJPersonMoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.mytableview.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.mytableview.delegate = self;
    self.mytableview.dataSource = self;
    self.mytableview.showsVerticalScrollIndicator = NO;
    self.mytableview.scrollEnabled = NO;
    self.mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJMemberMoreCell";
    TJPersonMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJPersonManagerCell" owner:self options:nil] objectAtIndex:2];
    }
    return cell;
}
- (void)setButTag:(NSInteger)tag andData:(NSMutableDictionary *)dic
{
    self.dataDic= [NSMutableDictionary dictionaryWithDictionary:dic];
    self.dataDic[@"tag"] = @(tag);
    CGFloat height = seventeenS.height + 21;
    if ([dic[@"flag"] integerValue] == 0) {
        
    } else {
        height = height + [dic[@"clerklist"] count] * (seventeenS.height + 21);
    }
    self.mytableview.frame = Rect(15*ScaleModel, 0, kScreenWidth-30*ScaleModel, height);
    [self.mytableview reloadData];
}
#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataDic[@"flag"] integerValue] == 0) {
        return 0;
    }
    return [self.dataDic[@"clerklist"] count];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return seventeenS.height + 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataDic[@"flag"] integerValue] == 0) {
        return [UITableViewCell new];
    }
    TJMemberNormalTableViewCell * cell = [TJMemberNormalTableViewCell cellWithTableView:tableView];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic[@"clerklist"][indexPath.row]];
    dic[@"hidden"] = self.dataDic[@"hidden"];
    dic[@"otherHidden"] = self.dataDic[@"otherHidden"];
    [cell setdataWithDic:dic];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return seventeenS.height + 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TJMemberHeaderTableViewCell * cell = [TJMemberHeaderTableViewCell cellWithTableView:tableView];
    [cell setButTag:section andData:self.dataDic];
    cell.delegate = self;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(selectCell:WithDic:)]) {
        [_delegate selectCell:indexPath.row WithDic:self.dataDic];
    }
}
- (void)touchWithTag:(NSInteger)tag
{
    if ([self.dataDic[@"flag"] integerValue] == 1) {
        [self.dataDic removeObjectForKey:@"flag"];
        self.dataDic[@"flag"] = @"0";
    }else {
        [self.dataDic removeObjectForKey:@"flag"];
        self.dataDic[@"flag"] = @"1";
    }
    if ([_delegate respondsToSelector:@selector(touchMoreCell:withDic:)]) {
        [_delegate touchMoreCell:[self.dataDic[@"tag"] integerValue] withDic:self.dataDic];
    }
}
@end
