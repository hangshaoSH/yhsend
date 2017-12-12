//
//  TJORderTowTopTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 17/1/9.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJORderTowTopTableViewCell.h"
#import "TJOrderLabelTableViewCell.h"
@interface TJORderTowTopTableViewCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   strong) NSMutableArray     * dataarray;

@end

@implementation TJORderTowTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label0.textColor = fivelightColor;
    _label0.font = fifteenFont;
    _bgview.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview.cornerRadius = 5.0;
    _bgview.borderColor = bordercolor;
    _bgview.borderWidth = 0.7;
    _tableview.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _tableview.delegate = self;
    _tableview.dataSource = self;
     _tableview.scrollEnabled = NO;
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJOrderDetailTowTopCell";
    TJORderTowTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJOrderDetailCell" owner:self options:nil] objectAtIndex:1];
    }
    return cell;
}
- (void)setDataWithLabel:(NSMutableDictionary *)dic
{
    self.dataarray = [NSMutableArray arrayWithCapacity:0];
    if (self.dataarray.count > 0) {
        [self.dataarray removeAllObjects];
    }
    if ([dic[@"orderpay"] length] == 0) {
        [self.dataarray addObject:@"暂无"];
    }else {
        NSArray * kehudata = [dic[@"orderpay"] componentsSeparatedByString:@"^"];
        [self.dataarray addObjectsFromArray:kehudata];
    }
    [_tableview reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataarray.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize s = [self.dataarray[indexPath.row] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-42];
    return s.height + 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJOrderLabelTableViewCell * cell = [TJOrderLabelTableViewCell cellWithTableView:tableView];
    cell.concent.text = self.dataarray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

@end
