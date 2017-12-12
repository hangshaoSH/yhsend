//
//  TJEditeHouseDataViewController.m
//  baseXcode
//
//  Created by hangshao on 16/11/23.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJEditeHouseDataViewController.h"
#import "TJChooseDetailAddressViewController.h"
@interface TJEditeHouseDataViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,XFDaterViewDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   weak) UITextField     * addressT;
@property (nonatomic,   weak) UITextField     * floorT;
@property (nonatomic,   weak) UITextField     * doorNumberT;
@property (nonatomic,   weak) UITextField     * styleT;
@property (nonatomic,   weak) UITextField     * statusT;
@property (nonatomic,   weak) UITextField     * chanquanT;
@property (nonatomic,   weak) UITextField     * huxingT;
@property (nonatomic,   weak) UITextField     * chaoxiangT;
@property (nonatomic,   weak) UITextField     * zhuangxiuT;
@property (nonatomic,   weak) UITextField     * jianzhuAreaT;
@property (nonatomic,   weak) UITextField     * payAreaT;
@property (nonatomic,   weak) UITextField     * useAreaT;
@property (nonatomic,   weak) UITextField     * jiaofangtime;
@property (nonatomic,   weak) UITextField     * jiefangtime;
@property (nonatomic,   weak) UITextField     * zhuangxiutime;
@property (nonatomic,   assign) CGFloat  scrollY;
@property (nonatomic,   assign) NSInteger  textFlag;
@property (nonatomic,   assign) NSInteger   flag;
@property (nonatomic,   assign) NSInteger   selectFlag;
@property (nonatomic,   strong) XFDaterView * dater;
@end

@implementation TJEditeHouseDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView];
    
    [self setTableView];
    
    [self setHeaderView];
    
    [self setdataSourse];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
