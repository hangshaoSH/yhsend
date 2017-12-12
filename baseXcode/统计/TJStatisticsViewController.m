//
//  TJStatisticsViewController.m
//  baseXcode
//
//  Created by hangshao on 16/11/25.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJStatisticsViewController.h"
#import "AFHTTPSessionManager.h"
#import "TJTongJiWebTableViewCell.h"
@interface TJStatisticsViewController ()<UITableViewDelegate,UITableViewDataSource,TJWebDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   weak) UILabel     * midLabel;
@end

@implementation TJStatisticsViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [User sharedUser].refreshFlag = 3;
    if ([User sharedUser].goflag == 1) {
        [self.tableView reloadData];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [User sharedUser].refreshFlag = 0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHeaderView];
    
    [self setTopView];
    
    [self setTableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshtongjidata) name:@"refreshtongji" object:nil];
}
- (void)refreshtongjidata
{
    [self.tableView reloadData];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshtongji" object:nil];
}
#pragma mark - setView
- (void)setHeaderView
{
    UIView * topView = [[[NSBundle mainBundle] loadNibNamed:@"TJStatisticsCell" owner:self options:nil] firstObject];
    topView.origin = zeroOrigin;
    topView.width = kScreenWidth;
    topView.height = 64;
    topView.backgroundColor = fiveblueColor;
    [self.view addSubview:topView];
    
    UILabel * label = (UILabel *)[topView viewWithTag:100];
    label.font = seventeenFont;
    label.text = [User sharedUser].h5Title;
    self.midLabel = label;
    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        [button addTarget:self action:@selector(homeAndRefresh:)];
    }
}
- (void)homeAndRefresh:(UIButton *)button
{
    if (button.tag == 110) {
        [User sharedUser].h5flag = 1;
        [User sharedUser].h5Title= @"统计首页";
        [User sharedUser].h5Urlstring = @"http://wy.cqtianjiao.com/guanjia/sincere/web/statindex.jsp";
        self.midLabel.text = [User sharedUser].h5Title;
    } else {
        
    }
    [self.tableView reloadData];
}
- (void)setTopView
{
    
}
- (void)setTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //    初始化tabelView
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeigth - 64-49) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenHeigth - 64 - 49;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJTongJiWebTableViewCell * cell = [TJTongJiWebTableViewCell cellWithTableView:tableView];
    [cell seturlWithStr:[User sharedUser].h5Urlstring];
    [cell setDelegate:self];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return;
    }
}

#pragma mark - buttonAction

#pragma mark - delete
- (void)touchTitle:(NSString *)title
{
    self.midLabel.text = title;
}
#pragma mark - netWorking

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
