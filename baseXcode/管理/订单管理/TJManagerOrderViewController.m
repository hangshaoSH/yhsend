//
//  TJManagerOrderViewController.m
//  baseXcode
//
//  Created by hangshao on 17/1/5.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJManagerOrderViewController.h"
#import "TJManagerOrderBaseTableViewCell.h"
#import "AFHTTPSessionManager.h"
#import "TJSearchOrderViewController.h"
#import "TJAddOrderViewController.h"
#import "TJOrderDetailViewController.h"
@interface TJManagerOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   assign) NSInteger  page;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@end

@implementation TJManagerOrderViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataDic = [NSMutableDictionary dictionary];
    self.dataDic[@"cpcode"] = @"";
    self.dataDic[@"ordersta"] = @"";
    self.dataDic[@"ordercode"] = @"";
    self.dataDic[@"modid"] = @"";
    self.dataDic[@"billid"] = @"";
    self.dataDic[@"memberfrom"] = @"";
    self.dataDic[@"memberid"] = @"";
    self.dataDic[@"startdate"] = @"";
    self.dataDic[@"enddate"] = @"";
    self.page = 1;
    
    [self setHeaderView];
    
    [self setTableView];
    
    [self setButton];
    
    [self loadManagerOrderList];
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
    label.text = @"订单列表";
    label.font = seventeenFont;
    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        [button addTarget:self action:@selector(backAndSearchOrder:)];
    }
}
- (void)backAndSearchOrder:(UIButton *)button
{
    if (button.tag == 110) {
        [YHNetWork stopTheVcRequset:self];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        TJSearchOrderViewController * vc = [[TJSearchOrderViewController alloc] init];
        vc.myBlock = ^(NSMutableDictionary * dic){
            [self.dataDic removeObjectForKey:@"cpcode"];
            [self.dataDic removeObjectForKey:@"ordersta"];
            [self.dataDic removeObjectForKey:@"ordercode"];
            [self.dataDic removeObjectForKey:@"modid"];
            [self.dataDic removeObjectForKey:@"billid"];
            [self.dataDic removeObjectForKey:@"memberfrom"];
            [self.dataDic removeObjectForKey:@"memberid"];
            [self.dataDic removeObjectForKey:@"startdate"];
            [self.dataDic removeObjectForKey:@"enddate"];
            self.dataDic[@"cpcode"] = dic[@"cpcode"];
            self.dataDic[@"ordersta"] = dic[@"ordersta"];
            self.dataDic[@"ordercode"] = dic[@"ordercode"];
            self.dataDic[@"modid"] = dic[@"modid"];
            self.dataDic[@"billid"] = dic[@"billid"];
            self.dataDic[@"memberfrom"] = dic[@"memberfrom"];
            self.dataDic[@"memberid"] = dic[@"memberid"];
            self.dataDic[@"startdate"] = dic[@"startdate"];
            self.dataDic[@"enddate"] = dic[@"enddate"];
            [self.dataArray removeAllObjects];
            [User sharedUser].showMidLoading = @"数据加载中...";
            [self.tableView reloadData];
            [self refreshmanagerOrderData];
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
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshmanagerOrderData)];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoremanagerOrderData)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
- (void)refreshmanagerOrderData
{
    self.page = 1;
    [self loadManagerOrderList];
}
- (void)addMoremanagerOrderData
{
    self.page ++;
    [self loadManagerOrderList];
}
- (void)setButton
{
    UIButton * button = [[UIButton alloc] initWithFrame:Rect(0, 0, 54*ScaleModel, 54*ScaleModel)];
    button.origin = CGPointMake(kScreenWidth - 44 - 54*ScaleModel, kScreenHeigth - 58 - 54*ScaleModel);
    [button setImage:[UIImage imageNamed:@"house_add_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"house_add_select"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(addOrderAction)];
    [self.view addSubview:button];
}
- (void)addOrderAction
{
    TJAddOrderViewController * vc = [[TJAddOrderViewController alloc] init];
    vc.refreshBlock =^(){
        [self.dataArray removeAllObjects];
        [User sharedUser].showMidLoading = @"数据加载中...";
        [self.tableView reloadData];
        [self refreshmanagerOrderData];
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
        return self.tableView.height;
    }
    NSArray * array = [self.dataArray[indexPath.row][@"orderstr"] componentsSeparatedByString:@"^"];
    CGFloat height = 0;
    CGSize s = [array[5]getStringRectWithfontSize:15 * ScaleModel width:kScreenWidth-30];
    if (s.height == 0) {
        height = 18*ScaleModel;
    } else {
        height = s.height;
    }
    return 227 - 8*18 + 7*fifteenS.height+height + 8*ScaleModel;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
        [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    TJManagerOrderBaseTableViewCell * cell = [TJManagerOrderBaseTableViewCell cellWithTableView:tableView];
    [cell setDataWithLabel:self.dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        if ([[User sharedUser].showMidLoading isEqualToString:@"点击进行刷新!"]) {
            self.page = 1;
            [self loadManagerOrderList];
        }
        return;
    }
    TJOrderDetailViewController * vc = [[TJOrderDetailViewController alloc] init];
    vc.orderid = self.dataArray[indexPath.row][@"orderid"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - netWorking
- (void)loadManagerOrderList
{
    NSMutableDictionary * params1 = [NSMutableDictionary dictionary];
    params1[@"clerkid"] = userClerkid;
    params1[@"cpcode"] = self.dataDic[@"cpcode"];
    params1[@"ordersta"] = self.dataDic[@"ordersta"];
    params1[@"ordercode"] = self.dataDic[@"ordercode"];
    params1[@"modid"] = self.dataDic[@"modid"];
    params1[@"billid"] = self.dataDic[@"billid"];
    params1[@"memberfrom"] = self.dataDic[@"memberfrom"];
    params1[@"memberid"] = self.dataDic[@"memberid"];
    params1[@"startdate"] = self.dataDic[@"startdate"];
    params1[@"enddate"] = self.dataDic[@"enddate"];
    params1[@"recnum"] = @"10";
    params1[@"curpage"] = @(self.page);
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://wy.cqtianjiao.com/guanjia/sincere/psp/orderlist.jsp" parameters:params1 success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString * obj = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([obj containsString:@"\t"]) {
                obj = [obj stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            }
            if ([obj containsString:@"\n"]) {
                obj = [obj stringByReplacingOccurrencesOfString:@"\n" withString:@"^"];
            }
            if ([obj containsString:@"\r\n"]) {
                obj = [obj stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
            }
        obj = [obj substringToIndex:[obj length] - 1];
            NSError * err;
            NSData * jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];//字符串json转字典
    
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if ([dic[@"flag"] integerValue] == 0) {
                if ([dic[@"data"] count] > 0) {
                    [self.dataArray addObjectsFromArray:dic[@"data"]];
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
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
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
#pragma mark - 懒加载
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
@end
