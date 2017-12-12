//
//  TJSearchComplaintViewController.m
//  baseXcode
//
//  Created by hangshao on 16/12/13.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJSearchComplaintViewController.h"
#import "TJChooseAddressViewController.h"
#import "TJChooseFanghaoViewController.h"
@interface TJSearchComplaintViewController ()<UITableViewDelegate,UITableViewDataSource,XFDaterViewDelegate,UITextFieldDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   weak) UITextField     * xiaoqu;
@property (nonatomic,   weak) UITextField     * koufen;
@property (nonatomic,   weak) UITextField     * guanbi;
@property (nonatomic,   weak) UITextField     * other;
@property (nonatomic,   weak) UITextField     * style;
@property (nonatomic,   weak) UITextField     * status;
@property (nonatomic,   weak) UITextField     * huifang;
@property (nonatomic,   weak) UITextField     * leftTime;
@property (nonatomic,   weak) UITextField     * rightTime;
@property (nonatomic,   assign) NSInteger   selectFlag;
@property (nonatomic,   strong) XFDaterView * dater;
@end

@implementation TJSearchComplaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView];
    
    [self setTableView];
    
    [self setHeaderView];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addSCKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addSCKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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
        self.dataDic[@"msgkeys"] = self.other.text;
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
    return 277 + 8*fifteenS.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"TJSearchComplaintCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJSearchComplaintCell" owner:self options:nil] objectAtIndex:0];
    }
    for (int i = 0; i < 9; i ++) {
        UITextField * text = (UITextField *)[cell.contentView viewWithTag:100 + i];
        text.font = fifteenFont;
    }
    for (int i = 0; i < 9; i ++) {
        UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
        label1.font = fifteenFont;
    }
    for (int i = 0; i < 9; i ++) {
        UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
        view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
        view.borderWidth = 1.0;
        view.cornerRadius = 5.0;
    }
    UITextField * xiaoqu = (UITextField *)[cell.contentView viewWithTag:100];
    self.xiaoqu = xiaoqu;
    UITextField * huifang = (UITextField *)[cell.contentView viewWithTag:103];
    self.huifang = huifang;
    UITextField * style = (UITextField *)[cell.contentView viewWithTag:101];
    self.style = style;
    UITextField * status = (UITextField *)[cell.contentView viewWithTag:102];
    self.status = status;
    UITextField * guanbi = (UITextField *)[cell.contentView viewWithTag:104];
    self.guanbi = guanbi;
    UITextField * koufen = (UITextField *)[cell.contentView viewWithTag:105];
    self.koufen = koufen;
    UITextField * other = (UITextField *)[cell.contentView viewWithTag:108];
    other.delegate = self;
    other.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    self.other = other;
    UITextField * leftTime = (UITextField *)[cell.contentView viewWithTag:106];
    self.leftTime = leftTime;
    UITextField * rightTime = (UITextField *)[cell.contentView viewWithTag:107];
    self.rightTime = rightTime;
    for (int i = 0; i < 8; i ++) {
        UIButton * edite = (UIButton *)[cell.contentView viewWithTag:110 + i];
        [edite addTarget:self action:@selector(allSearchRepairbutAc:)];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return;
}

