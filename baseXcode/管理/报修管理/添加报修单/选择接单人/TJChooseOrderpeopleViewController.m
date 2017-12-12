//
//  TJChooseOrderpeopleViewController.m
//  baseXcode
//
//  Created by hangshao on 16/12/2.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJChooseOrderpeopleViewController.h"
#import "TJMemberHeaderTableViewCell.h"
#import "TJMemberNormalTableViewCell.h"
#import "TJPersonMoreTableViewCell.h"
#import "TJDetailPersonDataViewController.h"

@interface TJChooseOrderpeopleViewController ()<UITableViewDelegate,UITableViewDataSource,TJPersonHeaderDeleagte,TJPersonMoreDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   assign) NSInteger  page;
@property (nonatomic,   strong) NSString     * showstring;
@property (nonatomic,   weak) UIView     * hideenview;
@property (nonatomic,   weak) UILabel     * name;
@property (nonatomic,   assign) NSInteger   chooseflag;
@property (nonatomic,   assign) NSInteger   section;
@property (nonatomic,   assign) NSInteger   row;
@property (nonatomic,   assign) NSInteger   elseindex;
@end

@implementation TJChooseOrderpeopleViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.showstring.length > 0) {
        [User sharedUser].showMidLoading = self.showstring;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];//house_gouxuan_normal  house_gouxuan_select
    
    self.page = 1;
    
    [self setTopView];
    
    [self setTableView];
    
    [self setHeaderView];
    
    [self loadMemberData];
}
#pragma mark - setView
- (void)setHeaderView
{
    UIView * topView = [[[NSBundle mainBundle] loadNibNamed:@"TJManageTopCell" owner:self options:nil] objectAtIndex:1];
    topView.origin = zeroOrigin;
    topView.width = kScreenWidth;
    topView.height = 64;
    topView.backgroundColor = TopBgColor;
    [self.view addSubview:topView];
    
    UILabel * label = (UILabel *)[topView viewWithTag:100];
    label.text = @"选择员工";
    label.font = seventeenFont;
    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        [button addTarget:self action:@selector(backAndSure:)];
    }
}
- (void)backAndSure:(UIButton *)button
{
    if (button.tag == 110) {
        [YHNetWork stopTheVcRequset:self];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if ([self.dataDic.allKeys containsObject:@"clerkid"]) {
            if ([self.dataDic[@"clerkid"] length] == 0) {
                SVShowError(@"请选择接单人！");
                return;
            }
            if (self.MyBlock) {
                self.MyBlock(self.dataDic);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            SVShowError(@"请选择接单人！");
        }
    }
}
- (void)setTopView
{
    UIView * topView = [[[NSBundle mainBundle] loadNibNamed:@"TJChooseMemberCell" owner:self options:nil] firstObject];
    topView.frame = Rect(0, 64, kScreenWidth, 39 + 13 * ScaleModel + fifteenS.height);
    topView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [self.view addSubview:topView];
    
    UIButton * button = (UIButton *)[topView viewWithTag:110];
    [button addTarget:self action:@selector(deletePeople)];
    
    UIView * bgview = (UIView *)[topView viewWithTag:200];
    bgview.cornerRadius = 5.0;
    bgview.borderWidth = 0.7;
    bgview.borderColor = fiveblueColor;
    UIView * hideenview = (UIView *)[topView viewWithTag:201];
    self.hideenview = hideenview;
    UILabel * label = (UILabel *)[topView viewWithTag:100];
    label.font = fifteenFont;
    
    UILabel * name = (UILabel *)[topView viewWithTag:101];
    name.textColor = fiveblueColor;
    name.font = fifteenFont;
    self.name = name;
}
- (void)setTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //    初始化tabelView
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 39 + 13 * ScaleModel + fifteenS.height, kScreenWidth, kScreenHeigth - 64 - (39 + 13 * ScaleModel + fifteenS.height)) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
//    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMorememberListData)];
}
- (void)addMorememberListData
{
    self.page ++;
    [self loadNewData];
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
        dic[@"hidden"] = @"0";
        dic[@"otherHidden"] = @"1";
        [cell setdataWithDic:dic];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        TJPersonMoreTableViewCell * cell = [TJPersonMoreTableViewCell cellWithTableView:tableView];
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.section][@"deptlist"][indexPath.row - [self.dataArray[indexPath.section][@"clerklist"] count]]];
        dic[@"hidden"] = @"0";
        dic[@"otherHidden"] = @"1";
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
    [cell setButTag:section andData:self.dataArray[section]];
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
    if (self.dataArray.count == indexPath.section) {
        self.page = 1;
        [self loadNewData];
        return;
    }
    if (self.chooseflag == 1 && (self.section == indexPath.section && self.row == indexPath.row)) {
    }else if (self.chooseflag == 0) {
    } else if (self.chooseflag == 2) {
        [self deletetwo];
    }else{
        [self deleteOne];
    }
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.dataArray[indexPath.section][@"clerklist"]];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.section][@"clerklist"][indexPath.row]];
    if ([dic.allKeys containsObject:@"select"]) {
        if ([dic[@"select"] integerValue] == 1) {
            [dic removeObjectForKey:@"select"];
            dic[@"select"] = @"0";
            self.hideenview.hidden = NO;
            [self.dataDic removeObjectForKey:@"clerkid"];
            self.dataDic[@"clerkid"] = @"";
            [self.dataDic removeObjectForKey:@"mobile"];
            self.dataDic[@"mobile"] = dic[@""];
        } else {
            [dic removeObjectForKey:@"select"];
            dic[@"select"] = @"1";
            self.name.text = dic[@"clerkname"];
            self.hideenview.hidden = YES;
            [self.dataDic removeObjectForKey:@"clerkid"];
            self.dataDic[@"clerkid"] = dic[@"clerkid"];
            [self.dataDic removeObjectForKey:@"clerkname"];
            self.dataDic[@"clerkname"] = dic[@"clerkname"];
            [self.dataDic removeObjectForKey:@"mobile"];
            self.dataDic[@"mobile"] = dic[@"mobile"];
        }
    } else {
        dic[@"select"] = @"1";
        self.name.text = dic[@"clerkname"];
        self.hideenview.hidden = YES;
        [self.dataDic removeObjectForKey:@"clerkid"];
        self.dataDic[@"clerkid"] = dic[@"clerkid"];
        [self.dataDic removeObjectForKey:@"clerkname"];
        self.dataDic[@"clerkname"] = dic[@"clerkname"];
        [self.dataDic removeObjectForKey:@"mobile"];
        self.dataDic[@"mobile"] = dic[@"mobile"];
    }
    [array replaceObjectAtIndex:indexPath.row withObject:dic];
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.section]];
    [dataDic removeObjectForKey:@"clerklist"];
    [dataDic setObject:array forKey:@"clerklist"];
    [self.dataArray replaceObjectAtIndex:indexPath.section withObject:dataDic];
    self.section = indexPath.section;
    self.row = indexPath.row;
    self.chooseflag = 1;
    [self.tableView reloadData];
}
- (void)selectCell:(NSUInteger)index WithDic:(NSMutableDictionary *)dic
{
    NSInteger section = [dic[@"tag"] integerValue]/10000;
    NSInteger elseindex = [dic[@"tag"] integerValue]%10000;
    if (self.chooseflag == 2 && (self.section == section && self.elseindex == elseindex && self.row == index)) {
    } else if (self.chooseflag == 0) {
    } else if (self.chooseflag == 1) {
        [self deleteOne];
    }else{
        [self deletetwo];
    }
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.dataArray[section][@"deptlist"][elseindex][@"clerklist"]];
    NSMutableArray * array1 = [NSMutableArray arrayWithArray:self.dataArray[section][@"deptlist"]];
    NSMutableDictionary * dic3 = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[section]];
    NSMutableDictionary * dic2 = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[section][@"deptlist"][elseindex]];
    NSMutableDictionary * dic1 = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[section][@"deptlist"][elseindex][@"clerklist"][index]];
    if ([dic1.allKeys containsObject:@"select"]) {
        if ([dic1[@"select"] integerValue] == 1) {
            [dic1 removeObjectForKey:@"select"];
            dic1[@"select"] = @"0";
            self.name.text = @"";
            self.hideenview.hidden = NO;
            [self.dataDic removeObjectForKey:@"clerkid"];
            self.dataDic[@"clerkid"] = @"";
            [self.dataDic removeObjectForKey:@"mobile"];
            self.dataDic[@"mobile"] = @"";
        } else {
            [dic1 removeObjectForKey:@"select"];
            dic1[@"select"] = @"1";
            self.name.text = dic1[@"clerkname"];
            self.hideenview.hidden = YES;
            [self.dataDic removeObjectForKey:@"clerkid"];
            self.dataDic[@"clerkid"] = dic1[@"clerkid"];
            [self.dataDic removeObjectForKey:@"clerkname"];
            self.dataDic[@"clerkname"] = dic1[@"clerkname"];
            [self.dataDic removeObjectForKey:@"mobile"];
            self.dataDic[@"mobile"] = dic1[@"mobile"];
        }
    }else {
        dic1[@"select"] = @"1";
        self.name.text = dic1[@"clerkname"];
        self.hideenview.hidden = YES;
        [self.dataDic removeObjectForKey:@"clerkid"];
        self.dataDic[@"clerkid"] = dic1[@"clerkid"];
        [self.dataDic removeObjectForKey:@"clerkname"];
        self.dataDic[@"clerkname"] = dic1[@"clerkname"];
        [self.dataDic removeObjectForKey:@"mobile"];
        self.dataDic[@"mobile"] = dic1[@"mobile"];
    }
    [array replaceObjectAtIndex:index withObject:dic1];
    [dic2 removeObjectForKey:@"deptlist"];
    [dic2 setObject:array forKey:@"clerklist"];
    [array1 replaceObjectAtIndex:elseindex withObject:dic2];
    [dic3 removeObjectForKey:@"deptlist"];
    [dic3 setObject:array1 forKey:@"deptlist"];
    [self.dataArray replaceObjectAtIndex:section withObject:dic3];
    self.section = [dic[@"tag"] integerValue]/10000;
    self.elseindex = [dic[@"tag"] integerValue]%10000;
    self.row = index;
    self.chooseflag = 2;
    [self.tableView reloadData];
}
#pragma mark - buttonAction
- (void)deletePeople
{
    self.hideenview.hidden = NO;
    if (self.chooseflag == 1) {
        [self deleteOne];
    }
    if (self.chooseflag == 2) {
        [self deletetwo];
    }
    [self.tableView reloadData];
}
- (void)deleteOne
{
    NSMutableArray * array1 = [NSMutableArray arrayWithArray:self.dataArray[self.section][@"clerklist"]];
    
    NSMutableDictionary * dic1 = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[self.section][@"clerklist"][self.row]];
    [dic1 removeObjectForKey:@"select"];
    dic1[@"select"] = @"0";
    [array1 replaceObjectAtIndex:self.row withObject:dic1];
    
    NSMutableDictionary * dataDic1 = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[self.section]];
    [dataDic1 removeObjectForKey:@"clerklist"];
    [dataDic1 setObject:array1 forKey:@"clerklist"];
    [self.dataArray replaceObjectAtIndex:self.section withObject:dataDic1];
}
- (void)deletetwo
{
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.dataArray[self.section][@"deptlist"][self.elseindex][@"clerklist"]];
    NSMutableArray * array1 = [NSMutableArray arrayWithArray:self.dataArray[self.section][@"deptlist"]];
    NSMutableDictionary * dic3 = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[self.section]];
    NSMutableDictionary * dic2 = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[self.section][@"deptlist"][self.elseindex]];
    NSMutableDictionary * dic1 = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[self.section][@"deptlist"][self.elseindex][@"clerklist"][self.row]];
    [dic1 removeObjectForKey:@"select"];
    [dic1 setObject:@"0" forKey:@"select"];
    [array replaceObjectAtIndex:self.row withObject:dic1];
    [dic2 removeObjectForKey:@"deptlist"];
    [dic2 setObject:array forKey:@"clerklist"];
    [array1 replaceObjectAtIndex:self.elseindex withObject:dic2];
    [dic3 removeObjectForKey:@"deptlist"];
    [dic3 setObject:array1 forKey:@"deptlist"];
    [self.dataArray replaceObjectAtIndex:self.section withObject:dic3];
}
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
    NSString * day1 = [[[User sharedUser] getNowTimeEnglish] substringWithRange:NSMakeRange(8, 2)];
    YYCache * cache = [TJCache shareCache].yyCache;
    NSData * data = (id)[cache objectForKey:@"peopleArray"];
    NSMutableDictionary * dataDic = [data toDictionary];
    if ([dataDic count] > 0) {
        if ([dataDic[@"day"] isEqualToString:day1]) {
            [self.dataArray addObjectsFromArray:dataDic[@"array"]];
            self.showstring = @"点击即可刷新!";
            [User sharedUser].showMidLoading = @"点击即可更新！";
            [self.tableView reloadData];
        }else {
            [self loadNewData];
        }
    }else {
        [self loadNewData];
    }
}

- (void)loadNewData
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
            //            [User sharedUser].showMidLoading = @"上拉加载更多";
            [self addMorememberListData];
        }else {
            if (self.page > 1) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                NSString * day = [[[User sharedUser] getNowTimeEnglish] substringWithRange:NSMakeRange(8, 2)];
                dic[@"day"] = day;
                [dic setObject:self.dataArray forKey:@"array"];
                YYCache * cache = [TJCache shareCache].yyCache;
                [cache removeObjectForKey:@"peopleArray"];
                [cache setObject:[dic data] forKey:@"peopleArray"];
                [User sharedUser].showMidLoading = @"点击即可刷新！";
                [self.tableView reloadData];
            }else {
                [User sharedUser].showMidLoading = @"";
                [self.tableView reloadData];
            }
        }
    } failBlock:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        self.page = 1;
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
