//
//  TJChooseFanghaoViewController.m
//  baseXcode
//
//  Created by hangshao on 16/12/1.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJChooseFanghaoViewController.h"

@interface TJChooseFanghaoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   weak) UITableView     * tableView1;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableArray     * rightArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   assign) NSInteger   index;
@end

@implementation TJChooseFanghaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView];
    
    [self setTableView];
    
    [self loadLoudongData];
}
#pragma mark - setView
- (void)setTopView
{
    UIView * topview = [[[NSBundle mainBundle] loadNibNamed:@"TJSearchCell" owner:self options:nil]objectAtIndex:1];
    topview.frame = Rect(0, 64, kScreenWidth, 47*ScaleModel + 1);
    [self.view addSubview:topview];
    for (int i = 0; i < 2; i ++) {
        UILabel * label1 = (UILabel *)[topview viewWithTag:100 + i];
        if (i == 0) {
            label1.text = @"楼栋";
        } else {
            label1.text = @"房号";
        }
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
    } else {
        if (self.rightArray.count == 0) {
            return self.tableView.height;
        }
    }
    return 43 + fifteenS.height - 18;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"TJChooseAddressCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJSearchCell" owner:self options:nil] objectAtIndex:2];
    }
    UIButton * button = (UIButton *)[cell.contentView viewWithTag:110];
    if (tableView.tag == 900) {
        if (self.dataArray.count == 0) {
            TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
            [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        button.title = self.dataArray[indexPath.row][@"buildname"];
        if ([self.dataArray[indexPath.row][@"flag"] integerValue]== 1) {
            button.backgroundColor = [UIColor colorWithHexString:@"fffbf0"];
            button.titleColor = [UIColor colorWithHexString:@"57bdb9"];
        }else {
            button.backgroundColor = [UIColor whiteColor];
            button.titleColor = [UIColor colorWithHexString:@"808080"];
        }
        [button addTarget:self action:@selector(chooseloudong:)];
    } else {
        if (self.rightArray.count == 0) {
            TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
            [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        button.titleColor = [UIColor colorWithHexString:@"808080"];
        button.backgroundColor = [UIColor whiteColor];
        button.title = self.rightArray[indexPath.row][@"housename"];
        [button addTarget:self action:@selector(choosefanghao:)];
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
            if ([[User sharedUser].showMidLoading isEqualToString:@"点击进行刷新!"]) {
                [self loadLoudongData];
            }
        }
    } else {
        if (self.rightArray.count == 0) {
            if ([[User sharedUser].showMidLoading isEqualToString:@"点击进行刷新!"]) {
                [self loadLoudongData];
            }
        }
    }
}

#pragma mark - buttonAction
- (void)chooseloudong:(UIButton *)button
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
    [self.rightArray removeAllObjects];
    [self.tableView reloadData];
    [self.tableView1 reloadData];
    [self loadFanghaoData];
}
- (void)choosefanghao:(UIButton *)button
{
    UITableViewCell * cell = (UITableViewCell*)[[button superview] superview];
    NSIndexPath * path = [self.tableView1 indexPathForCell:cell];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"buildcode"] = self.dataArray[self.index][@"buildcode"];
    dic[@"buildname"] = self.dataArray[self.index][@"buildname"];
    dic[@"houseid"] = self.rightArray[path.row][@"houseid"];
    dic[@"housename"] = self.rightArray[path.row][@"housename"];
    if (self.MyBlock) {
        self.MyBlock(dic);
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
- (void)loadLoudongData
{
    NSString * url = @"buildlistbycp.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"cpcode"] = self.cpcode;
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"data"] count] > 0) {
            [self.dataArray addObjectsFromArray:request[@"data"]];
            [self.tableView reloadData];
        }else {
            [User sharedUser].showMidLoading = @"点击进行刷新!";
        }
    } failBlock:^(NSError *error) {
        [User sharedUser].showMidLoading = @"无网络连接，请检查您的网络!";
        [self.tableView reloadData];
    }];
}
- (void)loadFanghaoData
{
    NSString * url = @"housenamelist.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"cpcode"] = self.cpcode;
    params[@"buildcode"] = self.dataArray[self.index][@"buildcode"];
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            if ([request[@"data"] count] > 0) {
                [self.rightArray addObjectsFromArray:request[@"data"]];
            }else {
                [User sharedUser].showMidLoading = @"";
            }
        }else {
            [User sharedUser].showMidLoading = @"点击进行刷新!";
        }
        [self.tableView reloadData];
        [self.tableView1 reloadData];
    } failBlock:^(NSError *error) {
        [User sharedUser].showMidLoading = @"无网络连接，请检查您的网络!";
        [self.tableView reloadData];
        [self.tableView1 reloadData];
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
