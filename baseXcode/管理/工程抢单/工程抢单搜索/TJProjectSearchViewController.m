//
//  TJProjectSearchViewController.m
//  baseXcode
//
//  Created by hangshao on 16/12/19.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJProjectSearchViewController.h"
#import "TJChooseAddressViewController.h"
#import "TJChooseFanghaoViewController.h"
@interface TJProjectSearchViewController ()<UITableViewDelegate,UITableViewDataSource,XFDaterViewDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   weak) UITextField     * xiaoqu;
@property (nonatomic,   weak) UITextField     * fanghao;
@property (nonatomic,   weak) UITextField     * style;
@property (nonatomic,   weak) UITextField     * status;
@property (nonatomic,   weak) UITextField     * fromT;
@property (nonatomic,   weak) UITextField     * leftTime;
@property (nonatomic,   weak) UITextField     * rightTime;
@property (nonatomic,   assign) NSInteger   selectFlag;
@property (nonatomic,   strong) XFDaterView * dater;
@end

@implementation TJProjectSearchViewController

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
        self.dataDic[@"startdate"] = self.leftTime.text;
        self.dataDic[@"enddate"] = self.rightTime.text;
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
    return 208 - 72 + 4*fifteenS.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"TJProjectSearchCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJSearchRepairCell" owner:self options:nil] objectAtIndex:1];
    }
    for (int i = 0; i < 5; i ++) {
        UITextField * text = (UITextField *)[cell.contentView viewWithTag:100 + i];
        text.font = fifteenFont;
    }
    for (int i = 0; i < 5; i ++) {
        UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
        label1.font = fifteenFont;
    }
    for (int i = 0; i < 5; i ++) {
        UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
        view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
        view.borderWidth = 1.0;
        view.cornerRadius = 5.0;
    }
    UITextField * xiaoqu = (UITextField *)[cell.contentView viewWithTag:100];
    self.xiaoqu = xiaoqu;
    UITextField * fanghao = (UITextField *)[cell.contentView viewWithTag:101];
    self.fanghao = fanghao;
    UITextField * style = (UITextField *)[cell.contentView viewWithTag:102];
    self.style = style;
    UITextField * leftTime = (UITextField *)[cell.contentView viewWithTag:103];
    self.leftTime = leftTime;
    UITextField * rightTime = (UITextField *)[cell.contentView viewWithTag:104];
    self.rightTime = rightTime;
    for (int i = 0; i < 5; i ++) {
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
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionary];
    if (self.jumpFlag == 1) {
        YYCache * cache = [TJCache shareCache].yyCache;
        NSData * data = (id)[cache objectForKey:@"complaintBaseData"];
        dataDic = [data toDictionary];
    } else {
        YYCache * cache = [TJCache shareCache].yyCache;
        NSData * data = (id)[cache objectForKey:@"baoxiuBaseData"];
        dataDic = [data toDictionary];
    }
    
    if (button.tag == 110) {//小区
        TJChooseAddressViewController * vc = [[TJChooseAddressViewController alloc] init];
        vc.MyBlock = ^(NSMutableDictionary * dic){
            self.xiaoqu.text = dic[@"cpname"];
            self.dataDic[@"cpcode"] = dic[@"cpcode"];
            self.dataDic[@"cpname"] = dic[@"cpname"];
            self.fanghao.text = @"";
            [self.dataDic removeObjectForKey:@"buildcode"];
            [self.dataDic removeObjectForKey:@"houseid"];
            self.dataDic[@"buildcode"] = @"";
            self.dataDic[@"houseid"] = @"";
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 111) {//房号
        if (self.xiaoqu.text.length == 0) {
            SVShowError(@"请先选择小区!");
            return;
        }
        TJChooseFanghaoViewController * vc = [[TJChooseFanghaoViewController alloc] init];
        vc.cpcode = self.dataDic[@"cpcode"];
        vc.MyBlock= ^(NSMutableDictionary * dic){
            self.fanghao.text = [NSString stringWithFormat:@"%@－%@",dic[@"buildname"],dic[@"housename"]];
            [self.dataDic removeObjectForKey:@"buildcode"];
            [self.dataDic removeObjectForKey:@"houseid"];
            self.dataDic[@"buildcode"] = dic[@"buildcode"];
            self.dataDic[@"houseid"] = dic[@"houseid"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 112) {//类型
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@""];
        for (int i = 0; i < [dataDic[@"modlist"] count]; i ++) {
            [array addObject:dataDic[@"modlist"][i][@"modname"]];
        }
        CGSize s = [@"性别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 144+(fifteenS.height - 18)*3/2 andWidth:133 andHeight:(kScreenHeigth - (64 + 144+(fifteenS.height - 18)*3/2)) andData:array withString:self.style.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"modid"];
            if ([dic[@"index"] integerValue] == 0) {
                self.style.text = @"";
                self.dataDic[@"modid"] = @"";
                self.dataDic[@"modname"] = @"";
                return ;
            }
            self.style.text = dic[@"label"];
            self.dataDic[@"modid"] = dataDic[@"modlist"][[dic[@"index"] integerValue] - 1][@"modid"];
            self.dataDic[@"modname"] = dataDic[@"modlist"][[dic[@"index"] integerValue] - 1][@"modname"];
        }];
    }
    if (button.tag > 112) {//时间
        if (self.leftTime.text.length == 0 && button.tag == 114) {
            SVShowError(@"请先选择开始时间!");
            return;
        }
        self.selectFlag = button.tag - 113;
        self.dater = [[XFDaterView alloc]initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeigth)];
        self.dater.delegate = self;
        [self.dater showInView:self.view animated:YES];
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
        self.leftTime.text = self.dater.dateString;
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
        self.rightTime.text = self.dater.dateString;
    }
}
- (void)daterViewDidClicked:(XFDaterView *)daterView
{
    //取消
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
