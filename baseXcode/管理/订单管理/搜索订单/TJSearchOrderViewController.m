//
//  TJSearchOrderViewController.m
//  baseXcode
//
//  Created by hangshao on 17/1/5.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJSearchOrderViewController.h"
#import "TJChooseAddressViewController.h"
#import "TJChooseDetailAddressMenViewController.h"
#import "TJChooseGoodsViewController.h"
@interface TJSearchOrderViewController ()<UITableViewDelegate,UITableViewDataSource,XFDaterViewDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   weak) UITextField     * xiaoqu;
@property (nonatomic,   weak) UITextField     * status;
@property (nonatomic,   weak) UITextField     * goods;
@property (nonatomic,   weak) UITextField     * address;
@property (nonatomic,   weak) UITextField     * begintime;
@property (nonatomic,   weak) UITextField     * endtime;
@property (nonatomic,   weak) UITextField     * numberT;
@property (nonatomic,   assign) NSInteger   selectFlag;
@property (nonatomic,   strong) XFDaterView * dater;
@end

@implementation TJSearchOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView];
    
    [self setHeaderView];
    
    [self setTableView];
}

#pragma mark - setview
- (void)setHeaderView
{
    UIView * topView = [[[NSBundle mainBundle] loadNibNamed:@"TJManageTopCell" owner:self options:nil] objectAtIndex:1];
    topView.origin = zeroOrigin;
    topView.width = kScreenWidth;
    topView.height = 64;
    topView.backgroundColor = TopBgColor;
    [self.view addSubview:topView];
    
    UILabel * label = (UILabel *)[topView viewWithTag:100];
    label.font = seventeenFont;
    label.text = @"搜索";
    
    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        [button addTarget:self action:@selector(homeAndRefresh:)];
    }
}
- (void)homeAndRefresh:(UIButton *)button
{
    if (button.tag == 110) {
        [YHNetWork stopTheVcRequset:self];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"cpcode"] = self.dataDic[@"cpcode"];
        dic[@"startdate"] = self.begintime.text;
        dic[@"enddate"] = self.endtime.text;
        dic[@"ordersta"] = self.dataDic[@"ordersta"];
        dic[@"ordercode"] = self.numberT.text;
        dic[@"modid"] = @"";
        dic[@"billid"] = self.dataDic[@"billid"];
        if (self.address.text.length == 0) {
            dic[@"memberfrom"] = @"";
            dic[@"memberid"] = @"";
        }else {
            dic[@"memberfrom"] = @"0";
            dic[@"memberid"] = self.dataDic[@"houseid"];
        }
        if (self.myBlock) {
            self.myBlock(dic);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)setTopView
{
    
}
- (void)setTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
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
    return 326 - 6*18 + 6 * fifteenS.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"TJOrderSearchCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJManagerOrderCell" owner:self options:nil] objectAtIndex:1];
    }
    for (int i = 0; i < 6; i ++) {
        UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
        label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
        label1.textColor = fivelightColor;
    }
    for (int i = 0; i < 7; i ++) {
        UITextField * text = (UITextField *)[cell.contentView viewWithTag:100 + i];
        text.font = fifteenFont;
    }
    for (int i = 0; i < 7; i ++) {
        UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
        view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
        view.borderWidth = 1.0;
        view.cornerRadius = 5.0;
    }
    for (int i = 0; i < 6; i ++) {
        UIButton * edite = (UIButton *)[cell.contentView viewWithTag:110 + i];
        [edite addTarget:self action:@selector(chooseorderXiaoquAndTime:)];
    }
    UITextField * xiaoqu = (UITextField *)[cell.contentView viewWithTag:100];
    self.xiaoqu = xiaoqu;
    UITextField * status = (UITextField *)[cell.contentView viewWithTag:101];
    self.status = status;
    UITextField * goods = (UITextField *)[cell.contentView viewWithTag:102];
    self.goods = goods;
    UITextField * begintime = (UITextField *)[cell.contentView viewWithTag:103];
    self.begintime = begintime;
    UITextField * endtime = (UITextField *)[cell.contentView viewWithTag:104];
    self.endtime = endtime;
    UITextField * address = (UITextField *)[cell.contentView viewWithTag:105];
    self.address = address;
    UITextField * numberT = (UITextField *)[cell.contentView viewWithTag:106];
    numberT.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    self.numberT = numberT;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return;
}

