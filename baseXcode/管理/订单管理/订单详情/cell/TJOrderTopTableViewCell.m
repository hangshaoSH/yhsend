//
//  TJOrderTopTableViewCell.m
//  baseXcode
//
//  Created by hangshao on 17/1/9.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJOrderTopTableViewCell.h"
#import "TJOrderLabelTableViewCell.h"

@interface TJOrderTopTableViewCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   strong) NSMutableArray     * dataarray;

@end

@implementation TJOrderTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label1.textColor = fivelightColor;
    _label2.textColor = fivelightColor;
    _label3.textColor = fivelightColor;
    _label0.textColor = fivelightColor;
    _label0.font = fifteenFont;
    _label1.font = fifteenFont;
    _label2.font = fifteenFont;
    _label3.font = fifteenFont;
    _status.font = fifteenFont;
    _number.font = fifteenFont;
    _title.font = fifteenFont;
    _countt.font = fifteenFont;
    _money.font = fifteenFont;
    _allpay.font = fifteenFont;
    _guwen.font = fifteenFont;
    _remark.font = fifteenFont;
    _orderlast.font = fifteenFont;
    _orderstatus.font = fifteenFont;
    _bgview1.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview1.cornerRadius = 5.0;
    _bgview1.borderColor = bordercolor;
    _bgview1.borderWidth = 0.7;
    _bgview2.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _bgview2.cornerRadius = 5.0;
    _bgview2.borderColor = bordercolor;
    _bgview2.borderWidth = 0.7;
    _tableview.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.scrollEnabled = NO;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TJOrderDetailTopCell";
    TJOrderTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJOrderDetailCell" owner:self options:nil] objectAtIndex:0];
    }
    return cell;
}
- (void)setDataWithLabel:(NSMutableDictionary *)dic
{
    _number.text = dic[@"ordercode"];
    _status.text = dic[@"orderstaname"];
    NSArray * dataarray = [dic[@"orderstr"] componentsSeparatedByString:@"^"];
    if (dataarray.count > 0) {
        _title.text = dataarray[0];
    }
    if (dataarray.count > 1) {
        _money.text = dataarray[1];
    }
    if (dataarray.count > 2) {
        _countt.text = dataarray[2];
    }
    if (dataarray.count > 3) {
         _allpay.text = dataarray[3];
    }
    if (dataarray.count > 4) {
        _guwen.text = dataarray[4];
    }
    if (dataarray.count > 5) {
        _remark.text = dataarray[5];
    }
    if (dataarray.count > 6) {
        _orderstatus.text = dataarray[6];
    }
    if (dataarray.count > 7) {
        _orderlast.text = dataarray[7];
    }
    self.dataarray = [NSMutableArray arrayWithCapacity:0];
    if (self.dataarray.count > 0) {
        [self.dataarray removeAllObjects];
    }
    if ([dic[@"orderguest"] length] == 0) {
        [self.dataarray addObject:@"暂无"];
    }else {
        NSArray * kehudata = [dic[@"orderguest"] componentsSeparatedByString:@"^"];
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
