//
//  TJEditeYezhuDataViewController.m
//  baseXcode
//
//  Created by hangshao on 16/11/21.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJEditeYezhuDataViewController.h"

@interface TJEditeYezhuDataViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   weak) UITextField     * nameText;
@property (nonatomic,   weak) UITextField     * sexText;
@property (nonatomic,   weak) UITextField     * addressText;
@property (nonatomic,   weak) UITextField     * shenfenzhengText;
@property (nonatomic,   weak) UITextField     * phoneText;
@property (nonatomic,   weak) UITextField     * guhuaText;
@property (nonatomic,   weak) UITextField     * emailText;
@property (nonatomic,   weak) UITextField     * collectAddressText;
@property (nonatomic,   weak) UIButton     * anjieButton;
@property (nonatomic,   weak) UIButton     * firstButton;
@property (nonatomic,   assign) NSInteger  textFlag;

@end

@implementation TJEditeYezhuDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView];
    
    [self setTableView];
    
    [self setHeaderView];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
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
        [button addTarget:self action:@selector(backAndSure:)];
    }
}
- (void)backAndSure:(UIButton *)button
{
    if (button.tag == 110) {
        [YHNetWork stopTheVcRequset:self];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"是否保存业主信息" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self changeYZData];
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
    return 450 + (fifteenS.height - 18) * 9 / 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"TJEditeYezhuMainCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJEditeYezhuCell" owner:self options:nil] firstObject];
    }
    for (int i = 0; i < 11; i ++) {
        UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
        label1.font = fifteenFont;
    }
    for (int i = 0; i < 8; i ++) {
        UITextField * text = (UITextField *)[cell.contentView viewWithTag:100 + i];
        text.font = fifteenFont;
    }
    for (int i = 0; i < 8; i ++) {
        UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
        view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
        view.borderWidth = 0.7;
        view.cornerRadius = 5.0;
    }
    UITextField * name = (UITextField *)[cell.contentView viewWithTag:100];
    name.delegate = self;
    UITextField * sex = (UITextField *)[cell.contentView viewWithTag:101];
    UITextField * address = (UITextField *)[cell.contentView viewWithTag:102];
    UITextField * shenfenzheng = (UITextField *)[cell.contentView viewWithTag:103];
    shenfenzheng.delegate = self;
    UITextField * phone = (UITextField *)[cell.contentView viewWithTag:104];
    phone.returnKeyType = UIReturnKeyNext;
    phone.delegate = self;
    UITextField * guhua = (UITextField *)[cell.contentView viewWithTag:105];
    guhua.returnKeyType = UIReturnKeyNext;
    guhua.delegate = self;
    UITextField * email = (UITextField *)[cell.contentView viewWithTag:106];
    email.returnKeyType = UIReturnKeyNext;
    email.delegate = self;
    UITextField * lianxidizhi = (UITextField *)[cell.contentView viewWithTag:107];
    lianxidizhi.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    lianxidizhi.delegate = self;
    lianxidizhi.returnKeyType = UIReturnKeyDone;
    self.nameText = name;
    self.sexText = sex;
    self.addressText = address;
    self.shenfenzhengText = shenfenzheng;
    self.phoneText = phone;
    self.guhuaText = guhua;
    self.emailText = email;
    self.collectAddressText = lianxidizhi;
    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[cell.contentView viewWithTag:110 + i];
        [button addTarget:self action:@selector(chooseAddressOrSex:)];
    }
    UIButton * anjiebutton = (UIButton *)[cell.contentView viewWithTag:112];
    [anjiebutton addTarget:self action:@selector(anjieAc:)];
    self.anjieButton = anjiebutton;
    UIButton * firstbutton = (UIButton *)[cell.contentView viewWithTag:113];
    [firstbutton addTarget:self action:@selector(firstAc:)];
    self.firstButton = firstbutton;
    if ([self.navTitle isEqualToString:@"编辑业主信息"]) {
        name.text = self.olddataDic[@"ownername"];
        sex.text = self.olddataDic[@"sexy"];
        address.text = self.olddataDic[@"origin"];
        shenfenzheng.text = self.olddataDic[@"cardno"];
        phone.text = self.olddataDic[@"mobile"];
        guhua.text = self.olddataDic[@"tel"];
        email.text = self.olddataDic[@"email"];
        lianxidizhi.text = self.olddataDic[@"address"];
        if ([self.olddataDic[@"anjie"] isEqualToString:@"按揭"]) {
            anjiebutton.selected = YES;
        }
        if ([self.olddataDic[@"isfirst"] isEqualToString:@"首套"]) {
            firstbutton.selected = YES;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - buttonAction
- (void)chooseAddressOrSex:(UIButton *)button
{
    if (button.tag == 110) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@"男"];
        [array addObject:@"女"];
        [array addObject:@"未知"];
        CGSize s = [@"性        别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 96+(fifteenS.height - 18)*2 andWidth:133 andHeight:34*array.count andData:array withString:self.sexText.text clickAtIndex:^(NSMutableDictionary * dic) {
            self.sexText.text = dic[@"label"];
        }];
    } else {
        [[HSChooseCityView sharedInstance] clickAtIndex:^(NSMutableDictionary *dic) {
            if ([dic[@"city"] length] > 0) {
                self.addressText.text = dic[@"city"];
            }
        }];
    }
}
- (void)anjieAc:(UIButton *)button
{
    if (button.selected == NO) {
         button.selected = YES;
        self.anjieButton.selected = YES;
    }else {
         button.selected = NO;
        self.anjieButton.selected = NO;
    }
}
- (void)firstAc:(UIButton *)button
{
    if (button.selected == NO) {
        button.selected = YES;
        self.firstButton.selected = YES;
    }else {
        button.selected = NO;
        self.firstButton.selected = NO;
    }
}