#pragma mark - buttonAction
- (void)chooseorderXiaoquAndTime:(UIButton *)button
{
    if (button.tag == 110) {
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
    if (button.tag == 111) {//状态
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@""];
        [array addObject:@"待付款"];
        [array addObject:@"已付款未配送"];
        [array addObject:@"已配送"];
        [array addObject:@"已关闭"];
        [array addObject:@"待退款"];
        [array addObject:@"已过期"];
        [array addObject:@"已退款"];
        [array addObject:@"待评价"];
        [array addObject:@"已评价"];
        CGSize s = [@"性别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 96+(fifteenS.height - 18)*2/2 andWidth:133 andHeight:5*34+20 andData:array withString:self.status.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"index"];
            if ([dic[@"index"] integerValue] == 0) {
                self.status.text = @"";
                self.dataDic[@"ordersta"] = @"";
                return ;
            }
            self.status.text = dic[@"label"];
            if ([dic[@"index"] integerValue] < 5) {
                self.dataDic[@"ordersta"] = @([dic[@"index"] integerValue] - 1);
            } else {
                self.dataDic[@"ordersta"] = dic[@"index"];
            }
            
        }];
    }
    if (button.tag == 112) {//商品id
        TJChooseGoodsViewController * vc = [[TJChooseGoodsViewController alloc] init];
        vc.MyBlock = ^(NSMutableDictionary * dic){
            if ([self.dataDic count] > 0) {
                [self.dataDic removeObjectForKey:@"billid"];
            }
            self.goods.text = dic[@"billtitle"];
            self.dataDic[@"billid"] = dic[@"billid"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 113 || button.tag == 114) {//时间
        if (self.begintime.text.length == 0 && button.tag == 114) {
            SVShowError(@"请先选择开始时间!");
            return;
        }
        self.selectFlag = button.tag - 113;
        self.dater = [[XFDaterView alloc]initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeigth)];
        self.dater.delegate = self;
        [self.dater showInView:self.view animated:YES];
    }
    if (button.tag == 115) {//houseid
        TJChooseDetailAddressMenViewController * vc = [[TJChooseDetailAddressMenViewController alloc] init];
        vc.MyBlock = ^(NSMutableDictionary * dic){
            [self.dataDic removeObjectForKey:@"buildcode"];
            [self.dataDic removeObjectForKey:@"buildname"];
            [self.dataDic removeObjectForKey:@"cpcode"];
            [self.dataDic removeObjectForKey:@"cpname"];
            [self.dataDic removeObjectForKey:@"houseid"];
            [self.dataDic removeObjectForKey:@"housename"];
            self.dataDic[@"compcode"] = dic[@"buildcode"];
            self.dataDic[@"compname"] = dic[@"buildname"];
            self.dataDic[@"cpcode"] = dic[@"cpcode"];
            self.dataDic[@"cpname"] = dic[@"cpname"];
            self.dataDic[@"houseid"] = dic[@"houseid"];
            self.dataDic[@"housename"] = dic[@"housename"];
            self.address.text = [NSString stringWithFormat:@"%@－%@－%@",dic[@"cpname"],dic[@"buildname"],dic[@"housename"]];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - delete
- (void)daterViewDidCancel:(XFDaterView *)daterView
{
    NSString * nowTime = [[[User sharedUser] getNowTime] substringToIndex:4];
    NSString * year = [self.dater.dateString substringToIndex:4];
    if ([year intValue] != [nowTime intValue]) {
        self.dater.dateString = [NSString stringWithFormat:@"%d%@",[year intValue]-150,[self.dater.dateString substringFromIndex:4]];
    }
    if (self.selectFlag == 0) {
        self.begintime.text = self.dater.dateString;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate* date = [formatter dateFromString:self.dater.dateString];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
        self.dataDic[@"left"] = timeSp;
    }
    if (self.selectFlag == 1) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate* date = [formatter dateFromString:self.dater.dateString];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
        self.dataDic[@"right"] = timeSp;
        if ([self.dataDic[@"left"] doubleValue] > [timeSp doubleValue]) {
            SVShowError(@"时间选择有误!");
            return;
        }
        self.endtime.text = self.dater.dateString;
    }
}
- (void)daterViewDidClicked:(XFDaterView *)daterView
{
    //取消
}
#pragma mark - netWorking
- (void)keepSearch
{
    
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
        self.dataDic[@"cpcode"] = @"";
        self.dataDic[@"ordersta"] = @"";
        self.dataDic[@"billid"] = @"";
    }
    return _dataDic;
}
@end
