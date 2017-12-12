//
//  TJPersonnelManageViewController.m
//  baseXcode
//
//  Created by hangshao on 16/11/28.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJPersonnelManageViewController.h"
#import "TJMemberHeaderTableViewCell.h"
#import "TJMemberNormalTableViewCell.h"
#import "TJPersonMoreTableViewCell.h"
#import "TJDetailPersonDataViewController.h"
@interface TJPersonnelManageViewController ()<UITableViewDelegate,UITableViewDataSource,TJPersonHeaderDeleagte,TJPersonMoreDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   assign) NSInteger  page;
@property (nonatomic,   strong) NSString     * showstring;
@end

@implementation TJPersonnelManageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.showstring.length > 0) {
        [User sharedUser].showMidLoading = self.showstring;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    
    [self setTableView];
    
    [self loadMemberData];
}
#pragma mark - setView
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
    self.tableView = tableView;
//    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMorememberListData)];
    WeakSelf
    wself.ts_navgationBar = [TSNavigationBar navWithTitle:@"员工列表" backAction:^{
        [YHNetWork stopTheVcRequset:wself];
        [wself.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)addMorememberListData
{
    self.page ++;
    [self loadMemberData];
}
#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        return 1;
    }
    if (section == self.dataArray.count) {
        return 1;
    }
    if ([self.dataArray[section][@"flag"] integerValue] == 1)  {
        return [self.dataArray[section][@"clerklist"] count] + [self.dataArray[section][@"deptlist"] count];
    }
    return 0;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return self.tableView.height;
    }
    if (indexPath.section == self.dataArray.count) {
        return seventeenS.height + 20;
    }
    if ([self.dataArray[indexPath.section][@"flag"] integerValue] == 1)  {
        if (indexPath.row < [self.dataArray[indexPath.section][@"clerklist"] count]) {
            return seventeenS.height + 20;
        }
        if ([self.dataArray[indexPath.section][@"deptlist"][indexPath.row - [self.dataArray[indexPath.section][@"clerklist"] count]][@"flag"] integerValue] == 1) {
            return (1 + [self.dataArray[indexPath.section][@"deptlist"][indexPath.row - [self.dataArray[indexPath.section][@"clerklist"] count]][@"clerklist"] count]) * (seventeenS.height + 20);
        }
    }
    return seventeenS.height + 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0 || indexPath.section == self.dataArray.count) {
        TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
        [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
        self.showstring = [User sharedUser].showMidLoading;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if ([self.dataArray[indexPath.section][@"flag"] integerValue] == 0)  {
        return [UITableViewCell new];
    }
    if (indexPath.row < [self.dataArray[indexPath.section][@"clerklist"] count]) {
        TJMemberNormalTableViewCell * cell = [TJMemberNormalTableViewCell cellWithTableView:tableView];
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.section][@"clerklist"][indexPath.row]];
        dic[@"hidden"] = @"1";
        dic[@"otherHidden"] = @"0";
        [cell setdataWithDic:dic];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        TJPersonMoreTableViewCell * cell = [TJPersonMoreTableViewCell cellWithTableView:tableView];
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.section][@"deptlist"][indexPath.row - [self.dataArray[indexPath.section][@"clerklist"] count]]];
        dic[@"hidden"] = @"1";
        dic[@"otherHidden"] = @"0";
        [cell setButTag:indexPath.section * 10000 + (indexPath.row - [self.dataArray[indexPath.section][@"clerklist"] count]) andData:dic];
        cell.delegate = self;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == self.dataArray.count) {
        return 0;
    }
    return seventeenS.height + 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.dataArray.count==0) {
        return [UITableViewCell new];
    }
    if (section == self.dataArray.count) {
        return [UITableViewCell new];
    }
    TJMemberHeaderTableViewCell * cell = [TJMemberHeaderTableViewCell cellWithTableView:tableView];
    [cell setButTag:[[NSString stringWithFormat:@"%d",section] integerValue]  andData:self.dataArray[section]];
    cell.delegate = self;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        self.page = 1;
        [self loadMemberData];
        return;
    }
    TJDetailPersonDataViewController * vc = [[TJDetailPersonDataViewController alloc] init];
    vc.navTitle = self.dataArray[indexPath.section][@"clerklist"][indexPath.row][@"clerkname"];
    vc.personID = self.dataArray[indexPath.section][@"clerklist"][indexPath.row][@"clerkid"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)selectCell:(NSUInteger)index WithDic:(NSMutableDictionary *)dic
{
    //跳详情
    TJDetailPersonDataViewController * vc = [[TJDetailPersonDataViewController alloc] init];
    vc.navTitle = dic[@"clerklist"][index][@"clerkname"];
    vc.personID = dic[@"clerklist"][index][@"clerkid"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - buttonAction

#pragma mark - delete
- (void)touchWithTag:(NSInteger)tag
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[tag]];
    if ([dic[@"flag"] integerValue] == 1) {//关闭
        [dic removeObjectForKey:@"flag"];
        dic[@"flag"] = @"0";
    }else {
        [dic removeObjectForKey:@"flag"];
        dic[@"flag"] = @"1";
    }
    [self.dataArray replaceObjectAtIndex:tag withObject:dic];
    [self.tableView reloadData];
}
- (void)touchMoreCell:(NSInteger)index withDic:(NSMutableDictionary *)dic
{
    NSInteger section = index/10000;
    NSInteger row = index%10000;
    NSMutableArray * array = [NSMutableArray array];
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[section]];
    [array addObjectsFromArray:dataDic[@"deptlist"]];
    [array replaceObjectAtIndex:row withObject:dic];
    [dataDic removeObjectForKey:@"deptlist"];
    [dataDic setObject:array forKey:@"deptlist"];
    [self.dataArray replaceObjectAtIndex:section withObject:dataDic];
    [self.tableView reloadData];
}
#pragma mark - netWorking
- (void)loadMemberData
{
    NSString * url = @"hr/clerklist.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"curpage"] = @(self.page);
    
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.tableView.mj_footer endRefreshing];
        if ([request[@"data"] count] > 0) {
            for (int i = 0; i < [request[@"data"] count]; i ++) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:request[@"data"][i]];
                dic[@"flag"] = @"0";
                NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
                for (int j = 0; j < [dic[@"deptlist"] count]; j ++) {
                    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithDictionary:dic[@"deptlist"][j]];
                    dataDic[@"flag"] = @"0";
                    [array addObject:dataDic];
                }
                [dic removeObjectForKey:@"deptlist"];
                [dic setObject:array forKey:@"deptlist"];
                [self.dataArray addObject:dic];
            }
            [User sharedUser].showMidLoading = @"上拉加载更多";
            [self addMorememberListData];
        }else {
            if (self.page > 1) {
                [User sharedUser].showMidLoading = @"我是有底线的！";
                [self.tableView reloadData];
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                NSString * day = [[[User sharedUser] getNowTimeEnglish] substringWithRange:NSMakeRange(8, 2)];
                dic[@"day"] = day;
                [dic setObject:self.dataArray forKey:@"array"];
                YYCache * cache = [TJCache shareCache].yyCache;
                [cache removeObjectForKey:@"peopleArray"];
                [cache setObject:[dic data] forKey:@"peopleArray"];
            }else {
                [User sharedUser].showMidLoading = @"";
                [self.tableView reloadData];
            }
        }
    } failBlock:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.dataArray removeAllObjects];
        [User sharedUser].showMidLoading = @"网络连接错误，请检查您的网络或点击刷新!";
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
