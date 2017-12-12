//
//  TJRepairManageViewController.m
//  baseXcode
//
//  Created by hangshao on 16/12/1.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJRepairManageViewController.h"
#import "TJRepairBaseTableViewCell.h"
#import "TJSearchAboutRepierViewController.h"
#import "TJAddRepaireViewController.h"
#import "TJRepaireDetailViewController.h"
#import "TJRepaireDetailElseViewController.h"
#import "TJRepaireBackViewController.h"
#import "AFHTTPSessionManager.h"
@interface TJRepairManageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   assign) NSInteger   page;
@end

@implementation TJRepairManageViewController
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
    
    [self setButton];
    
    [self loadRepairList];
    
    [self loadBaoxiuBaseData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpWithBillid1:) name:@"notRepaire" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpWithBillid2:) name:@"repaireSucc" object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notRepaire" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"repaireSucc" object:nil];
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
    label.text = @"报修单列表";
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
        vc.jumpFlag = 0;
        vc.MyBlock = ^(NSMutableDictionary * dic){
            self.dataDic = nil;
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [self.dataArray removeAllObjects];
            [User sharedUser].showMidLoading = @"数据加载中...";
            [self.tableView reloadData];
            [self refreshRepair];
        };
        vc.refreshBlock = ^(){
            [self refreshRepair];
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
    TJAddRepaireViewController * vc = [[TJAddRepaireViewController alloc] init];
    vc.MyBlock = ^(){
        [self refreshRepair];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)refreshRepair
{
    self.page = 1;
    [self loadRepairList];
}
- (void)loadMoreRepair
{
    self.page++;
    [self loadRepairList];
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
    return 67 + 5 * fifteenS.height + 8 *ScaleModel + s.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
        [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    TJRepairBaseTableViewCell * cell = [TJRepairBaseTableViewCell cellWithTableView:tableView];
    [cell setCellWithDic:self.dataArray[indexPath.row] flag:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        if ([[User sharedUser].showMidLoading isEqualToString:@"点击进行刷新!"]) {
            [self loadRepairList];
        }
        return;
    }
    NSInteger status = [self.dataArray[indexPath.row][@"sta"] integerValue];
    if (status == 0 || status == 1 || status == 2 || status == 3) {
        TJRepaireDetailViewController * vc = [[TJRepaireDetailViewController alloc] init];
        vc.billid = self.dataArray[indexPath.row][@"billid"];
        vc.jumpFlag = 0;
        vc.MyBlock = ^(){
            [self refreshRepair];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (status == 5 || status == 6) {
        TJRepaireBackViewController * vc = [[TJRepaireBackViewController alloc] init];
        vc.billid = self.dataArray[indexPath.row][@"billid"];
        vc.jumpFlag = 0;
        vc.MyBlock = ^(){
            [self refreshRepair];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (status == 9) {
        TJRepaireDetailElseViewController * vc = [[TJRepaireDetailElseViewController alloc] init];
        vc.billid = self.dataArray[indexPath.row][@"billid"];
        vc.jumpFlag = 0;
        vc.MyBlock = ^(){
            [self refreshRepair];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)jumpWithBillid1:(NSNotification *)userinfo
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:userinfo.userInfo];
    TJRepaireDetailElseViewController * vc = [[TJRepaireDetailElseViewController alloc] init];
    vc.billid = dic[@"billid"];
    vc.MyBlock = ^(){
        [self refreshRepair];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)jumpWithBillid2:(NSNotification *)userinfo
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:userinfo.userInfo];
    TJRepaireBackViewController * vc = [[TJRepaireBackViewController alloc] init];
    vc.billid = dic[@"billid"];
    vc.MyBlock = ^(){
        [self refreshRepair];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - buttonAction

#pragma mark - delete

#pragma mark - netWorking
- (void)loadRepairList
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
    NSString * url = @"wuye/mendbill.jsp";
    
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
    
//    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    [manager POST:@"http://wy.cqtianjiao.com/guanjia/sincere/wuye/mendbill.jsp" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSString * obj = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        if ([obj containsString:@"\t"]) {
//            obj = [obj stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//        }
//        if ([obj containsString:@"\n"]) {
//            obj = [obj stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        }
//        if ([obj containsString:@"\r\n"]) {
//            obj = [obj stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
//        }
//        
//        NSError * err;
//        NSData * jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];//字符串json转字典
//        
//        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                             options:NSJSONReadingMutableContainers
//                                                               error:&err];
//        if (self.page == 1) {
//            [self.dataArray removeAllObjects];
//        }
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//        if ([dic[@"flag"] integerValue] == 0) {
//            if ([dic[@"data"] count] > 0) {
//                [self.dataArray addObjectsFromArray:dic[@"data"]];
//            }else {
//                if (self.page > 1) {
//                    SVShowError(@"已无更多数据");
//                }else {
//                    [User sharedUser].showMidLoading = @"";
//                }
//            }
//        }else {
//            SVShowError(dic[@"err"]);
//        }
//        [self.tableView reloadData];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//        [User sharedUser].showMidLoading = @"无网络连接，请检查您的网络!";
//        [self.tableView reloadData];
//    }];
    
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
- (void)loadBaoxiuBaseData
{
    YYCache * cache = [TJCache shareCache].yyCache;
    NSData * data = (id)[cache objectForKey:@"baoxiuBaseData"];
    NSMutableDictionary * dic = [data toDictionary];
    if ([dic count] > 0) {
        return;
    }
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
