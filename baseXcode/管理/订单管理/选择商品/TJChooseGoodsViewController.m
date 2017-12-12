//
//  TJChooseGoodsViewController.m
//  baseXcode
//
//  Created by hangshao on 17/1/5.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJChooseGoodsViewController.h"

@interface TJChooseGoodsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   weak) UITableView     * tableView1;
@property (nonatomic,   weak) UITableView     * tableView2;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableArray     * rightArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   assign) NSInteger  leftIndex;
@property (nonatomic,   assign) NSInteger  midIndex;
@property (nonatomic,   assign) NSInteger  flag;
@property (nonatomic,   assign) NSInteger  leftflag;
@property (nonatomic,   assign) NSInteger  midflag;
@property (nonatomic,   assign) NSInteger   page;
@end

@implementation TJChooseGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rightArray = [NSMutableArray arrayWithCapacity:0];
    
    self.page = 1;
    
    [self setTableView];
    
    [self loadLeftList];
}
#pragma mark - setView
- (void)setTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //    初始化tabelView
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 85*ScaleModel, kScreenHeigth - 64) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tag = 900;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UITableView * tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(85*ScaleModel, 64, 85*ScaleModel, kScreenHeigth - 64) style:UITableViewStylePlain];
    tableView1.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.tag = 901;
    tableView1.hidden = YES;
    tableView1.showsVerticalScrollIndicator = NO;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView1];
    self.tableView1 = tableView1;
    UITableView * tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(85*ScaleModel * 2, 64, kScreenWidth-85*ScaleModel*2, kScreenHeigth - 64) style:UITableViewStylePlain];
    tableView2.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView2.tag = 902;
    tableView2.hidden = YES;
    tableView2.showsVerticalScrollIndicator = NO;
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView2];
    self.tableView2 = tableView2;
    tableView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreGoods)];
    WeakSelf
    wself.ts_navgationBar = [TSNavigationBar navWithTitle:@"选择商品" backAction:^{
        [YHNetWork stopTheVcRequset:wself];
        [wself.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)addMoreGoods
{
    self.page++;
    [self allGoods];
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
    if (tableView.tag == 900) {
        return self.dataArray.count;
    }else if (tableView.tag == 901) {
        if (self.leftflag == 0) {
            return 0;
        }
        return [self.dataArray[self.leftIndex][@"sublist"] count];
    } else {
        if (self.midflag == 0) {
            return 0;
        }
        if (self.rightArray.count == 0) {
            return 1;
        }
        return self.rightArray.count;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 900) {
        if (self.dataArray.count == 0) {
            return self.tableView.height;
        }
    } else if (tableView.tag == 902){
        if (self.rightArray.count == 0) {
            return self.tableView.height;
        }
        CGSize s = [self.rightArray[indexPath.row][@"billtitle"] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-24-85*ScaleModel*2];
        return 100 - 36 + fifteenS.height + s.height;
    }
    return 43 + fifteenS.height - 18;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
        [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (tableView.tag == 900) {
        static NSString * ID = @"TJCHooseGoodsCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TJChooseGoodsCell" owner:self options:nil] objectAtIndex:0];
        }
        UILabel * title = (UILabel *)[cell.contentView viewWithTag:100];
        title.font = [UIFont systemFontOfSize:13 * ScaleModel];
        title.text = self.dataArray[indexPath.row][@"modname"];
        UIView * leftV = (UIView *)[cell.contentView viewWithTag:101];
        UIView * line = (UIView *)[cell.contentView viewWithTag:102];
        line.alpha = 0.5;
        leftV.backgroundColor = [UIColor colorWithHexString:@"5dcdc9"];
        UIView * bgView = (UIView *)[cell.contentView viewWithTag:103];
        if (self.leftIndex == indexPath.row && self.leftflag == 1) {
            leftV.hidden = NO;
            title.textColor = [UIColor colorWithHexString:@"5dcdc9"];
            bgView.backgroundColor = [UIColor whiteColor];
        }else {
           leftV.hidden = YES;
            title.textColor = [UIColor colorWithHexString:@"252525"];
            bgView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (tableView.tag == 901) {
        static NSString * ID = @"TJCHooseMidGoodsCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TJChooseGoodsCell" owner:self options:nil] objectAtIndex:1];
        }
        UILabel * title = (UILabel *)[cell.contentView viewWithTag:100];
        title.font = [UIFont systemFontOfSize:13 * ScaleModel];
        title.text = self.dataArray[self.leftIndex][@"sublist"][indexPath.row][@"subname"];
        UIView * line = (UIView *)[cell.contentView viewWithTag:102];
        UIView * bgView = (UIView *)[cell.contentView viewWithTag:103];
        line.alpha = 0.5;
        UIView * leftV = (UIView *)[cell.contentView viewWithTag:101];
        leftV.backgroundColor = [UIColor colorWithHexString:@"5dcdc9"];
        if (self.midIndex == indexPath.row && self.midflag == 1) {
            leftV.hidden = NO;
            title.textColor = [UIColor colorWithHexString:@"5dcdc9"];
            bgView.backgroundColor = [UIColor whiteColor];
        }else {
            leftV.hidden = YES;
            title.textColor = [UIColor colorWithHexString:@"252525"];
            bgView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        if (self.rightArray.count == 0) {
            TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
            [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        static NSString * ID = @"TJCHooseRightGoodsCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TJChooseGoodsCell" owner:self options:nil] objectAtIndex:2];
        }
        UILabel * title = (UILabel *)[cell.contentView viewWithTag:100];
        title.font = [UIFont systemFontOfSize:15 * ScaleModel];
        title.text = self.rightArray[indexPath.row][@"billtitle"];
        UILabel * price = (UILabel *)[cell.contentView viewWithTag:101];
        price.font = [UIFont systemFontOfSize:15 * ScaleModel];
        price.textColor = [UIColor colorWithHexString:@"fb652c"];
        price.text = [NSString stringWithFormat:@"¥ %@",self.rightArray[indexPath.row][@"tuanprice"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (tableView.tag == 900) {
        if (self.dataArray.count == 0) {
            [self loadLeftList];
            return;
        }
        self.leftflag = 1;
        self.midflag = 0;
        self.leftIndex = indexPath.row;
        self.tableView1.hidden = NO;
        self.tableView2.hidden = YES;
        [self.tableView reloadData];
        [self.tableView1 reloadData];
    }else if (tableView.tag == 902) {
        if (self.rightArray.count == 0) {
            if ([[User sharedUser].showMidLoading isEqualToString:@"点击进行刷新!"]) {
                [self allGoods];
            }
            return;
        }
        if (self.cangkuJump == 2) {
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.rightArray[indexPath.row]];
            dic[@"cpcode"] = self.cpcode;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"choosegoodsOk" object:nil userInfo:dic];
            [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:NO];
            return;
        }
        if (self.MyBlock) {
            self.MyBlock(self.rightArray[indexPath.row]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        self.midflag = 1;
        self.midIndex = indexPath.row;
        self.tableView2.hidden = NO;
        self.page = 1;
        [User sharedUser].showMidLoading = @"数据加载中...";
        [self.rightArray removeAllObjects];
        [self.tableView1 reloadData];
        [self.tableView2 reloadData];
        [self allGoods];
    }
}

#pragma mark - buttonAction

#pragma mark - delete

#pragma mark - netWorking
- (void)loadLeftList
{
    NSString * url = @"psp/servlist.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"cpcode"] = self.cpcode;
    if (self.cpcode.length == 0) {
        [params removeObjectForKey:@"cpcode"];
    }
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"data"] count] > 0) {
            for (int i = 0; i < [request[@"data"] count]; i ++) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:request[@"data"][i]];
                [self.dataArray addObject:dic];
            }
            [self.tableView reloadData];
        }else {
            [User sharedUser].showMidLoading = @"点击进行刷新!";
        }
    } failBlock:^(NSError *error) {
        [User sharedUser].showMidLoading = @"无网络连接，请检查您的网络!";
        [self.tableView reloadData];
    }];
}
- (void)allGoods
{
    NSString * url = @"psp/tuanbill.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"modid"] = self.dataArray[self.leftIndex][@"sublist"][self.midIndex][@"subid"];
    params[@"searchkey"] = @"";
    params[@"cpcode"] = self.cpcode;
    params[@"curpage"] = @(self.page);
    if (self.cpcode.length == 0) {
        [params removeObjectForKey:@"cpcode"];
    }
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        [self.tableView2.mj_footer endRefreshing];
        if ([request[@"flag"] integerValue] == 0) {
            [self.rightArray addObjectsFromArray:request[@"data"]];
            if ([request[@"data"] count] == 0) {
                if (self.page == 1) {
                     [User sharedUser].showMidLoading = @"暂无相关商品!";
                }else {
                     SVShowError(@"已无更多商品!");
                }
            }
            [self.tableView1 reloadData];
            [self.tableView2 reloadData];
        }else {
            if (self.page == 1) {
                [User sharedUser].showMidLoading = @"点击进行刷新!";
            }else {
                SVShowError(@"加载出错!");
            }
            [self.tableView1 reloadData];
            [self.tableView2 reloadData];
        }
    } failBlock:^(NSError *error) {
        [self.tableView2.mj_footer endRefreshing];
        [User sharedUser].showMidLoading = @"无网络连接，请检查您的网络!";
        [self.tableView1 reloadData];
        [self.tableView2 reloadData];
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
