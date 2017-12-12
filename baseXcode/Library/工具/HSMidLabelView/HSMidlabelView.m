//
//  HSMidlabelView.m
//  baseXcode
//
//  Created by hangshao on 16/11/21.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "HSMidlabelView.h"

static HSMidlabelView * _midLabelView = nil;
static myblock _myblock;
@interface HSMidlabelView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   weak) UIView     * midview;
@property (nonatomic,   weak) UIView     * bgView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSString     * colorStr;
@end

@implementation HSMidlabelView

+(instancetype)sharedInstance
{
    if (_midLabelView == nil) {
        _midLabelView = [[self alloc] init];
    }
    return _midLabelView;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _midLabelView = [super allocWithZone:zone];
    });
    return _midLabelView;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
}
- (void)setOriginX:(CGFloat)x andOriginY:(CGFloat)y andWidth:(CGFloat)w andHeight:(CGFloat)h andData:(NSMutableArray *)dataArray withString:(NSString *)colorString clickAtIndex:(myblock)indexBlock
{
    self.colorStr = [NSString string];
    self.colorStr = colorString;
    _myblock = [indexBlock copy];
    self.dataArray = [NSMutableArray arrayWithArray:dataArray];
    UIView * bgView = [[UIView alloc] initWithFrame:[([UIApplication sharedApplication].delegate) window].rootViewController.view.frame];
    bgView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [bgView addGestureRecognizer:tapGestureRecognizer];
    self.bgView = bgView;
   
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, w, h) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[UIApplication sharedApplication].keyWindow addSubview:tableView];
    self.tableView = tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"HSMidlabelCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HSMidlabelCell" owner:self options:nil] firstObject];
    }
    UILabel * label = (UILabel *)[cell.contentView viewWithTag:100];
    label.font = fifteenFont;
    if ([self.dataArray[indexPath.row] length] == 0) {
        label.text = @"请选择";
    }else {
        label.text = self.dataArray[indexPath.row];
    }
    
    if ([label.text isEqualToString:self.colorStr]) {
        cell.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    } else {
        cell.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"label"] = self.dataArray[indexPath.row];
    dic[@"index"] = @(indexPath.row);
    if (_myblock) {
        _myblock(dic);
    }
}
- (void)keyboardHide
{
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    [self.bgView removeFromSuperview];
    self.bgView = nil;
}
@end
