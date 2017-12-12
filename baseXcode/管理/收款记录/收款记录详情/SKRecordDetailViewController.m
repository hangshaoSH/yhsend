//
//  SKRecordDetailViewController.m
//  baseXcode
//
//  Created by app on 2017/8/13.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "SKRecordDetailViewController.h"
#import "SKDetailTC.h"
#import "SKDetail2TC.h"
@interface SKRecordDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   assign) NSInteger  index;
@end

@implementation SKRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableView];
    
    [self loadRecordDetail];
}
#pragma mark - setView
- (void)setTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = BackgroundGrayColor;
    //    初始化tabelView
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeigth - 64) style:UITableViewStylePlain];
    tableView.backgroundColor = BackgroundGrayColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    WeakSelf
    wself.ts_navgationBar = [TSNavigationBar navWithTitle:@"收款记录详情" backAction:^{
        [YHNetWork stopTheVcRequset:wself];
        [wself.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataDic count] == 0) {
        return 1;
    }
    return 2 + self.dataArray.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataDic count] == 0) {
        return self.tableView.height;
    }
    if (indexPath.row == 0) {
        return 302 - 18 * 7 + fifteenS.height * 7 + 12;
    }else if (indexPath.row == 1) {
        return 84;
    }else {
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataDic count] == 0) {
        TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
        [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 0) {
        SKDetailTC * cell = [SKDetailTC cellWithTableView:tableView];
        [cell setCellWithDic:self.dataDic];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1){
        static NSString * ID = @"SKDetailCell1";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SKDetailCell" owner:self options:nil] objectAtIndex:1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        SKDetail2TC * cell = [SKDetail2TC cellWithTableView:tableView];
        [cell setCellWithDic:self.dataArray[indexPath.row - 2]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
#pragma mark - netWorking
- (void)loadRecordDetail
{
    [User sharedUser].urlFlag = 1;
    NSString * url = @"wuye/feebill_gj.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"billid"] = self.billid;
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request count] > 0) {
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:request];
            if ([request[@"shoulist"] count] > 0) {
                [self.dataArray addObjectsFromArray:request[@"shoulist"]];
            }
        }else {
            [User sharedUser].showMidLoading = @"点击进行刷新!";
        }
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        [User sharedUser].showMidLoading = @"网络连接错误，请检查您的网络!";
        [self.tableView reloadData];
    }];
}
#pragma mark - 懒加载
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
- (NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

@end