#pragma mark - setView
- (void)setdataSourse
{
    if ([self.navTitle isEqualToString:@"添加物业"]) {
        return;
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.oldDataDic];
    YYCache * cache = [TJCache shareCache].yyCache;
    NSData * data = (id)[cache objectForKey:@"houseBaseData"];
    NSMutableDictionary * dataDic = [data toDictionary];
    for (int i = 0; i < [dataDic[@"zhuanglist"] count]; i ++) {
        if ([dic[@"zhuangxiu"] isEqualToString:dataDic[@"zhuanglist"][i][@"zhuangname"]]) {
            [dic removeObjectForKey:@"zhuangxiu"];
            [dic setObject:dataDic[@"zhuanglist"][i][@"zhuangname"] forKey:@"zhuangname"];
            [dic setObject:dataDic[@"zhuanglist"][i][@"zhuangid"] forKey:@"zhuangid"];
        }
    }
    if ([dic[@"houseowner"] isEqualToString:@"业主"] || [dic[@"houseowner"] isEqualToString:@"小业主"]) {
        for (int i = 0; i < [dataDic[@"hssalelist"] count]; i ++) {
            if ([dataDic[@"hssalelist"][i][@"hssalename"] isEqualToString:@"小业主"]) {
                [dic setObject:dataDic[@"hssalelist"][i][@"hssaleid"] forKey:@"hssaleid"];
                [dic setObject:dataDic[@"hssalelist"][i][@"hssalename"] forKey:@"hssalename"];
            }
        }
    } else if ([dic[@"houseowner"] isEqualToString:@"开发商"]){
        for (int i = 0; i < [dataDic[@"hssalelist"] count]; i ++) {
            if ([dataDic[@"hssalelist"][i][@"hssalename"] isEqualToString:@"开发商"]) {
                [dic setObject:dataDic[@"hssalelist"][i][@"hssaleid"] forKey:@"hssaleid"];
                [dic setObject:dataDic[@"hssalelist"][i][@"hssalename"] forKey:@"hssalename"];
            }
        }
    } else {
        [dic setObject:@"hssaleid" forKey:@""];
        [dic setObject:@"hssalename" forKey:@""];
    }
    [dic setObject:dic[@"housestaid"] forKey:@"staid"];
    [dic setObject:dic[@"housesta"] forKey:@"staname"];
    self.dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
}
- (void)setHeaderView
{
    UIView * topView = [[[NSBundle mainBundle] loadNibNamed:@"TJManageTopCell" owner:self options:nil] objectAtIndex:1];
    topView.origin = zeroOrigin;
    topView.width = kScreenWidth;
    topView.height = 64;
    topView.backgroundColor = TopBgColor;
    [self.view addSubview:topView];
    
    UILabel * label = (UILabel *)[topView viewWithTag:100];
    label.text = self.navTitle;
    label.font = seventeenFont;
    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        [button addTarget:self action:@selector(backAndSure:)];
    }
}
- (void)backAndSure:(UIButton *)button
{
    if (button.tag == 110) {
        [YHNetWork stopTheVcRequset:self];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"是否保存房屋信息" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self addHousedata];
            }
        }];
    }
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
    return 743 + (fifteenS.height - 18) * 15/2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"TJEditeHouseDataMainCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJEditeHousedataCell" owner:self options:nil] firstObject];
    }
    for (int i = 0; i < 15; i ++) {
        UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
        label1.font = fifteenFont;
    }
    for (int i = 0; i < 15; i ++) {
        UITextField * text = (UITextField *)[cell.contentView viewWithTag:100 + i];
        text.font = fifteenFont;
    }
    for (int i = 0; i < 15; i ++) {
        UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
        view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
        view.borderWidth = 0.7;
        view.cornerRadius = 5.0;
    }
    for (int i = 0; i < 10; i ++) {
        UIButton * button = (UIButton *)[cell.contentView viewWithTag:120 + i];
        [button addTarget:self action:@selector(allchoose:)];
        if (i == 0) {
            if ([self.navTitle isEqualToString:@"编辑物业信息"]) {
                button.userInteractionEnabled = NO;
            }
        }
    }
    UITextField * address = (UITextField *)[cell.contentView viewWithTag:100];
    self.addressT = address;
    UITextField * floorT = (UITextField *)[cell.contentView viewWithTag:101];
    self.floorT = floorT;
    UITextField * doorNumberT = (UITextField *)[cell.contentView viewWithTag:102];
    self.doorNumberT = doorNumberT;
    UITextField * styleT = (UITextField *)[cell.contentView viewWithTag:103];
    self.styleT = styleT;
    UITextField * statusT = (UITextField *)[cell.contentView viewWithTag:104];
    self.statusT = statusT;
    UITextField * chanquanT = (UITextField *)[cell.contentView viewWithTag:105];
    self.chanquanT = chanquanT;
    UITextField * huxingT = (UITextField *)[cell.contentView viewWithTag:106];
    self.huxingT = huxingT;
    UITextField * chaoxiangT = (UITextField *)[cell.contentView viewWithTag:107];
    self.chaoxiangT = chaoxiangT;
    UITextField * zhuangxiuT = (UITextField *)[cell.contentView viewWithTag:108];
    self.zhuangxiuT = zhuangxiuT;
    UITextField * jianzhuAreaT = (UITextField *)[cell.contentView viewWithTag:109];
    jianzhuAreaT.delegate = self;
    jianzhuAreaT.returnKeyType = UIReturnKeyNext;
    self.jianzhuAreaT = jianzhuAreaT;
    UITextField * payAreaT = (UITextField *)[cell.contentView viewWithTag:110];
    payAreaT.delegate = self;
    payAreaT.returnKeyType = UIReturnKeyNext;
    self.payAreaT = payAreaT;
    UITextField * useAreaT = (UITextField *)[cell.contentView viewWithTag:111];
    useAreaT.delegate = self;
    useAreaT.returnKeyType = UIReturnKeyDone;
    useAreaT.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    self.useAreaT = useAreaT;
    UITextField * jiaofangtime = (UITextField *)[cell.contentView viewWithTag:112];
    self.jiaofangtime = jiaofangtime;
    UITextField * jiefangtime = (UITextField *)[cell.contentView viewWithTag:113];
    self.jiefangtime = jiefangtime;
    UITextField * zhuangxiutime = (UITextField *)[cell.contentView viewWithTag:114];
    self.zhuangxiutime = zhuangxiutime;
    if ([self.navTitle isEqualToString:@"编辑物业信息"]) {
        address.text = [NSString stringWithFormat:@"%@－%@",self.dataDic[@"cpname"],self.dataDic[@"buildname"]];
        floorT.text = self.dataDic[@"floornum"];
        doorNumberT.text = self.dataDic[@"housename"];
        styleT.text = self.dataDic[@"housetype"];
        statusT.text = self.dataDic[@"staname"];
        chanquanT.text = self.dataDic[@"houseowner"];
        huxingT.text = self.dataDic[@"unittype"];
        chaoxiangT.text = self.dataDic[@"orient"];
        jianzhuAreaT.text = self.dataDic[@"buildarea"];
        useAreaT.text = self.dataDic[@"userarea"];
        payAreaT.text = self.dataDic[@"feearea"];
        zhuangxiutime.text = self.dataDic[@"zhuangdate"];
        zhuangxiuT.text = self.dataDic[@"zhuangname"];
        jiefangtime.text = self.dataDic[@"acceptdate"];
        jiaofangtime.text = self.dataDic[@""];
        floorT.userInteractionEnabled = NO;
        doorNumberT.userInteractionEnabled = NO;
        address.userInteractionEnabled = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - buttonAction
- (void)allchoose:(UIButton *)button
{
    YYCache * cache = [TJCache shareCache].yyCache;
    NSData * data = (id)[cache objectForKey:@"houseBaseData"];
    NSMutableDictionary * dataDic = [data toDictionary];
    if (button.tag == 120) {
        TJChooseDetailAddressViewController * vc = [[TJChooseDetailAddressViewController alloc] init];
        vc.MyBlock = ^(NSMutableDictionary * dic){
            [self.dataDic removeObjectForKey:@"buildcode"];
            [self.dataDic removeObjectForKey:@"cpcode"];
            self.dataDic[@"buildcode"] = dic[@"buildcode"];
            self.dataDic[@"cpcode"] = dic[@"cpcode"];
            self.addressT.text = [NSString stringWithFormat:@"%@－%@",dic[@"cpname"],dic[@"buildname"]];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 121) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@""];
        for (int i = 0; i < [dataDic[@"hstypelist"] count]; i ++) {
            [array addObject:dataDic[@"hstypelist"][i][@"hstypename"]];
        }
        CGSize s = [@"类        型:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 192+(fifteenS.height - 18)*4/2 - self.scrollY andWidth:133 andHeight:(kScreenHeigth - (64 + 192+(fifteenS.height - 18)*4/2)) andData:array withString:self.styleT.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"housetypeid"];
            [self.dataDic removeObjectForKey:@"hstypename"];
            if ([dic[@"index"] integerValue] == 0) {
                self.styleT.text = @"";
                self.dataDic[@"housetypeid"] = @"";
                self.dataDic[@"hstypename"] = @"";
                return ;
            }
            self.styleT.text = dic[@"label"];
            self.dataDic[@"housetypeid"] = dataDic[@"hstypelist"][[dic[@"index"] integerValue] - 1][@"hstypeid"];
            self.dataDic[@"hstypename"] = dataDic[@"hstypelist"][[dic[@"index"] integerValue] - 1][@"hstypename"];
        }];
    }
    if (button.tag == 122) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@""];
        for (int i = 0; i < [dataDic[@"stalist"] count]; i ++) {
            [array addObject:dataDic[@"stalist"][i][@"staname"]];
        }
        CGSize s = [@"状        态:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 240+(fifteenS.height - 18)*5/2 - self.scrollY andWidth:133 andHeight:(kScreenHeigth - (64 + 240+(fifteenS.height - 18)*5/2)) andData:array withString:self.statusT.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"staid"];
            [self.dataDic removeObjectForKey:@"staname"];
            if ([dic[@"index"] integerValue] == 0) {
                self.statusT.text = @"";
                self.dataDic[@"staid"] = @"";
                self.dataDic[@"staname"] = @"";
                return ;
            }
            self.statusT.text = dic[@"label"];
            self.dataDic[@"staid"] = dataDic[@"stalist"][[dic[@"index"] integerValue] - 1][@"staid"];
            self.dataDic[@"staname"] = dataDic[@"stalist"][[dic[@"index"] integerValue] - 1][@"staname"];
        }];
    }
    if (button.tag == 123) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@""];
        for (int i = 0; i < [dataDic[@"hssalelist"] count]; i ++) {
            [array addObject:dataDic[@"hssalelist"][i][@"hssalename"]];
        }
        CGSize s = [@"产权类型:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 288+(fifteenS.height - 18)*6/2 - self.scrollY andWidth:133 andHeight:34 * 3 andData:array withString:self.chanquanT.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"hssaleid"];
            [self.dataDic removeObjectForKey:@"hssalename"];
            if ([dic[@"index"] integerValue] == 0) {
                self.chanquanT.text = @"";
                self.dataDic[@"hssaleid"] = @"";
                self.dataDic[@"hssalename"] = @"";
                return ;
            }
            self.chanquanT.text = dic[@"label"];
            self.dataDic[@"hssaleid"] = dataDic[@"hssalelist"][[dic[@"index"] integerValue] - 1][@"hssaleid"];
            self.dataDic[@"hssalename"] = dataDic[@"hssalelist"][[dic[@"index"] integerValue] - 1][@"hssalename"];
        }];
    }
    if (button.tag == 124) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@""];
        for (int i = 0; i < [dataDic[@"unitlist"] count]; i ++) {
            [array addObject:dataDic[@"unitlist"][i][@"unittypename"]];
        }
        CGSize s = [@"户        型:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 336+(fifteenS.height - 18)*7/2 - self.scrollY andWidth:133 andHeight:(kScreenHeigth - (64 + 336+(fifteenS.height - 18)*7/2)) andData:array withString:self.huxingT.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"unittypeid"];
            [self.dataDic removeObjectForKey:@"unittypename"];
            if ([dic[@"index"] integerValue] == 0) {
                self.huxingT.text = @"";
                self.dataDic[@"unittypeid"] = @"";
                self.dataDic[@"unittypename"] = @"";
                return ;
            }
            self.huxingT.text = dic[@"label"];
            self.dataDic[@"unittypeid"] = dataDic[@"unitlist"][[dic[@"index"] integerValue] - 1][@"unittypeid"];
            self.dataDic[@"unittypename"] = dataDic[@"unitlist"][[dic[@"index"] integerValue] - 1][@"unittypename"];
        }];
    }
    if (button.tag == 125) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@""];
        for (int i = 0; i < [dataDic[@"orientlist"] count]; i ++) {
            [array addObject:dataDic[@"orientlist"][i][@"orientname"]];
        }
        CGSize s = [@"房屋朝向:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 384+(fifteenS.height - 18)*8/2 - self.scrollY andWidth:133 andHeight:(kScreenHeigth - (64 + 384+(fifteenS.height - 18)*8/2)) andData:array withString:self.chaoxiangT.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"orientid"];
            [self.dataDic removeObjectForKey:@"orientname"];
            if ([dic[@"index"] integerValue] == 0) {
                self.chaoxiangT.text = @"";
                self.dataDic[@"orientid"] = @"";
                self.dataDic[@"orientname"] = @"";
                return ;
            }
            self.chaoxiangT.text = dic[@"label"];
            self.dataDic[@"orientid"] = dataDic[@"orientlist"][[dic[@"index"] integerValue] - 1][@"orientid"];
            self.dataDic[@"orientname"] = dataDic[@"orientlist"][[dic[@"index"] integerValue] - 1][@"orientname"];
        }];
    }
    if (button.tag == 126) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@""];
        for (int i = 0; i < [dataDic[@"zhuanglist"] count]; i ++) {
            [array addObject:dataDic[@"zhuanglist"][i][@"zhuangname"]];
        }
        CGSize s = [@"装修类型:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 432+(fifteenS.height - 18)*9/2 - self.scrollY andWidth:133 andHeight:(kScreenHeigth - (64 + 432+(fifteenS.height - 18)*9/2)) andData:array withString:self.zhuangxiuT.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"zhuangid"];
            if ([dic[@"index"] integerValue] == 0) {
                self.zhuangxiuT.text = @"";
                self.dataDic[@"zhuangid"] = @"";
                self.dataDic[@"zhuangname"] = @"";
                return ;
            }
            self.zhuangxiuT.text = dic[@"label"];
            self.dataDic[@"zhuangid"] = dataDic[@"zhuanglist"][[dic[@"index"] integerValue] - 1][@"zhuangid"];
            self.dataDic[@"zhuangname"] = dataDic[@"zhuanglist"][[dic[@"index"] integerValue] - 1][@"zhuangname"];
        }];
    }
    if (button.tag > 126) {
        self.selectFlag = button.tag - 127;
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
    if (self.selectFlag == 0) {//交房
        self.jiaofangtime.text = self.dater.dateString;
    }
    if (self.selectFlag == 1) {//接房
        self.jiefangtime.text = self.dater.dateString;
    }
    if (self.selectFlag == 2) {//装修
        self.zhuangxiutime.text = self.dater.dateString;
    }
}
- (void)daterViewDidClicked:(XFDaterView *)daterView
{
    //取消
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.scrollY = scrollView.contentOffset.y;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textFlag = textField.tag - 100;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.returnKeyType==UIReturnKeyNext) {
        switch (textField.tag - 100) {
            case 9:
                [self.payAreaT becomeFirstResponder];
                break;
            case 10:
                [self.useAreaT becomeFirstResponder];
                break;
            default:
                break;
        }
    }else {
        self.flag = 0;
        [self.view endEditing:YES];
    }
    return YES;
}

