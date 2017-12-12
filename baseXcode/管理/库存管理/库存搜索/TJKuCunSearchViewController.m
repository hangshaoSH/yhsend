//
//  TJKuCunSearchViewController.m
//  baseXcode
//
//  Created by hangshao on 17/1/11.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJKuCunSearchViewController.h"
#import "TJChooseAddressViewController.h"
#import "TJChooseGoodsViewController.h"
@interface TJKuCunSearchViewController ()<UITableViewDelegate,UITableViewDataSource,XFDaterViewDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   weak) UITextField     * xiaoqu;
@property (nonatomic,   weak) UITextField     * goods;
@property (nonatomic,   weak) UITextField     * style;
@property (nonatomic,   weak) UITextField     * status;
@property (nonatomic,   weak) UITextField     * fromT;
@property (nonatomic,   weak) UITextField     * leftTime;
@property (nonatomic,   weak) UITextField     * rightTime;
@property (nonatomic,   assign) NSInteger   selectFlag;
@property (nonatomic,   strong) XFDaterView * dater;
@end

@implementation TJKuCunSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView];
    
    [self setTableView];
    
    [self setHeaderView];
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
    label.text = @"搜索";
    label.font = seventeenFont;
    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        [button addTarget:self action:@selector(backAndSearch:)];
    }
}
- (void)backAndSearch:(UIButton *)button
{
    if (button.tag == 110) {
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    } else {
        if (self.MyBlock) {
            self.MyBlock(self.dataDic);
        }
    }
    [YHNetWork stopTheVcRequset:self];
    [self.navigationController popViewControllerAnimated:YES];
}
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
    return 1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 112 - 2 * 18 + 2*fifteenS.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"TJKCLSearchCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJReserveManagerCell" owner:self options:nil] objectAtIndex:6];
    }
    for (int i = 0; i < 2; i ++) {
        UITextField * text = (UITextField *)[cell.contentView viewWithTag:100 + i];
        text.font = fifteenFont;
    }
    for (int i = 0; i < 2; i ++) {
        UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
        label1.font = fifteenFont;
    }
    for (int i = 0; i < 2; i ++) {
        UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
        view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
        view.borderWidth = 1.0;
        view.cornerRadius = 5.0;
    }
    UITextField * xiaoqu = (UITextField *)[cell.contentView viewWithTag:100];
    self.xiaoqu = xiaoqu;
    UITextField * goods = (UITextField *)[cell.contentView viewWithTag:101];
    self.goods = goods;
    for (int i = 0; i < 2; i ++) {
        UIButton * edite = (UIButton *)[cell.contentView viewWithTag:110 + i];
        [edite addTarget:self action:@selector(allRepairbutAc:)];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return;
}

#pragma mark - buttonAction
- (void)allRepairbutAc:(UIButton *)button
{
    if (button.tag == 110) {//小区
        TJChooseAddressViewController * vc = [[TJChooseAddressViewController alloc] init];
        vc.MyBlock = ^(NSMutableDictionary * dic){
            if ([self.dataDic count] > 0) {
                [self.dataDic removeObjectForKey:@"cpcode"];
                [self.dataDic removeObjectForKey:@"cpname"];
            }
            self.xiaoqu.text = dic[@"cpname"];
            self.dataDic[@"cpcode"] = dic[@"cpcode"];
            self.dataDic[@"cpname"] = dic[@"cpname"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 111) {//商品
        TJChooseGoodsViewController * vc = [[TJChooseGoodsViewController alloc] init];
        vc.cpcode = @"";
        vc.MyBlock = ^(NSMutableDictionary * dic){
            [self.dataDic removeObjectForKey:@"billid"];
            self.dataDic[@"billid"] = dic[@"billid"];
            self.goods.text = dic[@"billtitle"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
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
