//
//  TJPersonEditDataViewController.m
//  baseXcode
//
//  Created by hangshao on 16/11/29.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJPersonEditDataViewController.h"

@interface TJPersonEditDataViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,XFDaterViewDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   weak) UITextField     * cardno;
@property (nonatomic,   weak) UITextField     * sexy;
@property (nonatomic,   weak) UITextField     * birthday;
@property (nonatomic,   weak) UITextField     * marry;
@property (nonatomic,   weak) UITextField     * hukou;
@property (nonatomic,   weak) UITextField     * address;
@property (nonatomic,   weak) UITextField     * email;
@property (nonatomic,   weak) UITextField     * hometel;
@property (nonatomic,   weak) UITextField     * mobile;
@property (nonatomic,   weak) UITextField     * officetel;
@property (nonatomic,   weak) UITextField     * qq;
@property (nonatomic,   weak) UITextField     * xueli;
@property (nonatomic,   weak) UITextField     * xuexiao;
@property (nonatomic,   assign) CGFloat  scrollY;
@property (nonatomic,   assign) NSInteger  textFlag;
@property (nonatomic,   assign) NSInteger   flag;
@property (nonatomic,   assign) NSInteger   selectFlag;
@property (nonatomic,   strong) XFDaterView * dater;
@end

@implementation TJPersonEditDataViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    YYCache * cache = [TJCache shareCache].yyCache;
    NSData * data = (id)[cache objectForKey:@"personBaseData"];
    NSMutableDictionary * dic = [data toDictionary];
    if ([dic count] == 0) {
        [self loadYUangongBaseData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView];
    
    [self setTableView];
    
    [self setHeaderView];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(personKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(personKeyboardWillHide:)
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
    label.text = self.navTitle;
    label.font = seventeenFont;
    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        [button addTarget:self action:@selector(backAndSureEdit:)];
    }
}
- (void)backAndSureEdit:(UIButton *)button
{
    if (button.tag == 110) {
        [YHNetWork stopTheVcRequset:self];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"是否保存个人信息" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self editPersonData];
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
    return 680 - 13*18 + fifteenS.height * 13;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"TJEditePersonDataMainCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJPersonEditCell" owner:self options:nil] objectAtIndex:0];
    }
    for (int i = 0; i < 13; i ++) {
        UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
        label1.font = fifteenFont;
    }
    for (int i = 0; i < 13; i ++) {
        UITextField * text = (UITextField *)[cell.contentView viewWithTag:100 + i];
        text.font = fifteenFont;
    }
    for (int i = 0; i < 13; i ++) {
        UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
        view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
        view.borderWidth = 0.7;
        view.cornerRadius = 5.0;
    }
    for (int i = 0; i < 5; i ++) {
        UIButton * button = (UIButton *)[cell.contentView viewWithTag:150 + i];
        [button addTarget:self action:@selector(personDataChoose:)];
    }
    UITextField * cardno = (UITextField *)[cell.contentView viewWithTag:100];
    cardno.delegate = self;
    self.cardno = cardno;
    UITextField * sexy = (UITextField *)[cell.contentView viewWithTag:101];
    self.sexy = sexy;
    UITextField * birthday = (UITextField *)[cell.contentView viewWithTag:102];
    self.birthday = birthday;
    UITextField * marry = (UITextField *)[cell.contentView viewWithTag:103];
    self.marry = marry;
    UITextField * hukou = (UITextField *)[cell.contentView viewWithTag:104];
    self.hukou = hukou;
    UITextField * address = (UITextField *)[cell.contentView viewWithTag:105];
    address.delegate = self;
    address.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    self.address = address;
    UITextField * xueli = (UITextField *)[cell.contentView viewWithTag:106];
    self.xueli = xueli;
    UITextField * xuexiao = (UITextField *)[cell.contentView viewWithTag:107];
    xuexiao.delegate = self;
     xuexiao.returnKeyType = UIReturnKeyNext;
    self.xuexiao = xuexiao;
    UITextField * mobile = (UITextField *)[cell.contentView viewWithTag:108];
    mobile.delegate = self;
    mobile.returnKeyType = UIReturnKeyNext;
    mobile.keyboardType = UIKeyboardTypeNumberPad;
    self.mobile = mobile;
    UITextField * officetel = (UITextField *)[cell.contentView viewWithTag:109];
    officetel.delegate = self;
    officetel.returnKeyType = UIReturnKeyNext;
    self.officetel = officetel;
    UITextField * hometel = (UITextField *)[cell.contentView viewWithTag:110];
    hometel.delegate = self;
    hometel.returnKeyType = UIReturnKeyNext;
    self.hometel = hometel;
    UITextField * qq = (UITextField *)[cell.contentView viewWithTag:111];
    qq.delegate = self;
    qq.keyboardType = UIKeyboardTypeNumberPad;
    qq.returnKeyType = UIReturnKeyNext;
    self.qq = qq;
    UITextField * email = (UITextField *)[cell.contentView viewWithTag:112];
    email.delegate = self;
    email.returnKeyType = UIReturnKeyDone;
    email.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    self.email = email;
    cardno.text = self.personOldData[@"baseinfo"][@"cardno"];
    sexy.text = self.personOldData[@"baseinfo"][@"sexy"];
    hukou.text = self.personOldData[@"baseinfo"][@"hukou"];
    marry.text = self.personOldData[@"baseinfo"][@"marry"];
    birthday.text = self.personOldData[@"baseinfo"][@"birthday"];
    address.text = self.personOldData[@"contactinfo"][@"address"];
    email.text = self.personOldData[@"contactinfo"][@"email"];
    hometel.text = self.personOldData[@"contactinfo"][@"hometel"];
    mobile.text = self.personOldData[@"contactinfo"][@"mobile"];
    officetel.text = self.personOldData[@"contactinfo"][@"officetel"];
    qq.text = self.personOldData[@"contactinfo"][@"qq"];
    xueli.text = self.personOldData[@"eduinfo"][@"xueli"];
    xuexiao.text = self.personOldData[@"eduinfo"][@"xuexiao"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return;
}