- (void)editKeyboardWillShow:(NSNotification *)aNotification
{
    if (self.textFlag < 9) {
        return;
    }
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    self.tableView.frame = Rect(0, 64 - (480 + (self.textFlag - 9) * 48 + height + (fifteenS.height - 18) * (10 + self.textFlag - 9) / 2) + (kScreenHeigth - 64) - self.scrollY * self.flag, kScreenWidth, kScreenHeigth * 3 / 2);
    self.flag = 1;
}
- (void)editKeyboardWillHide:(NSNotification *)aNotification
{
    self.flag = 0;
    self.tableView.frame = Rect(0, 64, kScreenWidth, kScreenHeigth - 64);
}
#pragma mark - netWorking
- (void)addHousedata
{
    if (self.addressT.text.length == 0) {
        SVShowError(@"请选择楼栋地址!");
        return;
    }
    if (self.floorT.text.length == 0) {
        SVShowError(@"请输入楼层!");
        return;
    }
    if (self.doorNumberT.text.length == 0) {
        SVShowError(@"请输入房号!");
        return;
    }
    if (self.chanquanT.text.length == 0) {
        SVShowError(@"请选择产权!");
        return;
    }
    if (self.jianzhuAreaT.text.length == 0) {
        SVShowError(@"请输入建筑面积!");
        return;
    }
    if (self.payAreaT.text.length == 0) {
        SVShowError(@"请输入收费面积!");
        return;
    }
    NSString * url = [NSString string];
    NSString * showStr = [NSString string];
    if ([self.navTitle isEqualToString:@"编辑物业信息"]) {
        url = @"house/houseedit.jsp";
        showStr = @"修改成功!";
    }else {
        url = @"house/houseadd.jsp";
        showStr = @"添加成功!";
    }
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"houseid"] = self.houseId;
    params[@"cpcode"] = self.dataDic[@"cpcode"];
    params[@"buildcode"] = self.dataDic[@"buildcode"];
    params[@"housename"] = self.doorNumberT.text;
    params[@"housetype"] = self.dataDic[@"housetypeid"];
    params[@"housesta"] = self.dataDic[@"staid"];
    params[@"unittype"] = self.dataDic[@"unittypeid"];
    params[@"orient"] = self.dataDic[@"orientid"];
    params[@"buildarea"] = self.jianzhuAreaT.text;
    params[@"usingarea"] = self.useAreaT.text;
    params[@"feearea"] = self.payAreaT.text;
    params[@"floornum"] = self.floorT.text;
    params[@"zhuangxiu"] = self.dataDic[@"zhuangid"];
    params[@"acceptdate"] = self.jiefangtime.text;
    params[@"zhuangdate"] = self.zhuangxiutime.text;
    params[@"houseowner"] = self.dataDic[@"hssaleid"];
    if ([self.navTitle isEqualToString:@"添加物业"]) {
        [params removeObjectForKey:@"houseid"];
    }
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(showStr);
            if (self.refreshBlock) {
                self.refreshBlock();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
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
@end
