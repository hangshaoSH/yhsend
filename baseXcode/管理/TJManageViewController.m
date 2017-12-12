//
//  TJManageViewController.m
//  baseXcode
//
//  Created by hangshao on 16/11/15.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJManageViewController.h"
#import "TJHomeTopView.h"
#import "TJHouseListViewController.h"
#import "TJMemberManageViewController.h"
#import "TJManagerTopTableViewCell.h"
#import "TJManagerNormalTableViewCell.h"
#import "TJPersonnelManageViewController.h"
#import "TJHomeNetViewController.h"
#import "TJRepairManageViewController.h"
#import "TJComplaintManageViewController.h"
#import "TJRepairComplaintViewController.h"
#import "TJComplaintAcceptViewController.h"
#import "TJProjectGetOrderViewController.h"
#import "TJQuicklyPostThingViewController.h"
#import "TJKeepManagerViewController.h"
#import "TJManagerOrderViewController.h"
#import "TJReserveManagerViewController.h"
#import "FaceViewController.h"
#import "GatherRecordViewController.h"
@interface TJManageViewController ()<UITableViewDelegate,UITableViewDataSource,TJManagerTopDelegate,TJManagerNormalDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   strong) NSMutableArray     * topLabelArray;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableArray     * dataArray1;
@property (nonatomic,   strong) NSMutableArray     * dataArray2;
@property (nonatomic,   strong) NSMutableArray     * dataArray3;
@property (nonatomic,   strong) NSMutableArray     * dataArray4;
@property (nonatomic,   strong) NSMutableArray     * dataArray5;
@property (nonatomic,   strong) NSMutableArray     * allArray;
@property (nonatomic,   assign) NSInteger   firstIndex;
@property (nonatomic,   strong) NSMutableDictionary     * dic;
@property (nonatomic,   strong) NSMutableArray     * cellHeightArray;
@property (nonatomic,   assign) NSInteger  flag;
@property (nonatomic,   assign) NSInteger   refreshFlag;
@property (nonatomic,   strong) NSString   * showstring;
@end

