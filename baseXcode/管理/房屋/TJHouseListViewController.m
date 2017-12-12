//
//  TJHouseListViewController.m
//  baseXcode
//
//  Created by hangshao on 16/11/18.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJHouseListViewController.h"
#import "TJHouseListTableViewCell.h"
#import "TJHouseDetailViewController.h"
#import "TJEditeHouseDataViewController.h"
@interface TJHouseListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   assign) NSInteger  page;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@end

@implementation TJHouseListViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataDic = [NSMutableDictionary dictionary];
    self.page = 1;
    
    [self setHeaderView];
    
    [self setTableView];
    
    [self setButton];
    
    [self loadHouseListData];
    
    [self loadHouseBaseData];
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
    label.text = @"房屋列表";
    label.font = seventeenFont;
    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        [button addTarget:self action:@selector(backAndSearch:)];
    }
}
- (void)backAndSearch:(UIButton *)button
{
    if (button.tag == 110) {
        [YHNetWork stopTheVcRequset:self];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        TJSearchHouseViewController * vc = [[TJSearchHouseViewController alloc] init];
        vc.jumpDic = self.jumpDic;
        vc.jumpFlag = self.jumpFlag;
        vc.MyBlock = ^(){
            [self.dataArray removeAllObjects];
            [User sharedUser].showMidLoading = @"数据加载中...";
            [self.tableView reloadData];
            [self refreshHouseData];
        };
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
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHouseData)];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreHouseData)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
- (void)refreshHouseData
{
    self.page = 1;
    [self loadHouseListData];
}
- (void)addMoreHouseData
{
    self.page ++;
    [self loadHouseListData];
}
- (void)setButton
{
    UIButton * button = [[UIButton alloc] initWithFrame:Rect(0, 0, 54*ScaleModel, 54*ScaleModel)];
    button.origin = CGPointMake(kScreenWidth - 44 - 54*ScaleModel, kScreenHeigth - 58 - 54*ScaleModel);
    [button setImage:[UIImage imageNamed:@"house_add_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"house_add_select"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(addWYAction)];
    [self.view addSubview:button];
}
- (void)addWYAction
{
    TJEditeHouseDataViewController * vc = [[TJEditeHouseDataViewController alloc] init];
    vc.navTitle = @"添加物业";
    vc.refreshBlock =^(){
        [self.dataArray removeAllObjects];
        [User sharedUser].showMidLoading = @"数据加载中...";
        [self.tableView reloadData];
        [self refreshHouseData];
    };
    [self.navigationController pushViewController:vc animated:YES];
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
        return kScreenHeigth - 64;
    }
    CGSize s = [@"相关" getStringRectWithfontSize:15 * ScaleModel width:100];
    return s.height * 5 + 68;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
        [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    TJHouseListTableViewCell * cell = [TJHouseListTableViewCell cellWithTableView:tableView];
    [cell setDataWithLabel:self.dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return;
    }
    TJHouseDetailViewController * vc = [[TJHouseDetailViewController alloc] init];
    vc.houseid = self.dataArray[indexPath.row][@"houseid"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - netWorking
- (void)loadHouseListData
{
    YYCache * cache = [TJCache shareCache].yyCache;
    NSData * data = (id)[cache objectForKey:@"searchData"];
    NSMutableDictionary * dic = [data toDictionary];
    NSString * urlS = @"houselist.jsp";
    
    NSString * buildcode = [NSString string];
    NSString * housename = [NSString string];
    NSString * housetypeid = [NSString string];
    NSString * housestaid = [NSString string];
    NSString * unittypeid = [NSString string];
    NSString * cpcode = [NSString string];
    if ([self.jumpFlag integerValue] == 1) {
        buildcode = self.jumpDic[@"buildcode"];
        housename = @"";
        housetypeid = @"";
        housestaid = @"";
        unittypeid = @"";
        cpcode = self.jumpDic[@"cpcode"];
    } else {
        buildcode = dic[@"buildcode"];
        housename = dic[@"housename"];
        housetypeid = dic[@"housetypeid"];
        housestaid = dic[@"housestaid"];
        unittypeid = dic[@"unittypeid"];
        cpcode = dic[@"cpcode"];
    }
    
    NSMutableDictionary * params1 = [NSMutableDictionary dictionary];
    params1[@"clerkid"] = [User sharedUser].userInfo[@"clerkid"];
    params1[@"buildcode"] = buildcode;
    params1[@"housename"] = housename;
    params1[@"housetypeid"] = housetypeid;
    params1[@"housestaid"] = housestaid;
    params1[@"unittypeid"] = unittypeid;
    params1[@"cpcode"] = cpcode;
    params1[@"recnum"] = @"10";
    params1[@"curpage"] = @(self.page);
    [YHNetWork invokeApi:urlS args:params1 target:self completeBlock:^(id request) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([request[@"flag"] integerValue] == 0) {
            if ([request[@"data"] count] > 0) {
                [self.dataArray addObjectsFromArray:request[@"data"]];
            }else {
                if (self.page > 1) {
                    SVShowError(@"已无更多数据");
                }
                [User sharedUser].showMidLoading = @"";
            }
        }else {
            [User sharedUser].showMidLoading = @"点击进行刷新!";
        }
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.dataArray.count > 0) {
            SVShowError(@"无网络连接，请检查您的网络!");
            return ;
        }
        [User sharedUser].showMidLoading = @"无网络连接，请检查您的网络!";
        [self.tableView reloadData];
    }];
}
- (void)loadHouseBaseData
{
    NSString * url = @"house/housedata.jsp";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"data"] count] > 0) {
            YYCache * cache = [TJCache shareCache].yyCache;
            [cache removeObjectForKey:@"houseBaseData"];
            [cache setObject:[request[@"data"] data] forKey:@"houseBaseData"];
        }else {
            
        }
    } failBlock:^(NSError *error) {
        
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
@end
