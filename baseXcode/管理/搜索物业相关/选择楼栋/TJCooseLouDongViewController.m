//
//  TJCooseLouDongViewController.m
//  baseXcode
//
//  Created by hangshao on 16/11/22.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJCooseLouDongViewController.h"

@interface TJCooseLouDongViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@end

@implementation TJCooseLouDongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView];
    
    [self setTableView];
    
    [self loadLoudongData];
}
#pragma mark - setView
- (void)setTopView
{
    UIView * topview = [[[NSBundle mainBundle] loadNibNamed:@"TJSearchCell" owner:self options:nil]objectAtIndex:3];
    topview.frame = Rect(0, 64, kScreenWidth, 47*ScaleModel + 1);
    [self.view addSubview:topview];
    for (int i = 0; i < 1; i ++) {
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
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+47*ScaleModel + 1, kScreenWidth, kScreenHeigth - 64-47*ScaleModel - 1) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
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
    return self.dataArray.count;
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
    button.title = self.dataArray[indexPath.row][@"buildname"];
    button.backgroundColor = [UIColor whiteColor];
    button.titleColor = [UIColor colorWithHexString:@"808080"];
    [button addTarget:self action:@selector(chooseloudong:)];
    [button addTarget:self action:@selector(touchloudongdown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(touchloudongdown:) forControlEvents:UIControlEventTouchDragInside];
    [button addTarget:self action:@selector(touchloudongout:) forControlEvents:UIControlEventTouchDragOutside];
    [button addTarget:self action:@selector(touchloudongout:) forControlEvents:UIControlEventTouchDownRepeat];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        [self loadLoudongData];
    }
}

#pragma mark - buttonAction
- (void)chooseloudong:(UIButton *)button
{
    UITableViewCell * cell = (UITableViewCell*)[[button superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    if (self.MyBlock) {
        self.MyBlock(self.dataArray[path.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchloudongdown:(UIButton *)button
{
    button.backgroundColor = [UIColor colorWithHexString:@"ffb400"];
}
- (void)touchloudongout:(UIButton *)button
{
    button.backgroundColor = [UIColor whiteColor];
}
#pragma mark - delete
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
#pragma mark - netWorking


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
