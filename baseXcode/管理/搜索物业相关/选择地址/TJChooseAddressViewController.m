//
//  TJChooseAddressViewController.m
//  baseXcode
//
//  Created by hangshao on 16/11/22.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJChooseAddressViewController.h"
#import "TJChooseGoodsViewController.h"
@interface TJChooseAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   weak) UITableView     * tableView1;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   assign) NSInteger   index;
@end

@implementation TJChooseAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView];
    
    [self setTableView];
    
    [self loadcityData];
}
#pragma mark - setView
- (void)setTopView
{
    UIView * topview = [[[NSBundle mainBundle] loadNibNamed:@"TJSearchCell" owner:self options:nil]objectAtIndex:1];
    topview.frame = Rect(0, 64, kScreenWidth, 47*ScaleModel + 1);
    [self.view addSubview:topview];
    for (int i = 0; i < 2; i ++) {
        UILabel * label1 = (UILabel *)[topview viewWithTag:100 + i];
        label1.font = [UIFont systemFontOfSize:16 * ScaleModel];
        label1.textColor = [UIColor colorWithHexString:@"010101"];
    }
}
- (void)setTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //    初始化tabelView
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+47*ScaleModel + 1, kScreenWidth/2, kScreenHeigth - 64-47*ScaleModel - 1) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tag = 900;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UITableView * tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth/2, 64+47*ScaleModel + 1, kScreenWidth/2, kScreenHeigth - 64-47*ScaleModel - 1) style:UITableViewStylePlain];
    tableView1.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.tag = 901;
    tableView1.hidden = YES;
    tableView1.showsVerticalScrollIndicator = NO;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView1];
    self.tableView1 = tableView1;
    WeakSelf
    wself.ts_navgationBar = [TSNavigationBar navWithTitle:@"选择地址" backAction:^{
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
    if (self.dataArray.count == 0) {
        return 1;
    }
    if (tableView.tag == 900) {
        return self.dataArray.count;
    } else {
        return [self.dataArray[self.index][@"cplist"] count];
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return 160;
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
    static NSString * ID = @"TJChooseAddressCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJSearchCell" owner:self options:nil] objectAtIndex:2];
    }
    UIButton * button = (UIButton *)[cell.contentView viewWithTag:110];
    if (tableView.tag == 900) {
        button.title = self.dataArray[indexPath.row][@"compname"];
        if ([self.dataArray[indexPath.row][@"flag"] integerValue]== 1) {
            button.backgroundColor = [UIColor colorWithHexString:@"fffbf0"];
            button.titleColor = [UIColor colorWithHexString:@"57bdb9"];
        }else {
            button.backgroundColor = [UIColor whiteColor];
            button.titleColor = [UIColor colorWithHexString:@"808080"];
        }
        [button addTarget:self action:@selector(chooseCity:)];
    } else {
        button.titleColor = [UIColor colorWithHexString:@"808080"];
        button.backgroundColor = [UIColor whiteColor];
        button.title = self.dataArray[self.index][@"cplist"][indexPath.row][@"cpname"];
        [button addTarget:self action:@selector(choosexiaoqu:)];
    }
    [button addTarget:self action:@selector(touchdown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(touchdown:) forControlEvents:UIControlEventTouchDragInside];
    [button addTarget:self action:@selector(touchoutside:) forControlEvents:UIControlEventTouchDragOutside];
    [button addTarget:self action:@selector(touchoutside:) forControlEvents:UIControlEventTouchDownRepeat];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (tableView.tag == 900) {
        if (self.dataArray.count == 0) {
            [self loadcityData];
        }
    } else {
        
    }
}

#pragma mark - buttonAction
- (void)chooseCity:(UIButton *)button
{
    UITableViewCell * cell = (UITableViewCell*)[[button superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[self.index]];
    [data removeObjectForKey:@"flag"];
    data[@"flag"] = @"0";
    [self.dataArray replaceObjectAtIndex:self.index withObject:data];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[path.row]];
    dic[@"flag"] = @"1";
    [self.dataArray replaceObjectAtIndex:path.row withObject:dic];
    self.index = path.row;
    self.tableView1.hidden = NO;
    [self.tableView reloadData];
    [self.tableView1 reloadData];
}
- (void)choosexiaoqu:(UIButton *)button
{
    UITableViewCell * cell = (UITableViewCell*)[[button superview] superview];
    NSIndexPath * path = [self.tableView1 indexPathForCell:cell];
    if (self.cankuJump == 2) {
        TJChooseGoodsViewController * vc = [[TJChooseGoodsViewController alloc] init];
        vc.cpcode = self.dataArray[self.index][@"cplist"][path.row][@"cpcode"];
        vc.cangkuJump = 2;
        [self.navigationController pushViewController:vc animated:YES];
        button.backgroundColor = [UIColor whiteColor];
        return;
    }
    if (self.MyBlock) {
        self.MyBlock(self.dataArray[self.index][@"cplist"][path.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchdown:(UIButton *)button
{
    button.backgroundColor = [UIColor colorWithHexString:@"ffb400"];
}
- (void)touchoutside:(UIButton *)button
{
    button.backgroundColor = [UIColor whiteColor];
}
#pragma mark - delete

#pragma mark - netWorking
- (void)loadcityData
{
    NSString * url = @"cplistbycomp.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
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