@implementation TJManageViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadmanagerBaseData];
    [User sharedUser].refreshFlag = 2;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [User sharedUser].refreshFlag = 0;
}
- (void)setBasedate
{
    NSMutableArray * dataArray = [NSMutableArray arrayWithCapacity:0];
    if (self.allArray.count > 0) {
        for (NSMutableArray * array in self.allArray) {
            for (int i = 0; i < array.count; i ++) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:array[i]];
                [dic removeObjectForKey:@"count"];
                [dic setObject:@"0" forKey:@"count"];
                [array replaceObjectAtIndex:i withObject:dic];
            }
            [dataArray addObject:array];
        }
        [self.allArray removeAllObjects];
        [self.allArray addObjectsFromArray:dataArray];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showstring = [NSString string];
    self.showstring = @"数据加载中...";
    self.dic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.cellHeightArray = [NSMutableArray arrayWithCapacity:0];
    self.allArray = [NSMutableArray arrayWithCapacity:0];
    [self.allArray addObject:self.dataArray5];
    [self.allArray addObject:self.dataArray];
    [self.allArray addObject:self.dataArray2];
    [self.allArray addObject:self.dataArray1];
    [self.allArray addObject:self.dataArray4];
    [self.allArray addObject:self.dataArray3];
    [self setTopView];
    [self setTableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshmanagerdata) name:@"refreshmanager" object:nil];
}
- (void)refreshmanagerdata
{
    [self loadmanagerBaseData];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshmanager" object:nil];
}
- (void)setTopView
{
    TJHomeTopView * topview = [[[NSBundle mainBundle] loadNibNamed:@"TJHomeMainXib" owner:self options:nil] firstObject];
    topview.origin = CGPointMake(0, 0);
    topview.width = kScreenWidth;
    topview.height = 64;
    topview.nowDayShow.hidden = YES;
    topview.rightBut.hidden = YES;
    topview.xingqi.text = @"小A管家";
    topview.backgroundColor = [UIColor colorWithHexString:@"c9383a"];
    [self.view addSubview:topview];
}
- (void)setTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    初始化tabelView
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeigth - 64 - 49) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return self.allArray.count + 1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 36 + 40 * ScaleModel;
    }else {
        NSInteger i = [self.allArray[indexPath.row - 1] count]/3;
        int j = [self.allArray[indexPath.row - 1] count]%3;
        if (j > 0) {
            i = i + 1;
        } else {
            
        }
        return (46 + seventeenS.height - 20) + 122 * i;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        TJManagerTopTableViewCell * cell = [TJManagerTopTableViewCell cellWithTableView:tableView];
        [cell setDataWithString:self.showstring];
        [cell setDelegate:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        TJManagerNormalTableViewCell * cell = [TJManagerNormalTableViewCell cellWithTableView:tableView];
        [cell setCollectionviewWithData:self.allArray[indexPath.row - 1] andTopLabel:self.topLabelArray[indexPath.row - 1]];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return;
}

#pragma mark - networking
- (void)loadmanagerBaseData
{
    NSString * url = @"alertinfo.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            [self setBasedate];
            if (self.refreshFlag == 1) {
                self.refreshFlag = 0;
                SVShowSuccess(@"已刷新!");
            }
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:request];
            self.showstring = [NSString stringWithFormat:@"当前共有%ld条待办事项",[self.dataDic[@"infonum"] integerValue]];
            for (int i = 0; i < [request[@"data"] count]; i ++) {
                NSInteger type = [request[@"data"][i][@"typeid"] integerValue];
                switch (type) {
                    case 1:
                    { NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray1[1]];
                        [dic removeObjectForKey:@"count"];
                        [dic setObject:request[@"data"][i][@"itemnum"] forKey:@"count"];
                        [self.dataArray1 replaceObjectAtIndex:1 withObject:dic];
                    }
                        break;
                    case 2:
                    { NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray1[3]];
                        [dic removeObjectForKey:@"count"];
                        [dic setObject:request[@"data"][i][@"itemnum"] forKey:@"count"];
                        [self.dataArray1 replaceObjectAtIndex:3 withObject:dic];
                    }
                        break;
                    case 3:
                    { NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray1[0]];
                        [dic removeObjectForKey:@"count"];
                        [dic setObject:request[@"data"][i][@"itemnum"] forKey:@"count"];
                        [self.dataArray1 replaceObjectAtIndex:0 withObject:dic];
                    }
                        break;
                    case 4:
                    { NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray4[0]];
                        [dic removeObjectForKey:@"count"];
                        [dic setObject:request[@"data"][i][@"itemnum"] forKey:@"count"];
                        [self.dataArray4 replaceObjectAtIndex:0 withObject:dic];
                    }
                        break;
                    case 5:
                    { NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray4[1]];
                        [dic removeObjectForKey:@"count"];
                        [dic setObject:request[@"data"][i][@"itemnum"] forKey:@"count"];
                        [self.dataArray4 replaceObjectAtIndex:1 withObject:dic];
                    }
                        break;
                    case 6:
                    {
                    }
                        break;
                    case 7:
                    {
                    }
                        break;
                    case 8:
                    {
                    }
                        break;
                    case 9:
                    {
                    }
                        break;
                    case 10:
                    {
                    }
                        break;
                    default:
                        break;
                }
            }
            [self.allArray removeAllObjects];
            [self.allArray addObject:self.dataArray5];
            [self.allArray addObject:self.dataArray];
            [self.allArray addObject:self.dataArray2];
            [self.allArray addObject:self.dataArray1];
            [self.allArray addObject:self.dataArray4];
            [self.allArray addObject:self.dataArray3];
        }else {
            self.showstring = @"请点击刷新按钮->";
            SVShowError(request[@"err"]);
        }
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        [self setBasedate];
        self.showstring = @"请点击刷新按钮->";
        SVShowError(@"数据加载失败，请刷新界面");
        [self.tableView reloadData];
    }];
}

#pragma mark - delegate
- (void)refreshAc
{
    self.refreshFlag = 1;
    [self loadmanagerBaseData];
}