#pragma mark - buttonAction
- (void)personDataChoose:(UIButton *)button
{
    YYCache * cache = [TJCache shareCache].yyCache;
    NSData * data = (id)[cache objectForKey:@"personBaseData"];
    NSMutableDictionary * dataDic = [data toDictionary];
    if (button.tag == 150) {//性别
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
//        [array addObject:@"未知"];
        for (int i = 0; i < [dataDic[@"sexylist"] count]; i ++) {
            [array addObject:dataDic[@"sexylist"][i][@"sexyname"]];
        }
        CGSize s = [@"性        别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 91+(fifteenS.height - 18)*2-self.scrollY andWidth:133 andHeight:34*array.count andData:array withString:self.sexy.text clickAtIndex:^(NSMutableDictionary * dic) {
//            if ([dic[@"index"] integerValue] == 0) {
//                self.sexy.text = @"未知";
//                self.dataDic[@"sexyid"] = @"";
//                return ;
//            }
            self.sexy.text = dic[@"label"];
            self.dataDic[@"sexyid"] = dataDic[@"sexylist"][[dic[@"index"] integerValue]][@"sexyid"];
        }];
    }
    if (button.tag == 151) {
        self.dater = [[XFDaterView alloc]initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeigth)];
        self.dater.delegate = self;
        [self.dater showInView:self.view animated:YES];
    }
    if (button.tag == 152) {//婚否
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
//        [array addObject:@"未知"];
        for (int i = 0; i < [dataDic[@"marrylist"] count]; i ++) {
            [array addObject:dataDic[@"marrylist"][i][@"marryname"]];
        }
        CGSize s = [@"性        别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 184+(fifteenS.height - 18)*4 -self.scrollY andWidth:133 andHeight:34*array.count andData:array withString:self.marry.text clickAtIndex:^(NSMutableDictionary * dic) {
//            if ([dic[@"index"] integerValue] == 0) {
//                self.marry.text = @"未知";
//                self.dataDic[@"marryid"] = @"";
//                return ;
//            }
            self.marry.text = dic[@"label"];
            self.dataDic[@"marryid"] = dataDic[@"marrylist"][[dic[@"index"] integerValue]][@"marryid"];
        }];
    }
    if (button.tag == 153) {//户籍地
        [[HSChooseCityView sharedInstance] clickAtIndex:^(NSMutableDictionary *dic) {
            if ([dic[@"city"] length] > 0) {
                self.hukou.text = dic[@"city"];
            }
        }];
    }
    if (button.tag == 154) {//学历
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < [dataDic[@"xuelilist"] count]; i ++) {
            [array addObject:dataDic[@"xuelilist"][i][@"xueliname"]];
        }
        CGSize s = [@"性        别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 342+(fifteenS.height - 18)*7-self.scrollY andWidth:133 andHeight:(kScreenHeigth - (64 + 342+(fifteenS.height - 18)*4/2))+self.scrollY andData:array withString:self.xueli.text clickAtIndex:^(NSMutableDictionary * dic) {
            self.xueli.text = dic[@"label"];
            self.dataDic[@"xueliid"] = dataDic[@"xuelilist"][[dic[@"index"] integerValue]][@"xueliid"];
        }];
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
    self.birthday.text = self.dater.dateString;
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
            case 7:
                [self.mobile becomeFirstResponder];
                break;
            case 8:
                [self.officetel becomeFirstResponder];
                break;
            case 9:
                [self.hometel becomeFirstResponder];
                break;
            case 10:
                [self.qq becomeFirstResponder];
                break;
            case 11:
                [self.email becomeFirstResponder];
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
- (void)personKeyboardWillShow:(NSNotification *)aNotification
{
    if (self.textFlag < 5) {
        return;
    }
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    if (self.textFlag == 5) {
        if (kScreenWidth >= 375) {
            return;
        }
         self.tableView.frame = Rect(0, 64 - (272 + (self.textFlag - 5) * 48 + height + (fifteenS.height - 18) * (6 + self.textFlag - 5) / 2) + (kScreenHeigth - 64) - self.scrollY * self.flag, kScreenWidth, kScreenHeigth * 3 / 2);
    }
    if (self.textFlag == 7) {
        self.tableView.frame = Rect(0, 64 - (387 + (self.textFlag - 7) * 48 + height + (fifteenS.height - 18) * (8 + self.textFlag - 7) / 2) + (kScreenHeigth - 64) - self.scrollY * self.flag, kScreenWidth, kScreenHeigth * 3 / 2);
    }
    if (self.textFlag > 7) {
        self.tableView.frame = Rect(0, 64 - (457 + (self.textFlag - 8) * 48 + height + (fifteenS.height - 18) * (9 + self.textFlag - 8) / 2) + (kScreenHeigth - 64) - self.scrollY * self.flag, kScreenWidth, kScreenHeigth * 3 / 2);
    }
    self.flag = 1;
}
- (void)personKeyboardWillHide:(NSNotification *)aNotification
{
    self.flag = 0;
    self.tableView.frame = Rect(0, 64, kScreenWidth, kScreenHeigth - 64);
}
#pragma mark - netWorking
- (void)loadYUangongBaseData
{
    NSString * url = @"hr/clerkdata.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"data"] count] > 0) {
            YYCache * cache = [TJCache shareCache].yyCache;
            [cache removeObjectForKey:@"personBaseData"];
            [cache setObject:[request[@"data"] data] forKey:@"personBaseData"];
        }else {
            [self loadYUangongBaseData];
        }
    } failBlock:^(NSError *error) {
        [self loadYUangongBaseData];
    }];
}
- (void)editPersonData
{
    NSString * sexy = [NSString string];
    if ([self.sexy.text isEqualToString:@"男"]) {
        sexy = @"0";
    }else if ([self.sexy.text isEqualToString:@"女"]) {
        sexy = @"1";
    }else{
        sexy = @"";
    }
    NSString * ismarry = [NSString string];
    if ([self.marry.text isEqualToString:@"未婚"]) {
        ismarry = @"0";
    }else if ([self.marry.text isEqualToString:@"已婚"]) {
        ismarry = @"1";
    }else{
        ismarry = @"";
    }
    NSString * url = @"hr/clerkedit.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"queryclerkid"] = self.personID;
    params[@"sexy"] = sexy;
    params[@"birth"] = self.birthday.text;
    params[@"origin"] = self.hukou.text;
    params[@"ismarry"] = ismarry;
    params[@"cardno"] = self.cardno.text;
    params[@"mobile"] = self.mobile.text;
    params[@"officetel"] = self.officetel.text;
    params[@"hometel"] = self.hometel.text;
    params[@"email"] = self.email.text;
    params[@"qq"] = self.qq.text;
    params[@"postcode"] = @"";
    params[@"address"] = self.address.text;
    params[@"xueli"] = self.xueli.text;
    params[@"xuexiao"] = self.xuexiao.text;
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(@"编辑成功!");
            NSMutableDictionary * baseinfo = [NSMutableDictionary dictionary];
            baseinfo[@"birthday"] = params[@"birth"];
            baseinfo[@"cardno"] = params[@"cardno"];
            baseinfo[@"hukou"] = params[@"origin"];
            baseinfo[@"marry"] = self.marry.text;
            baseinfo[@"sexy"] = self.sexy.text;
            baseinfo[@"clerkname"] = self.personOldData[@"baseinfo"][@"clerkname"];
            NSMutableDictionary * contactinfo = [NSMutableDictionary dictionary];
            contactinfo[@"address"] = params[@"address"];
            contactinfo[@"email"] = params[@"email"];
            contactinfo[@"hometel"] = params[@"hometel"];
            contactinfo[@"mobile"] = params[@"mobile"];
            contactinfo[@"qq"] = params[@"qq"];
            contactinfo[@"officetel"] = params[@"officetel"];
            contactinfo[@"postcode"] = self.personOldData[@"contactinfo"][@"postcode"];
            NSMutableDictionary * eduinfo = [NSMutableDictionary dictionary];
            eduinfo[@"xueli"] = params[@"xueli"];
            eduinfo[@"xuexiao"] = params[@"xuexiao"];
            NSMutableDictionary * dutyinfo = [NSMutableDictionary dictionaryWithDictionary:self.personOldData[@"dutyinfo"]];
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setObject:baseinfo forKey:@"baseinfo"];
            [dic setObject:contactinfo forKey:@"contactinfo"];
            [dic setObject:eduinfo forKey:@"eduinfo"];
            [dic setObject:dutyinfo forKey:@"dutyinfo"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.MyBlock) {
                    self.MyBlock(dic);
                }
                [self.navigationController popViewControllerAnimated: YES];
            });
        }else {
            SVShowError(request[@"err"]);
        }
    } failBlock:^(NSError *error) {
        SVShowError(@"网络错误，请重试!");
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
