//
//  TJKeepManagerViewController.m
//  baseXcode
//
//  Created by hangshao on 17/1/3.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJKeepManagerViewController.h"
#import "TJKeepBaseTableViewCell.h"
#import "TJPubMessageDetailViewController.h"
#import "TJKeepSearchViewController.h"
#import "TJAddKeepDataViewController.h"
@interface TJKeepManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   assign) NSInteger   page;
@property (nonatomic,   weak) UIButton     * buttonSelect;
@property (nonatomic,   weak) UIView     * lineView;
@property (nonatomic,   assign) NSInteger  flag;
@property (nonatomic,   assign) NSInteger  index;
@end

@implementation TJKeepManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.page = 1;
    
    [self setTopView];
    
    [self setHeaderView];
    
    [self setTableView];
    
    [self setButton];
    
    [self loadKeepData];
}

#pragma mark - setview
- (void)setHeaderView
{
    UIView * topView = [[[NSBundle mainBundle] loadNibNamed:@"TJManageTopCell" owner:self options:nil] objectAtIndex:0];
    topView.origin = zeroOrigin;
    topView.width = kScreenWidth;
    topView.height = 64;
    topView.backgroundColor = TopBgColor;
    [self.view addSubview:topView];
    
    UILabel * label = (UILabel *)[topView viewWithTag:100];
    label.font = seventeenFont;
    label.text = @"信息发布";

    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        [button addTarget:self action:@selector(backAndSearchKeep:)];
    }
}
- (void)backAndSearchKeep:(UIButton *)button
{
    if (button.tag == 110) {
        [YHNetWork stopTheVcRequset:self];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        TJKeepSearchViewController * vc = [[TJKeepSearchViewController alloc] init];
        vc.myBlock = ^(NSMutableDictionary * dic){
            [self.dataDic removeObjectForKey:@"enddate"];
            [self.dataDic removeObjectForKey:@"startdate"];
            [self.dataDic removeObjectForKey:@"searchkeys"];
            [self.dataDic removeObjectForKey:@"cpcode"];
            self.dataDic[@"enddate"] = dic[@"enddate"];
            self.dataDic[@"startdate"] = dic[@"startdate"];
            self.dataDic[@"searchkeys"] = dic[@"searchkeys"];
            self.dataDic[@"cpcode"] = dic[@"cpcode"];
            [self.dataArray removeAllObjects];
            [User sharedUser].showMidLoading = @"数据加载中...";
            [self.tableView reloadData];
            [self refreshKeepData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self.tableView reloadData];
}
- (void)setTopView
{
    UIView * topView = [[[NSBundle mainBundle] loadNibNamed:@"TJKeepBaseCell" owner:self options:nil] objectAtIndex:1];
    topView.width = kScreenWidth;
    topView.height = 55;
    topView.origin = sixFourOrigin;
    [self.view addSubview:topView];
    
    for (int i = 0; i < 3; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        button.titleColor = [UIColor colorWithHexString:@"010101"];
        button.titleFont = 15 * ScaleModel;
        [button addTarget:self action:@selector(keepChooseStyle:)];
        if (i == 0) {
            button.titleColor = [UIColor colorWithHexString:@"57bdb9"];
            self.buttonSelect = button;
        }
    }
    
    UIView * lineView = [[UIView alloc] initWithFrame:Rect(0, 54, kScreenWidth/3, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"57bdb9"];
    [topView addSubview:lineView];
    self.lineView = lineView;
}
- (void)setButton
{
    UIButton * button = [[UIButton alloc] initWithFrame:Rect(0, 0, 54*ScaleModel, 54*ScaleModel)];
    button.origin = CGPointMake(kScreenWidth - 44 - 54*ScaleModel, kScreenHeigth - 58 - 54*ScaleModel);
    [button setImage:[UIImage imageNamed:@"house_add_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"house_add_select"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(addMessageAction)];
    [self.view addSubview:button];
}
- (void)addMessageAction
{
    TJAddKeepDataViewController * vc = [[TJAddKeepDataViewController alloc] init];
    vc.refreshBlock = ^(NSInteger flag){
        [self.dataArray removeAllObjects];
        [User sharedUser].showMidLoading = @"数据加载中...";
        [self.tableView reloadData];
        [self refreshKeepData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setTableView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    初始化tabelView
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+55+12*ScaleModel, kScreenWidth, kScreenHeigth - 64-55-12*ScaleModel) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshKeepData)];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreKeepData)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
- (void)refreshKeepData
{
    self.page = 1;
    [self loadKeepData];
}
- (void)addMoreKeepData
{
    self.page++;
    [self loadKeepData];
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
    NSInteger height = 0;
    if ([self.dataArray[indexPath.row][@"newsspec"] length] == 0) {
        height = 18*ScaleModel;
    }else {
        CGSize s = [self.dataArray[indexPath.row][@"newsspec"] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth - 90];
        height = s.height;
    }
    return 50 + 3 * fifteenS.height + height + 8 * ScaleModel;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
        [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    TJKeepBaseTableViewCell * cell = [TJKeepBaseTableViewCell cellWithTableView:tableView];
    [cell setDataWithDic:self.dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        if ([[User sharedUser].showMidLoading isEqualToString:@"点击进行刷新!"]) {
            [User sharedUser].showMidLoading = @"数据加载中...";
            [self.tableView reloadData];
            [self loadKeepData];
        }
        return;
    }
    TJPubMessageDetailViewController * vc = [[TJPubMessageDetailViewController alloc] init];
    vc.navTitle = self.dataArray[indexPath.row][@"newstitle"];
    vc.urlStr = self.dataArray[indexPath.row][@"newsurl"];
    vc.newsid = self.dataArray[indexPath.row][@"newsid"];
    vc.refreshBlock = ^(){
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - buttonAction
- (void)keepChooseStyle:(UIButton *)button
{
    [YHNetWork stopTheVcRequset:self];
    if (self.buttonSelect.tag == button.tag) {
        return;
    }
    self.flag = button.tag - 110;
    self.buttonSelect.titleColor = [UIColor colorWithHexString:@"010101"];
    button.titleColor = [UIColor colorWithHexString:@"57bdb9"];
    self.buttonSelect = button;
    self.lineView.origin = CGPointMake(kScreenWidth/3 * (button.tag - 110), 54);
    [self.dataArray removeAllObjects];
    [User sharedUser].showMidLoading = @"数据加载中...";
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshKeepData];
    });
}
#pragma mark - delete

#pragma mark - netWorking
- (void)loadKeepData
{
    NSString * url = @"wuye/newslist.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = [User sharedUser].userInfo[@"clerkid"];
    params[@"newstype"] = @(self.flag);
    params[@"searchkeys"] = self.dataDic[@"searchkeys"];
    params[@"cpcode"] = self.dataDic[@"cpcode"];
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
        self.dataDic[@"enddate"] = @"";
        self.dataDic[@"startdate"] = @"";
        self.dataDic[@"searchkeys"] = @"";
        self.dataDic[@"cpcode"] = @"";
    }
    return _dataDic;
}
@end