#pragma mark - buttonAction
- (void)allSearchRepairbutAc:(UIButton *)button
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
            [self.dataDic removeObjectForKey:@"cpcode"];
            [self.dataDic removeObjectForKey:@"cpname"];
            self.dataDic[@"cpcode"] = dic[@"cpcode"];
            self.dataDic[@"cpname"] = dic[@"cpname"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 111) {//类型
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@""];
        for (int i = 0; i < [dataDic[@"modlist"] count]; i ++) {
            [array addObject:dataDic[@"modlist"][i][@"modname"]];
        }
        CGSize s = [@"性别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 96+(fifteenS.height - 18)*2/2 andWidth:133 andHeight:(kScreenHeigth - (64 + 144+(fifteenS.height - 18)*3/2)) andData:array withString:self.style.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"modid"];
            [self.dataDic removeObjectForKey:@"modname"];
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
    if (button.tag == 112) {//状态
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@""];
        [array addObject:@"未受理"];
        [array addObject:@"已受理"];
        [array addObject:@"不受理回复"];
        CGSize s = [@"性别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 144+(fifteenS.height - 18)*3/2 andWidth:133 andHeight:array.count*34 andData:array withString:self.status.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"isaccept"];
            if ([dic[@"index"] integerValue] == 0) {
                self.status.text = @"";
                self.dataDic[@"isaccept"] = @"";
                return ;
            }
            self.status.text = dic[@"label"];
            self.dataDic[@"isaccept"] = [NSString stringWithFormat:@"%ld",[dic[@"index"] integerValue] - 1];
        }];
    }
    if (button.tag == 113) {//回访
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@""];
        [array addObject:@"未回访"];
        [array addObject:@"已回访"];
        [array addObject:@"已完成已回访"];
        [array addObject:@"已访>24h"];
        [array addObject:@"已访>48h"];
        CGSize s = [@"性别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 192+(fifteenS.height - 18)*4/2 andWidth:133 andHeight:array.count*34 andData:array withString:self.huifang.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"isvisit"];
            if ([dic[@"index"] integerValue] == 0) {
                self.huifang.text = @"";
                self.dataDic[@"isvisit"] = @"";
                return ;
            }
            self.huifang.text = dic[@"label"];
            if ([dic[@"index"] integerValue] > 2) {
                self.dataDic[@"isvisit"] = dic[@"index"];
            }else {
                self.dataDic[@"isvisit"] = [NSString stringWithFormat:@"%ld",[dic[@"index"] integerValue] - 1];
            }
            
        }];
    }
    if (button.tag == 114) {//关闭
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@""];
        [array addObject:@"未关闭"];
        [array addObject:@"已关闭"];
        CGSize s = [@"性别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 240+(fifteenS.height - 18)*5/2 andWidth:133 andHeight:array.count*34 andData:array withString:self.guanbi.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"isclose"];
            if ([dic[@"index"] integerValue] == 0) {
                self.guanbi.text = @"";
                self.dataDic[@"isclose"] = @"";
                return ;
            }
            self.guanbi.text = dic[@"label"];
            self.dataDic[@"isclose"] = [NSString stringWithFormat:@"%ld",[dic[@"index"] integerValue]-1];
        }];
    }
    if (button.tag == 115) {//扣分
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@""];
        [array addObject:@"未扣分"];
        [array addObject:@"已扣分"];
        CGSize s = [@"性别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 288+(fifteenS.height - 18)*6/2 andWidth:133 andHeight:array.count*34 andData:array withString:self.koufen.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"ispunish"];
            if ([dic[@"index"] integerValue] == 0) {
                self.koufen.text = @"";
                self.dataDic[@"ispunish"] = @"";
                return ;
            }
            self.koufen.text = dic[@"label"];
            self.dataDic[@"ispunish"] = [NSString stringWithFormat:@"%ld",[dic[@"index"] integerValue]-1];
        }];
    }
    if (button.tag > 115) {//时间
        if (self.leftTime.text.length == 0 && button.tag == 117) {
            SVShowError(@"请先选择开始时间!");
            return;
        }
        self.selectFlag = button.tag - 116;
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
- (void)addSCKeyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    self.tableView.frame = Rect(0, 64 - (401 +  + height + (fifteenS.height - 18) * 7 / 2) + (kScreenHeigth - 64), kScreenWidth, kScreenHeigth * 3 / 2);
}
- (void)addSCKeyboardWillHide:(NSNotification *)aNotification
{
    self.tableView.frame = Rect(0, 64, kScreenWidth, kScreenHeigth - 64);
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