- (void)collectionSelect:(NSInteger)index andCollectionview:(UICollectionView *)collectionview
{
    TJManagerNormalTableViewCell * cell = (TJManagerNormalTableViewCell *)[[[[collectionview superview] superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    if (path.row == 1) {
        if (index == 0) {//快速报事
            TJQuicklyPostThingViewController * vc = [[TJQuicklyPostThingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (index == 1) {//当面付款
            FaceViewController * vc = [[FaceViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (index == 2) {//收款记录
            GatherRecordViewController * vc = [[GatherRecordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (index == 3) {//NCF制卡
            
        }
    }
    if (path.row == 2) {
        if (index == 0) {//员工
            TJPersonnelManageViewController * vc = [[TJPersonnelManageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (index == 1) {//房屋
            TJHouseListViewController * vc = [[TJHouseListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (index == 2) {//信息发布
            TJKeepManagerViewController * vc = [[TJKeepManagerViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (path.row == 3) {
        if (index == 0) {//会议管理
            
        }
        if (index == 1) {//任务管理
            
        }
        if (index == 2) {//其他管理
            
        }
    }
    if (path.row == 4) {
        if (index == 0) {//会员
            TJMemberManageViewController * vc = [[TJMemberManageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (index == 1) {//报修受理
            TJRepairComplaintViewController * vc = [[TJRepairComplaintViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (index == 2) {//保修管理
            TJRepairManageViewController * vc = [[TJRepairManageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (index == 3) {//投诉受理
            TJComplaintAcceptViewController * vc = [[TJComplaintAcceptViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (index == 4) {//投诉管理
            TJComplaintManageViewController * vc = [[TJComplaintManageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (index == 5) {//其他管理
            
        }
    }
    if (path.row == 5) {
        if (index == 0) {//工程抢单
            TJProjectGetOrderViewController * vc = [[TJProjectGetOrderViewController alloc] init];
            vc.jumpFlag = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (index == 1) {//工程维修
            TJProjectGetOrderViewController * vc = [[TJProjectGetOrderViewController alloc] init];
            vc.jumpFlag = 2;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (index == 2) {//工程其他
            
        }
    }
    if (path.row == 6) {
        if (index == 0) {//洗衣管理
            TJHomeNetViewController * vc = [[TJHomeNetViewController alloc] init];
            vc.urlStr = @"http://app.cqtianjiao.com/web/psp/washorder.jsp?";
            vc.navTitle = @"洗衣管理";
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (index == 1) {//订单管理
            TJManagerOrderViewController * vc = [[TJManagerOrderViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (index == 2) {//库存管理
            TJReserveManagerViewController * vc = [[TJReserveManagerViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark - 懒加载
- (NSMutableArray *)topLabelArray
{
    if (!_topLabelArray) {
        _topLabelArray = [NSMutableArray arrayWithCapacity:0];
        [_topLabelArray addObject:@"常用功能"];
        [_topLabelArray addObject:@"基础数据管理"];
        [_topLabelArray addObject:@"计划管理"];
        [_topLabelArray addObject:@"客服管理"];
        [_topLabelArray addObject:@"工程管理"];
        [_topLabelArray addObject:@"经营管理"];
    }
    return _topLabelArray;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"select"] = @"manager_yuangongguanli_select";
        dic[@"normal"] = @"manager_yuangongguanli_normal";
        dic[@"title"] = @"员工管理";
        dic[@"use"] = @"1";
        dic[@"noselect"] = @"manager_yuangongguanli_noselect";
        dic[@"count"] = @"0";
        NSMutableDictionary * dic1 = [NSMutableDictionary dictionary];
        dic1[@"select"] = @"manager_house_select";
        dic1[@"normal"] = @"manager_house_normal";
        dic1[@"title"] = @"房屋管理";
        dic1[@"use"] = @"1";
        dic1[@"noselect"] = @"manager_house_noselect";
        dic1[@"count"] = @"0";
        NSMutableDictionary * dic2 = [NSMutableDictionary dictionary];
        dic2[@"select"] = @"manager_message_select";
        dic2[@"normal"] = @"manager_message_normal";
        dic2[@"title"] = @"信息发布";
        dic2[@"use"] = @"1";
        dic2[@"noselect"] = @"manager_message_noselect";
        dic2[@"count"] = @"0";
        [self.dataArray addObject:dic];
        [self.dataArray addObject:dic1];
        [self.dataArray addObject:dic2];
    }
    return _dataArray;
}
- (NSMutableArray *)dataArray1
{
    if (!_dataArray1) {
        _dataArray1 = [NSMutableArray arrayWithCapacity:0];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"select"] = @"manager_huiyuan_select";
        dic[@"normal"] = @"manager_huiyuan_normal";
        dic[@"title"] = @"会员管理";
        dic[@"use"] = @"1";
        dic[@"noselect"] = @"manager_huiyuan_noselect";
        dic[@"count"] = @"0";
        NSMutableDictionary * dic1 = [NSMutableDictionary dictionary];
        dic1[@"select"] = @"manager_baoxiushouli_select";
        dic1[@"normal"] = @"manager_baoxiushouli_normal";
        dic1[@"title"] = @"报修受理";
        dic1[@"use"] = @"1";
        dic1[@"noselect"] = @"manager_baoxiushouli_selectno";
        dic1[@"count"] = @"0";
        NSMutableDictionary * dic2 = [NSMutableDictionary dictionary];
        dic2[@"select"] = @"manager_baoxiuguanli_select";
        dic2[@"normal"] = @"manager_baoxiuguanli_normal";
        dic2[@"title"] = @"报修管理";
        dic2[@"use"] = @"1";
        dic2[@"noselect"] = @"manager_baoxiuguanli_selectno";
        dic2[@"count"] = @"0";
        NSMutableDictionary * dic3 = [NSMutableDictionary dictionary];
        dic3[@"select"] = @"manager_tousushouli_select";
        dic3[@"normal"] = @"manager_tousushouli_normal";
        dic3[@"title"] = @"投诉受理";
        dic3[@"use"] = @"1";
        dic3[@"noselect"] = @"manager_tousushouli_noselect";
        dic3[@"count"] = @"0";
        NSMutableDictionary * dic4 = [NSMutableDictionary dictionary];
        dic4[@"select"] = @"manager_tousu_select";
        dic4[@"normal"] = @"manager_tousu_normalt";
        dic4[@"title"] = @"投诉管理";
        dic4[@"use"] = @"1";
        dic4[@"noselect"] = @"manager_tousuguanli_noselect";
        dic4[@"count"] = @"0";
        NSMutableDictionary * dic5 = [NSMutableDictionary dictionary];
        dic5[@"select"] = @"manager_more_select";
        dic5[@"normal"] = @"manager_more_normal";
        dic5[@"title"] = @"其他管理";
        dic5[@"use"] = @"0";
        dic5[@"noselect"] = @"manager_more_noselect";
        dic5[@"count"] = @"0";
        [self.dataArray1 addObject:dic];
        [self.dataArray1 addObject:dic1];
        [self.dataArray1 addObject:dic2];
        [self.dataArray1 addObject:dic3];
        [self.dataArray1 addObject:dic4];
        [self.dataArray1 addObject:dic5];
    }
    return _dataArray1;
}
- (NSMutableArray *)dataArray2
{
    if (!_dataArray2) {
        _dataArray2 = [NSMutableArray arrayWithCapacity:0];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"select"] = @"manager_huiyi_select";
        dic[@"normal"] = @"manager_huiyi_normal";
        dic[@"title"] = @"会议管理";
        dic[@"use"] = @"0";
        dic[@"noselect"] = @"manager_huiyi_noseect";
        dic[@"count"] = @"0";
        NSMutableDictionary * dic1 = [NSMutableDictionary dictionary];
        dic1[@"select"] = @"manager_acticity_select";
        dic1[@"normal"] = @"manager_activity_normal";
        dic1[@"title"] = @"任务管理";
        dic1[@"use"] = @"0";
        dic1[@"noselect"] = @"manager_activity_noselect";
        dic1[@"count"] = @"0";
        NSMutableDictionary * dic2 = [NSMutableDictionary dictionary];
        dic2[@"select"] = @"manager_more_select";
        dic2[@"normal"] = @"manager_more_normal";
        dic2[@"title"] = @"其他管理";
        dic2[@"use"] = @"0";
        dic2[@"noselect"] = @"manager_more_noselect";
        dic2[@"count"] = @"0";
        [self.dataArray2 addObject:dic];
        [self.dataArray2 addObject:dic1];
        [self.dataArray2 addObject:dic2];
    }
    return _dataArray2;
}
- (NSMutableArray *)dataArray3
{
    if (!_dataArray3) {
        _dataArray3 = [NSMutableArray arrayWithCapacity:0];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"select"] = @"manager_xiyi_select";
        dic[@"normal"] = @"manager_xiyi_normal";
        dic[@"title"] = @"洗衣管理";
        dic[@"use"] = @"1";
        dic[@"noselect"] = @"manager_xiyi_noselect";
        dic[@"count"] = @"0";
        NSMutableDictionary * dic1 = [NSMutableDictionary dictionary];
        dic1[@"select"] = @"manager_order_select";
        dic1[@"normal"] = @"manager_order_normal";
        dic1[@"title"] = @"订单管理";
        dic1[@"use"] = @"1";
        dic1[@"noselect"] = @"manager_order_noselect";
        dic1[@"count"] = @"0";
        NSMutableDictionary * dic2 = [NSMutableDictionary dictionary];
        dic2[@"select"] = @"manager_zushou_select";
        dic2[@"normal"] = @"manager_zushou_normal";
        dic2[@"title"] = @"库存管理";
        dic2[@"use"] = @"1";
        dic2[@"noselect"] = @"manager_zushou_noselect";
        dic2[@"count"] = @"0";
        [self.dataArray3 addObject:dic];
        [self.dataArray3 addObject:dic1];
        [self.dataArray3 addObject:dic2];
    }
    return _dataArray3;
}
- (NSMutableArray *)dataArray4
{
    if (!_dataArray4) {
        _dataArray4 = [NSMutableArray arrayWithCapacity:0];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"select"] = @"manager_gongchengqiangdan_select";
        dic[@"normal"] = @"manager_gongchengqiangdan_normal";
        dic[@"title"] = @"工程抢单";
        dic[@"use"] = @"1";
        dic[@"noselect"] = @"manager_gongchengqiangdan_noselect";
        dic[@"count"] = @"0";
        NSMutableDictionary * dic1 = [NSMutableDictionary dictionary];
        dic1[@"select"] = @"manager_gongchengweixiu_select";
        dic1[@"normal"] = @"manager_gongchengweixiu_normal";
        dic1[@"title"] = @"工程维修";
        dic1[@"use"] = @"1";
        dic1[@"noselect"] = @"manager_gongchengweixiu_noselect";
        dic1[@"count"] = @"0";
        NSMutableDictionary * dic2 = [NSMutableDictionary dictionary];
        dic2[@"select"] = @"manager_more_select";
        dic2[@"normal"] = @"manager_more_normal";
        dic2[@"title"] = @"工程其他";
        dic2[@"use"] = @"0";
        dic2[@"noselect"] = @"manager_more_noselect";
        dic2[@"count"] = @"0";
        [self.dataArray4 addObject:dic];
        [self.dataArray4 addObject:dic1];
        [self.dataArray4 addObject:dic2];
    }
    return _dataArray4;
}
- (NSMutableArray *)dataArray5
{
    if (!_dataArray5) {
        _dataArray5 = [NSMutableArray arrayWithCapacity:0];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"select"] = @"manager_quickbaoshi_select";
        dic[@"normal"] = @"manager_quickbaoshi_normal";
        dic[@"title"] = @"快速报事";
        dic[@"use"] = @"1";
        dic[@"noselect"] = @"manager_quickbaoshi_noselect";
        dic[@"count"] = @"0";
        NSMutableDictionary * dic1 = [NSMutableDictionary dictionary];
        dic1[@"select"] = @"manager_xunluo_select";
        dic1[@"normal"] = @"manager_xunluo_normal";
        dic1[@"title"] = @"当面收款";
        dic1[@"use"] = @"1";
        dic1[@"noselect"] = @"manager_xunluo_noselect";
        dic1[@"count"] = @"0";
        NSMutableDictionary * dic2 = [NSMutableDictionary dictionary];
        dic2[@"select"] = @"manager_xunluo_select";
        dic2[@"normal"] = @"manager_xunluo_normal";
        dic2[@"title"] = @"收款记录";
        dic2[@"use"] = @"1";
        dic2[@"noselect"] = @"manager_xunluo_noselect";
        dic2[@"count"] = @"0";
        NSMutableDictionary * dic3 = [NSMutableDictionary dictionary];
        dic3[@"select"] = @"manager_NFC_select";
        dic3[@"normal"] = @"manager_NFC_normal";
        dic3[@"title"] = @"NFC制卡";
        dic3[@"use"] = @"0";
        dic3[@"noselect"] = @"manager_NFC_noselect";
        dic3[@"count"] = @"0";
        [self.dataArray5 addObject:dic];
        [self.dataArray5 addObject:dic1];
        [self.dataArray5 addObject:dic2];
        [self.dataArray5 addObject:dic3];
    }
    return _dataArray5;
}
- (NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
@end
