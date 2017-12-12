//
//  TJHouseDetailViewController.m
//  baseXcode
//
//  Created by hangshao on 16/11/21.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJHouseDetailViewController.h"
#import "TJHouseDetailTableViewCell.h"
#import "TJEditeYezhuDataViewController.h"
#import "TJEditeHouseDataViewController.h"
@interface TJHouseDetailViewController ()<UITableViewDelegate,UITableViewDataSource,TJHouseDetailDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   assign) NSInteger  index;
@end

@implementation TJHouseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHeaderView];
    
    [self setTopView];
    
    [self setTableView];
    
    [self loadHouseDetail];
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
        TSLog(@"search");
    }
}
- (void)setTopView
{
    
}
- (void)setTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = BackgroundGrayColor;
    //    初始化tabelView
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeigth - 64) style:UITableViewStylePlain];
    tableView.backgroundColor = BackgroundGrayColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    WeakSelf
    wself.ts_navgationBar = [TSNavigationBar navWithTitle:@"房屋详情" backAction:^{
        [YHNetWork stopTheVcRequset:wself];
        [wself.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataDic count] == 0) {
        return 1;
    }
    return 1 + self.dataArray.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataDic count] == 0) {
        return self.tableView.height;
    }
    if (indexPath.row == 0) {
        return 572 - 18 * 11 + fifteenS.height * 11;
    }else {
        return 217 - 18 * 5 + fifteenS.height * 5;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataDic count] == 0) {
        TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
        [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 0) {
        static NSString * ID = @"TJHouseDetailTopCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TJHouseCell" owner:self options:nil] objectAtIndex:1];
        }
        for (int i = 0; i < 11; i ++) {
            UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:199 + i];
            label1.font = fifteenFont;
            label1.textColor = sevenlightColor;
        }
        for (int i = 0; i < 11; i ++) {
            UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:99 + i];
            label1.font = fifteenFont;
        }
        UILabel * address = (UILabel *)[cell.contentView viewWithTag:99];
        UILabel * status = (UILabel *)[cell.contentView viewWithTag:100];
        UILabel * chanquan = (UILabel *)[cell.contentView viewWithTag:101];
        UILabel * style = (UILabel *)[cell.contentView viewWithTag:102];
        UILabel * chaoxiang = (UILabel *)[cell.contentView viewWithTag:103];
        UILabel * huxing = (UILabel *)[cell.contentView viewWithTag:104];
        UILabel * zhuangxiu = (UILabel *)[cell.contentView viewWithTag:105];
        UILabel * jianmian = (UILabel *)[cell.contentView viewWithTag:106];
        UILabel * pay = (UILabel *)[cell.contentView viewWithTag:107];
        UILabel * jiefang = (UILabel *)[cell.contentView viewWithTag:108];
        UILabel * time = (UILabel *)[cell.contentView viewWithTag:109];
        UILabel * yezhuxinxi = (UILabel *)[cell.contentView viewWithTag:120];
        yezhuxinxi.font = fifteenFont;
        UILabel * fangwuxinxi = (UILabel *)[cell.contentView viewWithTag:600];
        fangwuxinxi.font = fifteenFont;
        address.text = [NSString stringWithFormat:@"%@－%@－%@",self.dataDic[@"cpname"],self.dataDic[@"buildname"],self.dataDic[@"housename"]];
        status.text = self.dataDic[@"housesta"];
        chanquan.text = self.dataDic[@"houseowner"];
        style.text = self.dataDic[@"unittype"];
        chaoxiang.text = self.dataDic[@"orient"];
        huxing.text = self.dataDic[@"housetype"];
        zhuangxiu.text = self.dataDic[@"zhuangxiu"];
        jianmian.text = self.dataDic[@"buildarea"];
        pay.text = self.dataDic[@"userarea"];
        jiefang.text = self.dataDic[@"acceptdate"];
        time.text = self.dataDic[@"zhuangdate"];
        
        for (int i = 0; i < 2; i ++) {
            UIButton * edite = (UIButton *)[cell.contentView viewWithTag:110 + i];
            edite.cornerRadius = 5;
            edite.backgroundColor = orangecolor;
            edite.titleFont = 15 * ScaleModel;
            [edite addTarget:self action:@selector(editeOrAddAction:)];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        TJHouseDetailTableViewCell * cell = [TJHouseDetailTableViewCell cellWithTableView:tableView];
        [cell setDataWithLabel:self.dataArray[indexPath.row - 1]];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([self.dataDic count] == 0) {
        self.dataDic = nil;
        [self.dataArray removeAllObjects];
        [self loadHouseDetail];
    }
}

#pragma mark - buttonAction
- (void)editeOrAddAction:(UIButton *)button
{
    if (button.tag == 110) {//编辑
        TJEditeHouseDataViewController * vc = [[TJEditeHouseDataViewController alloc] init];
        vc.navTitle = @"编辑物业信息";
        vc.oldDataDic = self.dataDic;
        vc.houseId = self.houseid;
        vc.refreshBlock =^(){
            self.dataDic = nil;
            [self.dataArray removeAllObjects];
            [User sharedUser].showMidLoading = @"正在刷新,请稍后...";
            [self.tableView reloadData];
            [self loadHouseDetail];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else {//添加
        TJEditeYezhuDataViewController * vc = [[TJEditeYezhuDataViewController alloc] init];
        vc.navTitle = @"业主";
        vc.houseId = self.houseid;
        vc.MyBlock = ^(NSMutableDictionary * dic){
            [self.dataArray addObject:dic];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - delete
- (void)editYeZhuxinxi:(UIButton *)button
{
    TJHouseDetailTableViewCell * cell = (TJHouseDetailTableViewCell *)[[[button superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    self.index = path.row - 1;
    
    TJEditeYezhuDataViewController * vc = [[TJEditeYezhuDataViewController alloc] init];
    vc.navTitle = @"编辑业主信息";
    vc.houseId = self.houseid;
    vc.olddataDic = self.dataArray[path.row - 1];
    vc.MyBlock = ^(NSMutableDictionary * dic){
        [self.dataArray replaceObjectAtIndex:path.row - 1 withObject:dic];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)deleteYeZhuxinxi:(UIButton *)button
{
    TJHouseDetailTableViewCell * cell = (TJHouseDetailTableViewCell *)[[[button superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    self.index = path.row - 1;
    
    [self deleteYZAction];//删除业主
}
#pragma mark - netWorking
- (void)loadHouseDetail
{
    NSString * url = @"houseinfo.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"houseid"] = self.houseid;
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"data"] count] > 0) {
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:request[@"data"]];
            if ([request[@"data"][@"ownerlist"] count] > 0) {
                [self.dataArray addObjectsFromArray:request[@"data"][@"ownerlist"]];
            }
        }else {
            [User sharedUser].showMidLoading = @"点击进行刷新!";
        }
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        [User sharedUser].showMidLoading = @"网络连接错误，请检查您的网络!";
        [self.tableView reloadData];
    }];
}
- (void)deleteYZAction
{
    NSString * url = @"house/ownerdel.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"ownerid"] = self.dataArray[self.index][@"ownerid"];
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(@"删除成功");
            [self.dataArray removeObjectAtIndex:self.index];
            [self.tableView reloadData];
        }else {
            SVShowError(@"删除失败，请重试!");
        }
    } failBlock:^(NSError *error) {
        SVShowError(@"无网络连接，请检查您的网络!");
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