#pragma mark - delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textFlag = textField.tag - 100;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.returnKeyType==UIReturnKeyNext) {
        switch (textField.tag - 100) {
            case 4:
                [self.guhuaText becomeFirstResponder];
                break;
            case 5:
                [self.emailText becomeFirstResponder];
                break;
            case 6:
                [self.collectAddressText becomeFirstResponder];
                break;
            default:
                break;
        }
    }else {
        [self.view endEditing:YES];
    }
    return YES;
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    switch (self.textFlag) {
        case 4://291
            if (kScreenWidth > 320) {
                return;
            }
            self.tableView.frame = Rect(0, 64 - (291 + height + (fifteenS.height - 18) * 5 / 2) + (kScreenHeigth - 64), kScreenWidth, kScreenHeigth - 64);
            break;
        case 5://339
            if (kScreenWidth > 375) {
                return;
            }
            self.tableView.frame = Rect(0, 64 - (339 + height + (fifteenS.height - 18) * 6 / 2) + (kScreenHeigth - 64), kScreenWidth, kScreenHeigth - 64);
            break;
        case 6://387
            self.tableView.frame = Rect(0, 64 - (387 + height + (fifteenS.height - 18) * 7 / 2) + (kScreenHeigth - 64), kScreenWidth, kScreenHeigth - 64);
            break;
        case 7://435
            self.tableView.frame = Rect(0, 64 - (435 + height + (fifteenS.height - 18) * 8 / 2) + (kScreenHeigth - 64), kScreenWidth, kScreenHeigth - 64);
            break;
        default:
            break;
    }
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.tableView.frame = Rect(0, 64, kScreenWidth, kScreenHeigth - 64);
}

#pragma mark - netWorking
- (void)changeYZData
{
    if (self.nameText.text.length == 0) {
        SVShowError(@"请输入业主姓名!");
        return;
    }
    NSString * anjie = [NSString string];
    if (self.anjieButton.selected == YES) {
        anjie = @"1";
    } else {
        anjie = @"0";
    }
    NSString * isfirst = [NSString string];
    if (self.firstButton.selected == YES) {
        isfirst = @"0";
    } else {
        isfirst = @"1";
    }
    NSString * str = [NSString string];
    NSString * url = [NSString string];
    NSString * ownerid = [NSString string];
    if ([self.navTitle isEqualToString:@"编辑业主信息"]) {
        url = @"house/owneredit.jsp";
        str = @"修改成功";
        ownerid = self.olddataDic[@"ownerid"];
    }else {
        url = @"house/owneradd.jsp";
        str = @"添加成功";
        ownerid = @"";
    }
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"houseid"] = self.houseId;
    params[@"ownerid"] = ownerid;
    params[@"ownername"] = self.nameText.text;
    params[@"sexy"] = self.sexText.text;
    params[@"mobile"] = self.phoneText.text;
    params[@"tel"] = self.guhuaText.text;
    params[@"address"] = self.addressText.text;
    params[@"email"] = self.emailText.text;
    params[@"cardno"] = self.shenfenzhengText.text;
    params[@"origin"] = self.collectAddressText.text;
    params[@"anjie"] = anjie;
    params[@"isfirst"]= isfirst;
    if ([self.navTitle isEqualToString:@"业主"]) {
        [params removeObjectForKey:@"ownerid"];
    }
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(str);
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:params];
            [dic removeObjectForKey:@"anjie"];
            [dic removeObjectForKey:@"isfirst"];
            if (self.anjieButton.selected == YES) {
                dic[@"anjie"] = @"按揭";
            } else {
                dic[@"anjie"] = @"";
            }
            if (self.firstButton.selected == YES) {
                dic[@"isfirst"] = @"首套";
            } else {
                dic[@"isfirst"] = @"";
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.MyBlock) {
                    self.MyBlock(dic);
                }
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            SVShowError(request[@"err"]);
        }
    } failBlock:^(NSError *error) {
        SVShowError(@"网络连接错误，请检查您的网络!");
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
