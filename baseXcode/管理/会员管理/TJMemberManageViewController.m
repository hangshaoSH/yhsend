//
//  TJMemberManageViewController.m
//  baseXcode
//
//  Created by hangshao on 16/11/19.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJMemberManageViewController.h"
#import "TJMemberBaseTableViewCell.h"
#import "TJMemberDetailViewController.h"
@interface TJMemberManageViewController ()<UITableViewDelegate,UITableViewDataSource,TJMemberDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   assign) NSInteger page;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   weak) UIButton     * buttonSelect;
@property (nonatomic,   weak) UIView     * lineView;
@property (nonatomic,   assign) NSInteger  flag;
@property (nonatomic,   assign) NSInteger  index;
@end

@implementation TJMemberManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];//010101 上面四个字颜色
    
    self.index = 0;
    
    self.page = 1;
    
    self.flag = 0;
    
//    [self setHeaderView];
    
    [self setTopView];
    
    [self setTableView];
    
    [self loadMemberListData];
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
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)setTopView
{
    UIView * topView = [[[NSBundle mainBundle] loadNibNamed:@"TJMemberManagecell" owner:self options:nil] firstObject];
    topView.width = kScreenWidth;
    topView.height = 55;
    topView.origin = sixFourOrigin;
    [self.view addSubview:topView];
    
    for (int i = 0; i < 4; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        button.titleColor = [UIColor colorWithHexString:@"010101"];
        button.titleFont = 15 * ScaleModel;
        [button addTarget:self action:@selector(memberChooseStyle:)];
        if (i == 0) {
            button.titleColor = [UIColor colorWithHexString:@"57bdb9"];
            self.buttonSelect = button;
        }
    }
    
    UIView * lineView = [[UIView alloc] initWithFrame:Rect(0, 54, kScreenWidth/4, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"57bdb9"];
    [topView addSubview:lineView];
    self.lineView = lineView;
}
- (void)setTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = BackgroundGrayColor;
    //    初始化tabelView
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 55 + 10, kScreenWidth, kScreenHeigth - 64 - 55 - 10) style:UITableViewStylePlain];
    tableView.backgroundColor = BackgroundGrayColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMemberData)];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreMemberData)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    WeakSelf
    wself.ts_navgationBar = [TSNavigationBar navWithTitle:@"会员核验" backAction:^{
        [YHNetWork stopTheVcRequset:wself];
        [wself.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)refreshMemberData
{
    self.page = 1;
    [self loadMemberListData];
}
- (void)addMoreMemberData
{
    self.page ++;
    [self loadMemberListData];
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
    CGSize s = [@"相关" getStringRectWithfontSize:15 * ScaleModel width:100];
    return s.height * 3 + 56;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
        [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    TJMemberBaseTableViewCell * cell = [TJMemberBaseTableViewCell cellWithTableView:tableView];
    [cell setDataWithDic:self.dataArray[indexPath.row]];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return;
    }
    if ([self.dataArray[indexPath.row][@"checksta"] integerValue] == 0) {
        TJMemberDetailViewController * vc = [[TJMemberDetailViewController alloc] init];
        vc.reqid = self.dataArray[indexPath.row][@"reqid"];
        vc.MyBlock = ^(){
            [self refreshMemberData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - buttonAction
- (void)memberChooseStyle:(UIButton *)button
{
    [YHNetWork stopTheVcRequset:self];
    if (self.buttonSelect.tag == button.tag) {
        return;
    }
    if (button.tag == 113) {
        self.flag = -1;
    }else {
        self.flag = button.tag - 110;
    }
    self.buttonSelect.titleColor = [UIColor colorWithHexString:@"010101"];
    button.titleColor = [UIColor colorWithHexString:@"57bdb9"];
    self.buttonSelect = button;
    self.lineView.origin = CGPointMake(kScreenWidth/4 * (button.tag - 110), 54);
    [self.dataArray removeAllObjects];
    [User sharedUser].showMidLoading = @"数据加载中...";
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshMemberData];
    });
}
- (void)jiebangOrShanchu:(UIButton *)button andStr:(NSString *)title
{
    TJMemberBaseTableViewCell * cell = (TJMemberBaseTableViewCell *)[[[button superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    self.index = path.row;
    if ([title isEqualToString:@"解绑"]) {
        [self cancleBangding];
    } else {
        [self deleteRecord];
    }
}
#pragma mark - netWorking
- (void)loadMemberListData
{
    NSString * url = @"member/memcheckreq.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = [User sharedUser].userInfo[@"clerkid"];
    params[@"checksta"] = @(self.flag);
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
            [User sharedUser].showMidLoading = @"点击进行刷新！";
        }
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [User sharedUser].showMidLoading = @"网络连接错误，请检查您的网络!";
        [self.tableView reloadData];
    }];
}
- (void)cancleBangding
{
    NSString * url = @"member/cancelbind.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = [User sharedUser].userInfo[@"clerkid"];
    params[@"memberid"] = self.dataArray[self.index][@"memberid"];
    params[@"houseid"] = self.dataArray[self.index][@"bindhouseid"];
    
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            [self.dataArray removeObjectAtIndex:self.index];
            SVShowSuccess(@"已解除绑定");
            [self.tableView reloadData];
        }else {
            SVShowError(request[@"err"]);
        }
    } failBlock:^(NSError *error) {
        SVShowError(@"无网络连接，请检查您的网络");
    }];
}
- (void)deleteRecord
{
    NSString * url = @"member/bindreqdel.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = [User sharedUser].userInfo[@"clerkid"];
    params[@"reqid"] = self.dataArray[self.index][@"reqid"];
    
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            [self.dataArray removeObjectAtIndex:self.index];
            SVShowSuccess(@"已删除该条记录");
            [self.tableView reloadData];
        }else {
            SVShowError(request[@"err"]);
        }
    } failBlock:^(NSError *error) {
        SVShowError(@"无网络连接，请检查您的网络");
    }];
}
#pragma mark - 懒加载
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
