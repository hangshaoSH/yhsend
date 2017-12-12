//
//  TJMemberDetailViewController.m
//  baseXcode
//
//  Created by hangshao on 16/11/20.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJMemberDetailViewController.h"
#import "TJMemberDetailTableViewCell.h"
#import "TJMemberFooterTableViewCell.h"
#import "TJChooseDetailAddressMenViewController.h"
#import "TJHouseListViewController.h"
#import "TJMemberHeyanView.h"
@interface TJMemberDetailViewController ()<UITableViewDelegate,UITableViewDataSource,TJMemberDetailDelegate,TJMemberFooterDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic1;
@property (nonatomic,   strong) NSMutableDictionary     * dataDicCunzhu;
@property (nonatomic,   strong) NSString     * houseid;
@end

@implementation TJMemberDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.houseid = [NSString string];
    
    [self setTopView];
    
    [self setTableView];
    
    [self loadMemberDetail];
}
#pragma mark - setView
- (void)setTopView
{
    
}
- (void)setTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //    初始化tabelView
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeigth - 64) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    WeakSelf
    wself.ts_navgationBar = [TSNavigationBar navWithTitle:@"会员核验详情" backAction:^{
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
    return 2;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataDic count] == 0) {
        return self.tableView.height;
    }
    CGSize s = [@"相关" getStringRectWithfontSize:15 * ScaleModel width:100];
    if (indexPath.row == 0) {
        return 136 + 5 * s.height;
    }else {
        return 228 + 4 * s.height;
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
        TJMemberDetailTableViewCell * cell = [TJMemberDetailTableViewCell cellWithTableView:tableView];
        [cell setDataWithDic:self.dataDic];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        TJMemberFooterTableViewCell * cell = [TJMemberFooterTableViewCell cellWithTableView:tableView];
        [cell setDataWithDic:self.dataDicCunzhu dic1:self.dataDic1];
        if (self.houseid.length > 0) {
            [cell isshowHouseId:NO];
        } else {
            [cell isshowHouseId:YES];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([self.dataDic count] == 0) {
        self.dataDic = nil;
        [self loadMemberDetail];
    }
}

#pragma mark - buttonAction
- (void)chooseAddressAction
{
    TJChooseDetailAddressMenViewController * vc = [[TJChooseDetailAddressMenViewController alloc] init];
    vc.MyBlock = ^(NSMutableDictionary * dic){
        self.dataDicCunzhu = nil;
        self.dataDicCunzhu = [NSMutableDictionary dictionaryWithDictionary:dic];
        self.houseid = dic[@"houseid"];
        NSString * url = @"house/ownerlist.jsp";
        
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"clerkid"] = userClerkid;
        params[@"houseid"] = dic[@"houseid"];
        [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
            if ([request[@"flag"] integerValue] == 0) {
                if ([request[@"data"] count] > 0) {
                    if ([request[@"data"] isKindOfClass:[NSDictionary class]]) {
                        self.dataDic1 = [NSMutableDictionary dictionaryWithDictionary:request[@"data"]];
                    }else if([request[@"data"] isKindOfClass:[NSArray class]]){
                        self.dataDic1 = [NSMutableDictionary dictionaryWithDictionary:request[@"data"][0]];
                    }
                }else {
                    
                }
                [self.tableView reloadData];
            }else {
                SVShowError(request[@"err"]);
            }
        } failBlock:^(NSError *error) {
           SVShowError(@"网络错误，请重试!");
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - delegate
- (void)chooseAddress
{
    TJHouseListViewController * vc = [[TJHouseListViewController alloc] init];
    vc.jumpFlag = @"1";
    vc.jumpDic = self.dataDic;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)yesOrNoShouliAc:(NSInteger)flag
{
    if (flag == 1) {
        [self shouliYubutshouli:1 andContent:nil];
    }
    if (flag == 2) {
        [[TJMemberHeyanView sharedInstance] setMidViewWithTitle:@"不通过回复" returnString:^(NSString *text) {
           [self shouliYubutshouli:2 andContent:text];
        }];
    }
}
#pragma mark - netWorking
- (void)loadMemberDetail
{
    NSString * url = @"member/reqinfo.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = [User sharedUser].userInfo[@"clerkid"];;
    params[@"reqid"] = self.reqid;
    
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"data"] count] > 0) {
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:request[@"data"]];
            [self.tableView reloadData];
            [self loadHouseId:request[@"data"][@"cpcode"] andBuildcode:request[@"data"][@"buildcode"]];
        }else {
            SVShowError(request[@"err"]);
        }
    } failBlock:^(NSError *error) {
        [User sharedUser].showMidLoading = @"网络连接错误，请检查您的网络!";
        [self.tableView reloadData];
    }];
}
- (void)loadHouseId:(NSString *)cpcode andBuildcode:(NSString *)buildcode
{
    NSString * url = @"housenamelist.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"cpcode"] = cpcode;
    params[@"buildcode"] = buildcode;
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            if ([request[@"data"] count] > 0) {
                for (NSMutableDictionary * dic in request[@"data"]) {
                    if ([dic[@"housename"] isEqualToString:self.dataDic[@"housename"]]) {
                        self.houseid = dic[@"housename"];
                    }
                }
            }
        }
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        [self loadHouseId:cpcode andBuildcode:buildcode];
    }];
}
- (void)shouliYubutshouli:(NSInteger)flag andContent:(NSString *)backspec
{
    NSString * url = @"member/bind.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"reqid"] = self.reqid;
    params[@"houseid"] = self.houseid;
    params[@"memberid"] = self.dataDic[@"memberid"];
    params[@"identity"] = self.dataDic[@"identity"];
    params[@"validend"] = @"";
    params[@"checksta"] = @(flag);
    params[@"backspec"] = backspec;
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(@"已核验!");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.MyBlock) {
                    self.MyBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else {
            SVShowError(request[@"err"]);
        }
    } failBlock:^(NSError *error) {
        SVShowError(@"网络连接错误，请重试");
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
- (NSMutableDictionary *)dataDic1
{
    if (!_dataDic1) {
        _dataDic1 = [NSMutableDictionary dictionary];
    }
    return _dataDic1;
}
- (NSMutableDictionary *)dataDicCunzhu
{
    if (!_dataDicCunzhu) {
        _dataDicCunzhu = [NSMutableDictionary dictionary];
    }
    return _dataDicCunzhu;
}
@end
