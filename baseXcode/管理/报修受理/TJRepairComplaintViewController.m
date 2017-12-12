//
//  TJRepairComplaintViewController.m
//  baseXcode
//
//  Created by hangshao on 16/11/19.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJRepairComplaintViewController.h"
#import "TJRepaireManagerBaseTableViewCell.h"
#import "TJRepaireComplaintDetailViewController.h"
#import "TJSearchComplaintViewController.h"
@interface TJRepairComplaintViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   assign) NSInteger   page;
@end

@implementation TJRepairComplaintViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    
    [self setTopView];
    
    [self setTableView];
    
    [self setHeaderView];
    
    [self loadRepairManagerList];
    
    [self loadBaoxiuBaseData];
}
#pragma mark - setView
- (void)setHeaderView
{
    UIView * topView = [[[NSBundle mainBundle] loadNibNamed:@"TJManageTopCell" owner:self options:nil] firstObject];
    topView.origin = zeroOrigin;
    topView.width = kScreenWidth;
    topView.height = 64;
    topView.backgroundColor = TopBgColor;
    [self.view addSubview:topView];
    
    UILabel * label = (UILabel *)[topView viewWithTag:100];
    label.text = @"报修受理列表";
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
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        TJSearchComplaintViewController * vc = [[TJSearchComplaintViewController alloc] init];
        vc.MyBlock = ^(NSMutableDictionary * dic){
            self.dataDic = nil;
            self.dataDic[@"cpcode"] = dic[@"cpcode"];
            self.dataDic[@"modid"] = dic[@"modid"];
            self.dataDic[@"isaccept"] = dic[@"isaccept"];
            self.dataDic[@"msgkeys"] = dic[@"msgkeys"];
            self.dataDic[@"isclose"] = dic[@"isclose"];
            self.dataDic[@"ispunish"] = dic[@"ispunish"];
            self.dataDic[@"isvisit"] = dic[@"isvisit"];
            self.dataDic[@"endtime"] = dic[@"enddate"];
            self.dataDic[@"starttime"] = dic[@"startdate"];
            [self.dataArray removeAllObjects];
            [User sharedUser].showMidLoading = @"数据加载中...";
            [self.tableView reloadData];
            self.page = 1;
            [self loadRepairManagerList];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)setTopView
{
    
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
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshRepair)];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRepair)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
- (void)refreshRepair
{
    self.page = 1;
    [self loadRepairManagerList];
}
- (void)loadMoreRepair
{
    self.page++;
    [self loadRepairManagerList];
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
    CGSize s = [self.dataArray[indexPath.row][@"msgcontent"] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-102];
    return 63 + 4 * fifteenS.height + 8 *ScaleModel + s.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
        [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    TJRepaireManagerBaseTableViewCell * cell = [TJRepaireManagerBaseTableViewCell cellWithTableView:tableView];
    [cell setCellWithDic:self.dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        if ([[User sharedUser].showMidLoading isEqualToString:@"点击进行刷新!"]) {
            [self loadRepairManagerList];
        }
        return;
    }
    TJRepaireComplaintDetailViewController * vc = [[TJRepaireComplaintDetailViewController alloc] init];
    vc.orderid = self.dataArray[indexPath.row][@"orderid"];
    vc.MyBlock = ^(){
        [self refreshRepair];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - buttonAction

#pragma mark - delete

#pragma mark - netWorking
- (void)loadRepairManagerList
{
    NSString * url = @"wuye/mendrequest.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"cpcode"] = self.dataDic[@"cpcode"];
    params[@"modid"] = self.dataDic[@"modid"];
    params[@"isaccept"] = self.dataDic[@"isaccept"];
    params[@"msgkeys"] = self.dataDic[@"msgkeys"];
    params[@"isclose"] = self.dataDic[@"isclose"];
    params[@"ispunish"] = self.dataDic[@"ispunish"];
    params[@"isvisit"] = self.dataDic[@"isvisit"];
    params[@"starttime"] = self.dataDic[@"starttime"];
    params[@"endtime"]= self.dataDic[@"endtime"];
    params[@"recnum"] = @"10";
    params[@"curpage"] = @(self.page);
    
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([request[@"flag"] integerValue] == 0) {
            if ([request[@"data"] count] > 0) {
                if (self.page == 1) {
                    [self.dataArray removeAllObjects];
                }
                [self.dataArray addObjectsFromArray:request[@"data"]];
            }else {
                if (self.page > 1) {
                    SVShowError(@"已无更多数据");
                }else {
                    [User sharedUser].showMidLoading = @"";
                }
            }
        }else {
            SVShowError(request[@"err"]);
        }
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [User sharedUser].showMidLoading = @"无网络连接，请检查您的网络!";
        [self.tableView reloadData];
    }];
}
- (void)loadBaoxiuBaseData
{
    NSString * url = @"wuye/bxdata.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            if ([request[@"data"] count] > 0) {
                YYCache * cache = [TJCache shareCache].yyCache;
                [cache removeObjectForKey:@"baoxiuBaseData"];
                [cache setObject:[request[@"data"] data] forKey:@"baoxiuBaseData"];
            }else {
                
            }
        }else {
            [self loadBaoxiuBaseData];
        }
    } failBlock:^(NSError *error) {
        [self loadBaoxiuBaseData];
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
