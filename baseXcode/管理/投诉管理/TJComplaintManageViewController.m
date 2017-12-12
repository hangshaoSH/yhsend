//
//  TJComplaintManageViewController.m
//  baseXcode
//
//  Created by hangshao on 16/11/20.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJComplaintManageViewController.h"
#import "TJSearchAboutRepierViewController.h"
#import "TJComplainBaseTableViewCell.h"
#import "TJAddComplaintViewController.h"
#import "TJTouSuDetailViewController.h"
@interface TJComplaintManageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   assign) NSInteger   page;
@end

@implementation TJComplaintManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    
    [self setTopView];
    
    [self setTableView];
    
    [self setHeaderView];
    
    [self setButton];
    
    [self loadComplaintList];
    
    [self loadComplainBaseData];
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
    label.text = @"投诉单列表";
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
        TJSearchAboutRepierViewController * vc = [[TJSearchAboutRepierViewController alloc] init];
        vc.jumpFlag = 1;
        vc.MyBlock = ^(NSMutableDictionary * dic){
            self.dataDic = nil;
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [self.dataArray removeAllObjects];
            [User sharedUser].showMidLoading = @"数据加载中...";
            [self.tableView reloadData];
            [self loadComplaintList];
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
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshComplant)];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComplaint)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
- (void)setButton
{
    UIButton * button = [[UIButton alloc] initWithFrame:Rect(0, 0, 54*ScaleModel, 54*ScaleModel)];
    button.origin = CGPointMake(kScreenWidth - 44 - 54*ScaleModel, kScreenHeigth - 58 - 54*ScaleModel);
    [button setImage:[UIImage imageNamed:@"house_add_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"house_add_select"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(addBXAction)];
    [self.view addSubview:button];
}
- (void)addBXAction
{
    TJAddComplaintViewController * vc = [[TJAddComplaintViewController alloc] init];
    vc.MyBlock = ^(){
        [self.dataArray removeAllObjects];
        [User sharedUser].showMidLoading = @"数据加载中...";
        [self.tableView reloadData];
        [self refreshComplant];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)refreshComplant
{
    self.page = 1;
    [self loadComplaintList];
}
- (void)loadMoreComplaint
{
    self.page++;
    [self loadComplaintList];
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
    return 74 + 6 * fifteenS.height + 8 *ScaleModel + s.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
        [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    TJComplainBaseTableViewCell * cell = [TJComplainBaseTableViewCell cellWithTableView:tableView];
    [cell setCellWithDic:self.dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        if ([[User sharedUser].showMidLoading isEqualToString:@"点击进行刷新!"]) {
            [self loadComplaintList];
        }
        return;
    }
    TJTouSuDetailViewController * vc = [[TJTouSuDetailViewController alloc] init];
    vc.billid = self.dataArray[indexPath.row][@"billid"];
    vc.MyBlock = ^(){
        [self refreshComplant];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - buttonAction

#pragma mark - delete

#pragma mark - netWorking
- (void)loadComplaintList
{
    NSString * isyun = [NSString string];
    if ([self.dataDic count] > 0) {
        if ([self.dataDic[@"isyun"] isEqualToString:@"线上"]) {
            isyun = @"1";
        }else
            if ([self.dataDic[@"isyun"] isEqualToString:@"线下"]) {
                isyun = @"0";
            }else {
                isyun = @"";
            }
        
    }else {
        isyun = @"";
    }
    NSString * url = @"wuye/tousubill.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"cpcode"] = self.dataDic[@"cpcode"];
    params[@"houseid"] = self.dataDic[@"houseid"];
    params[@"billsta"] = self.dataDic[@"staid"];
    params[@"isyun"] = isyun;
    params[@"modid"] = self.dataDic[@"modid"];
    params[@"startdate"] = self.dataDic[@"startdate"];
    params[@"enddate"] = self.dataDic[@"enddate"];
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
- (void)loadComplainBaseData
{
    YYCache * cache = [TJCache shareCache].yyCache;
    NSData * data = (id)[cache objectForKey:@"complaintBaseData"];
    NSMutableDictionary * dic = [data toDictionary];
    if ([dic count] > 0) {
        return;
    }
    NSString * url = @"wuye/tsdata.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            if ([request[@"data"] count] > 0) {
                YYCache * cache = [TJCache shareCache].yyCache;
                [cache removeObjectForKey:@"complaintBaseData"];
                [cache setObject:[request[@"data"] data] forKey:@"complaintBaseData"];
            }else {
                
            }
        }else {
            [self loadComplainBaseData];
        }
        
    } failBlock:^(NSError *error) {
        [self loadComplainBaseData];
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
