//
//  GatherRecordViewController.m
//  baseXcode
//
//  Created by app on 2017/8/13.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "GatherRecordViewController.h"
#import "SKRecordNormalTV.h"
#import "SKSearchViewController.h"
#import "SKRecordDetailViewController.h"
@interface GatherRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic, assign) NSInteger page;

@end

@implementation GatherRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataDic = [NSMutableDictionary dictionary];
    if ([self.jumpDic count] > 0) {
        self.dataDic[@"cpcode"] = self.jumpDic[@"cpcode"];
        self.dataDic[@"houseid"] = self.jumpDic[@"houseid"];
    }else {
        self.dataDic[@"cpcode"] = @"";
        self.dataDic[@"houseid"] = @"";
    }
    
    [self setTableView];
    
    [self setHeaderView];
    
    self.page = 1;
    
    [self loadGatherList];
}
#pragma mark - view
- (void)setHeaderView
{
    UIView * topView = [[[NSBundle mainBundle] loadNibNamed:@"TJManageTopCell" owner:self options:nil] firstObject];
    topView.origin = zeroOrigin;
    topView.width = kScreenWidth;
    topView.height = 64;
    topView.backgroundColor = TopBgColor;
    [self.view addSubview:topView];
    
    UILabel * label = (UILabel *)[topView viewWithTag:100];
    label.text = @"收款记录列表";
    label.font = seventeenFont;
    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        [button addTarget:self action:@selector(backAndRepairSearch:)];
    }
}
- (void)backAndRepairSearch:(UIButton *)button
{
    if (button.tag == 110) {
        [YHNetWork stopTheVcRequset:self];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        SKSearchViewController * vc = [[SKSearchViewController alloc] init];
        vc.MyBlock = ^(NSMutableDictionary * dic){
            self.dataDic = nil;
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [self.dataArray removeAllObjects];
            [User sharedUser].showMidLoading = @"数据加载中...";
            [self.tableView reloadData];
            self.page = 1;
            [self loadGatherList];
        };
//        vc.refreshBlock = ^(){
//            self.page = 1;
//            [self loadGatherList];
//        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)setTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //    初始化tabelView
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeigth - 64) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshRecoedData)];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreRecoedData)];
    self.tableView = tableView;
}
- (void)refreshRecoedData
{
    self.page = 1;
    [self.dataArray removeAllObjects];
    [self loadGatherList];
}
- (void)addMoreRecoedData
{
    self.page ++;
    [self loadGatherList];
}
#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        return 1;
    }
    return self.dataArray.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return self.tableView.height;
    }
    return 153 - 18 * 5 + 5 * fifteenS.height + 12;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
        [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    SKRecordNormalTV * cell = [SKRecordNormalTV cellWithTableView:tableView];
    [cell setCellWithDic:self.dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    SKRecordDetailViewController * vc = [[SKRecordDetailViewController alloc] init];
    vc.billid = self.dataArray[indexPath.row][@"billid"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - networkong
- (void)loadGatherList
{
    [User sharedUser].urlFlag = 1;
    NSString * url = @"wuye/feelist_gj.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"cpcode"] = self.dataDic[@"cpcode"];
    params[@"houseid"] = self.dataDic[@"houseid"];
    params[@"recnum"] = @"10";
    params[@"curpage"] = @(self.page);
    
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([request count] > 0) {
            [self.dataArray addObjectsFromArray:request];
            if (self.page > 1) {
                if ([request count] == 0) {
                    SVShowError(@"已无更多数据");
                }
            }else {
                [User sharedUser].showMidLoading = @"";
            }
        }else {
            self.page -- ;
            [User sharedUser].showMidLoading = @"数据加载出错!";
        }
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        self.page -- ;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [User sharedUser].showMidLoading = @"无网络连接，请检查您的网络!";
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
