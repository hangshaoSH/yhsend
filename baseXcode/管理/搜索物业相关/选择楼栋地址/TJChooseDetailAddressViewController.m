//
//  TJChooseDetailAddressViewController.m
//  baseXcode
//
//  Created by hangshao on 16/11/23.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJChooseDetailAddressViewController.h"

@interface TJChooseDetailAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   weak) UITableView     * tableView1;
@property (nonatomic,   weak) UITableView     * tableView2;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableArray     * rightArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   assign) NSInteger  leftIndex;
@property (nonatomic,   assign) NSInteger  midIndex;
@property (nonatomic,   assign) NSInteger  flag;
@end

@implementation TJChooseDetailAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView];
    
    [self setTableView];
    
    [self loadDetailAddress];
}
#pragma mark - setView
- (void)setTopView
{
    UIView * topview = [[[NSBundle mainBundle] loadNibNamed:@"TJSearchCell" owner:self options:nil]objectAtIndex:4];
    topview.frame = Rect(0, 64, kScreenWidth, 47*ScaleModel + 1);
    [self.view addSubview:topview];
    for (int i = 0; i < 3; i ++) {
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
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+47*ScaleModel + 1, kScreenWidth/3, kScreenHeigth - 64-47*ScaleModel - 1) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tag = 900;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UITableView * tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth/3, 64+47*ScaleModel + 1, kScreenWidth/3, kScreenHeigth - 64-47*ScaleModel - 1) style:UITableViewStylePlain];
    tableView1.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.tag = 901;
    tableView1.hidden = YES;
    tableView1.showsVerticalScrollIndicator = NO;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView1];
    self.tableView1 = tableView1;
    UITableView * tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth/3 * 2, 64+47*ScaleModel + 1, kScreenWidth/3, kScreenHeigth - 64-47*ScaleModel - 1) style:UITableViewStylePlain];
    tableView2.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView2.tag = 902;
    tableView2.hidden = YES;
    tableView2.showsVerticalScrollIndicator = NO;
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView2];
    self.tableView2 = tableView2;
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
    }else if (tableView.tag == 901) {
         return [self.dataArray[self.leftIndex][@"cplist"] count];
    } else {
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
            return 160;
        }
    } else if (tableView.tag == 902){
        if (self.rightArray.count == 0) {
            return 160;
        }
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
    }else if (tableView.tag == 901) {
        button.titleColor = [UIColor colorWithHexString:@"808080"];
        button.backgroundColor = [UIColor whiteColor];
        button.title = self.dataArray[self.leftIndex][@"cplist"][indexPath.row][@"cpname"];
        if (self.midIndex == indexPath.row && self.flag == 1) {
            button.backgroundColor = [UIColor colorWithHexString:@"fffbf0"];
            button.titleColor = [UIColor colorWithHexString:@"57bdb9"];
        }else {
            button.backgroundColor = [UIColor whiteColor];
            button.titleColor = [UIColor colorWithHexString:@"808080"];
        }
        [button addTarget:self action:@selector(chooseXiaoqu:)];
    } else {
        if (self.rightArray.count == 0) {
            TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
            [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        button.titleColor = [UIColor colorWithHexString:@"808080"];
        button.backgroundColor = [UIColor whiteColor];
        button.title = self.rightArray[indexPath.row][@"buildname"];
        [button addTarget:self action:@selector(chooseloudong:)];
    }
    [button addTarget:self action:@selector(touchDetaildown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(touchDetaildown:) forControlEvents:UIControlEventTouchDragInside];
    [button addTarget:self action:@selector(touchDetailoutside:) forControlEvents:UIControlEventTouchDragOutside];
    [button addTarget:self action:@selector(touchDetailoutside:) forControlEvents:UIControlEventTouchDownRepeat];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (tableView.tag == 900) {
        if (self.dataArray.count == 0) {
            [self loadDetailAddress];
        }
    }else if (tableView.tag == 902) {
        if (self.rightArray.count == 0) {
            [self loadLoudongdata];
        }
    } else {
        
    }
}

#pragma mark - buttonAction
- (void)chooseCity:(UIButton *)button
{
    self.flag = 0;
    self.tableView2.hidden = YES;
    UITableViewCell * cell = (UITableViewCell*)[[button superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[self.leftIndex]];
    [data removeObjectForKey:@"flag"];
    data[@"flag"] = @"0";
    [self.dataArray replaceObjectAtIndex:self.leftIndex withObject:data];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[path.row]];
    dic[@"flag"] = @"1";
    [self.dataArray replaceObjectAtIndex:path.row withObject:dic];
    self.leftIndex = path.row;
    self.tableView1.hidden = NO;
    [self.tableView reloadData];
    [self.tableView1 reloadData];
}
- (void)chooseXiaoqu:(UIButton *)button
{
    [User sharedUser].showMidLoading = @"数据加载中...";
    [self.rightArray removeAllObjects];
    [self.tableView2 reloadData];
    self.tableView2.hidden = NO;
    self.flag = 1;
    UITableViewCell * cell = (UITableViewCell*)[[button superview] superview];
    NSIndexPath * path = [self.tableView1 indexPathForCell:cell];
    
    self.midIndex = path.row;
    
    [self loadLoudongdata];
}
- (void)chooseloudong:(UIButton *)button
{
    UITableViewCell * cell = (UITableViewCell*)[[button superview] superview];
    NSIndexPath * path = [self.tableView2 indexPathForCell:cell];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"compcode"] = self.dataArray[self.leftIndex][@"compcode"];
    dic[@"compname"] = self.dataArray[self.leftIndex][@"compname"];
    dic[@"cpcode"] = self.dataArray[self.leftIndex][@"cplist"][self.midIndex][@"cpcode"];
    dic[@"cpname"] = self.dataArray[self.leftIndex][@"cplist"][self.midIndex][@"cpname"];
    dic[@"buildcode"] = self.rightArray[path.row][@"buildcode"];
    dic[@"buildname"] = self.rightArray[path.row][@"buildname"];
    if (self.MyBlock) {
        self.MyBlock(dic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchDetaildown:(UIButton *)button
{
    button.backgroundColor = [UIColor colorWithHexString:@"ffb400"];
}
- (void)touchDetailoutside:(UIButton *)button
{
    button.backgroundColor = [UIColor whiteColor];
}
#pragma mark - delete

#pragma mark - netWorking
- (void)loadDetailAddress
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
- (void)loadLoudongdata
{
    NSString * url = @"buildlistbycp.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"cpcode"] = self.dataArray[self.leftIndex][@"cplist"][self.midIndex][@"cpcode"];
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"data"] count] > 0) {
            [self.rightArray addObjectsFromArray:request[@"data"]];
            [self.tableView1 reloadData];
            [self.tableView2 reloadData];
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
- (NSMutableArray *)rightArray
{
    if (!_rightArray) {
        _rightArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _rightArray;
}
- (NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
@end
