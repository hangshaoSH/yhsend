//
//  TJAddRepaireViewController.m
//  baseXcode
//
//  Created by hangshao on 16/12/2.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJAddRepaireViewController.h"
#import "TJChooseDetailAddressMenViewController.h"
#import "TJChooseOrderpeopleViewController.h"
@interface TJAddRepaireViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,CuiPickViewDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   assign) NSInteger  selectFlag;
@property (nonatomic,   weak) UITextView     * contentT;
@property (nonatomic,   weak) UILabel     * placeholderL;
@property (nonatomic,   weak) UITextField     * style;
@property (nonatomic,   weak) UITextField     * fangshi;
@property (nonatomic,   weak) UITextField     * zhonglei;
@property (nonatomic,   weak) UITextField     * address;
@property (nonatomic,   weak) UITextField     * baoxiutime;
@property (nonatomic,   weak) UITextField     * peoplejiedan;
@property (nonatomic,   weak) UITextField     * jiedantime;
@property (nonatomic,   weak) UITextField     * weixiutime;
@property (nonatomic,   weak) UITextField     * baoxiupeople;
@property (nonatomic,   weak) UITextField     * phone;
@property (nonatomic,   assign) CGFloat  scrollY;
@property (nonatomic,   assign) NSInteger  textFlag;
@property (nonatomic,   assign) NSInteger   flag;
@property (nonatomic, strong) CuiPickerView *cuiPickerView;
@property (nonatomic,   assign) NSInteger  touchFlag;
@property (nonatomic,   weak) UIView     * bgview;
@property (nonatomic,   assign) NSInteger   choostime;
@property (nonatomic,   assign) NSInteger   choostime1;
@end

@implementation TJAddRepaireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView];
    
    [self setTableView];
    
    [self setHeaderView];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addKeyboardWillHide:)
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
    label.text = @"添加报修单";
    label.font = seventeenFont;
    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        [button addTarget:self action:@selector(backAndSureAdd:)];
    }
}
- (void)backAndSureAdd:(UIButton *)button
{
    if (button.tag == 110) {
        [YHNetWork stopTheVcRequset:self];
        if (self.MyBlock) {
            self.MyBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.style.text.length == 0) {
            SVShowError(@"请选择类型!");
            return;
        }
        if (self.fangshi.text.length == 0) {
            SVShowError(@"请选择方式!");
            return;
        }
        if (self.zhonglei.text.length == 0) {
            SVShowError(@"请选择种类!");
            return;
        }
        if (self.contentT.text.length == 0) {
            SVShowError(@"请输入报修内容　！");
            return;
        }
        if (self.address.text.length == 0) {
            SVShowError(@"请选择地址!");
            return;
        }
        if (self.baoxiutime.text.length == 0) {
            SVShowError(@"请选择报修时间!");
            return;
        }
        if (self.baoxiupeople.text.length == 0) {
            SVShowError(@"请填写报修人姓名!");
            return;
        }
        if (self.phone.text.length == 0) {
            SVShowError(@"请填写报修人电话!");
            return;
        }
        [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"信息提交后将不能修改，是否提交?" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self addbaoxiudan];
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
    if (self.selectFlag == 1) {
        return 688 - 10*18+11*fifteenS.height;
    }
    return 485 + 50 - 7*18+8*fifteenS.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"TJRepairSearchCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepairMainCell" owner:self options:nil] objectAtIndex:1];
    }
    for (int i = 0; i < 10; i ++) {
        UITextField * text = (UITextField *)[cell.contentView viewWithTag:100 + i];
        text.font = fifteenFont;
    }
    for (int i = 0; i < 12; i ++) {
        UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
        label1.font = fifteenFont;
    }
    for (int i = 0; i < 11; i ++) {
        UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
        view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
        view.borderWidth = 1.0;
        view.cornerRadius = 5.0;
    }
    UILabel * placeholderL = (UILabel *)[cell.contentView viewWithTag:150];
    placeholderL.font = fifteenFont;
    placeholderL.textColor = [UIColor lightGrayColor];
    self.placeholderL = placeholderL;
    UITextView * contentT = (UITextView *)[cell.contentView viewWithTag:99];
    contentT.font = fifteenFont;
    contentT.delegate = self;
    self.contentT = contentT;
    for (int i = 0; i < 8; i ++) {
        UIButton * edite = (UIButton *)[cell.contentView viewWithTag:110 + i];
        [edite addTarget:self action:@selector(allRepairButAc:)];
    }
    UIView * bgview = (UIView *)[cell.contentView viewWithTag:400];
    UIView * lineview = (UIView *)[cell.contentView viewWithTag:311];
    UISwitch * switchB = (UISwitch *)[cell.contentView viewWithTag:118];
    [switchB addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    if (self.selectFlag == 1) {
        bgview.hidden = NO;
        lineview.hidden = YES;
        switchB.on = YES;
    } else {
        bgview.hidden = YES;
        lineview.hidden = NO;
        switchB.on = NO;
    }
    UITextField * style = (UITextField *)[cell.contentView viewWithTag:100];
    self.style = style;
    UITextField * fangshi = (UITextField *)[cell.contentView viewWithTag:101];
    self.fangshi = fangshi;
    UITextField * zhonglei = (UITextField *)[cell.contentView viewWithTag:102];
    self.zhonglei = zhonglei;
    UITextField * address = (UITextField *)[cell.contentView viewWithTag:104];
    self.address = address;
    UITextField * baoxiutime = (UITextField *)[cell.contentView viewWithTag:105];
    self.baoxiutime = baoxiutime;
    UITextField * baoxiupeople = (UITextField *)[cell.contentView viewWithTag:106];
    baoxiupeople.delegate = self;
    baoxiupeople.returnKeyType = UIReturnKeyNext;
    self.baoxiupeople = baoxiupeople;
    UITextField * phone = (UITextField *)[cell.contentView viewWithTag:107];
    phone.delegate = self;
    phone.keyboardType = UIKeyboardTypeNumberPad;
    phone.returnKeyType = UIReturnKeyDone;
    self.phone = phone;
    UITextField * peoplejiedan = (UITextField *)[cell.contentView viewWithTag:108];
    self.peoplejiedan = peoplejiedan;
    UITextField * jiedantime = (UITextField *)[cell.contentView viewWithTag:109];
    
    self.jiedantime = jiedantime;
    UITextField * weixiutime = (UITextField *)[cell.contentView viewWithTag:103];
    self.weixiutime = weixiutime;
    if (self.choostime != 1) {
        baoxiutime.text = [[User sharedUser] getNowTimeHaveHM];
    }
    if (self.choostime1 != 1) {
        jiedantime.text = [[User sharedUser] getNowTimeHaveHM];
    }
    if (self.jumpFlag == 1) {
        style.text = self.jumpDic[@"modname"];
        fangshi.text = self.jumpDic[@"typename"];
        zhonglei.text = self.jumpDic[@"ordertypename"];
        contentT.text = self.jumpDic[@"msgcontent"];
        address.text = self.jumpDic[@"housename"];
        baoxiutime.text = self.jumpDic[@"calltime"];;
        baoxiupeople.text = self.jumpDic[@"callname"];;
        phone.text = self.jumpDic[@"calltel"];
        self.dataDic[@"cpcode"] = self.jumpDic[@"cpcode"];
        self.dataDic[@"houseid"] = self.jumpDic[@"houseid"];
        self.dataDic[@"ordertypeid"] = self.jumpDic[@"ordertype"];
        self.dataDic[@"modid"] = self.jumpDic[@"modid"];
        self.dataDic[@"typeid"] = self.jumpDic[@"calltype"];
        placeholderL.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return;
}

#pragma mark - buttonAction
- (void)switchAction:(UISwitch *)sender
{
    if (sender.on == YES) {
        self.selectFlag = 1;
        self.tableView.contentOffset = CGPointMake(0, 184);
    } else {
        self.selectFlag = 0;
        self.tableView.contentOffset = CGPointMake(0, 31);
    }
    [self.tableView reloadData];
}
- (void)allRepairButAc:(UIButton *)button
{
    YYCache * cache = [TJCache shareCache].yyCache;
    NSData * data = (id)[cache objectForKey:@"baoxiuBaseData"];
    NSMutableDictionary * dataDic = [data toDictionary];
    if (button.tag == 110) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < [dataDic[@"modlist"] count]; i ++) {
            [array addObject:dataDic[@"modlist"][i][@"modname"]];
        }
        CGSize s = [@"性        别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 48+(fifteenS.height - 18)*1/2 andWidth:133 andHeight:(kScreenHeigth - (64 + 48+(fifteenS.height - 18)*1/2)) andData:array withString:self.style.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"modid"];
            [self.dataDic removeObjectForKey:@"modname"];
            self.style.text = dic[@"label"];
            self.dataDic[@"modid"] = dataDic[@"modlist"][[dic[@"index"] integerValue]][@"modid"];
            self.dataDic[@"modname"] = dataDic[@"modlist"][[dic[@"index"] integerValue]][@"modname"];
        }];
    }
    if (button.tag == 111) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < [dataDic[@"calltypelist"] count]; i ++) {
            [array addObject:dataDic[@"calltypelist"][i][@"typename"]];
        }
        CGSize s = [@"性        别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 96+(fifteenS.height - 18)*2/2 andWidth:133 andHeight:34 * 3 andData:array withString:self.fangshi.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"typeid"];
            [self.dataDic removeObjectForKey:@"typename"];
            self.fangshi.text = dic[@"label"];
            self.dataDic[@"typeid"] = dataDic[@"calltypelist"][[dic[@"index"] integerValue]][@"typeid"];
            self.dataDic[@"typename"] = dataDic[@"calltypelist"][[dic[@"index"] integerValue]][@"typename"];
        }];
    }
    if (button.tag == 112) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < [dataDic[@"ordertypelist"] count]; i ++) {
            [array addObject:dataDic[@"ordertypelist"][i][@"ordertypename"]];
        }
        CGSize s = [@"性        别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 144+(fifteenS.height - 18)*3/2 andWidth:133 andHeight:34 * 2 andData:array withString:self.zhonglei.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"ordertypeid"];
            [self.dataDic removeObjectForKey:@"ordertypename"];
            self.zhonglei.text = dic[@"label"];
            self.dataDic[@"ordertypeid"] = dataDic[@"ordertypelist"][[dic[@"index"] integerValue]][@"ordertypeid"];
            self.dataDic[@"ordertypename"] = dataDic[@"ordertypelist"][[dic[@"index"] integerValue]][@"ordertypename"];
        }];
    }
    if (button.tag == 113) {
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
    self.touchFlag = button.tag - 110;
    if (button.tag == 114 || button.tag > 115) {
        UIView * bgview = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeigth)];
        bgview.backgroundColor = [UIColor blackColor];
        bgview.alpha = 0.2;
        [[UIApplication sharedApplication].keyWindow addSubview:bgview];
        self.bgview = bgview;
        
        _cuiPickerView = [[CuiPickerView alloc]init];
        _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
        _cuiPickerView.backgroundColor = [UIColor whiteColor];
        if (button.tag == 114) {
            self.choostime = 1;
            _cuiPickerView.myTextField = self.baoxiutime;
            _cuiPickerView.string = self.baoxiutime.text;
        }
        if (button.tag == 116) {
            self.choostime1 = 1;
            _cuiPickerView.myTextField = self.jiedantime;
            _cuiPickerView.string = self.jiedantime.text;
        }
        if (button.tag == 117) {
            _cuiPickerView.myTextField = self.weixiutime;
            _cuiPickerView.string = self.weixiutime.text;
        }
        _cuiPickerView.delegate = self;
        _cuiPickerView.curDate=[NSDate date];
        [[UIApplication sharedApplication].keyWindow addSubview:_cuiPickerView];
        [_cuiPickerView showInView:[UIApplication sharedApplication].keyWindow];
    }
    if (button.tag == 115) {
        TJChooseOrderpeopleViewController * vc = [[TJChooseOrderpeopleViewController alloc] init];
        vc.MyBlock = ^(NSMutableDictionary * dic){
            if ([self.dataDic.allKeys containsObject:@"clerkid"]) {
                [self.dataDic removeObjectForKey:@"clerkid"];
            }
            self.dataDic[@"clerkid"] = dic[@"clerkid"];
            self.peoplejiedan.text = dic[@"clerkname"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - delete
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.scrollY = scrollView.contentOffset.y;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeholderL.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.placeholderL.hidden = YES;
    } else {
        self.placeholderL.hidden = NO;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textFlag = textField.tag - 100;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.returnKeyType==UIReturnKeyNext) {
        switch (textField.tag - 100) {
            case 6:
                [self.phone becomeFirstResponder];
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
- (void)addKeyboardWillShow:(NSNotification *)aNotification
{
    if (self.textFlag < 6) {
        return;
    }
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    self.tableView.frame = Rect(0, 64 - (428 + (self.textFlag - 6) * 48 + height + (fifteenS.height - 18) * (7 + self.textFlag - 6) / 2) + (kScreenHeigth - 64) - self.scrollY * self.flag, kScreenWidth, kScreenHeigth * 3 / 2);
    self.flag = 1;
}
- (void)addKeyboardWillHide:(NSNotification *)aNotification
{
    self.flag = 0;
    self.tableView.frame = Rect(0, 64, kScreenWidth, kScreenHeigth - 64);
}
- (void)didFinishPickView:(NSString *)date
{
    if (self.touchFlag == 4) {
        self.baoxiutime.text = date;
        if (date.length == 0) {
            self.baoxiutime.text = [[User sharedUser] getNowTimeHaveHM];
        }
    }
    if (self.touchFlag == 6) {
        self.jiedantime.text = date;
        if (date.length == 0) {
            self.jiedantime.text = [[User sharedUser] getNowTimeHaveHM];
        }
    }
    if (self.touchFlag == 7) {
        self.weixiutime.text = date;
        if (date.length == 0) {
            self.weixiutime.text = [[User sharedUser] getNowTimeHaveHM];
        }
    }
    [self.bgview removeFromSuperview];
    self.bgview = nil;
}
- (void)hiddenPickerView
{
    [self.bgview removeFromSuperview];
    self.bgview = nil;
}
#pragma mark - netWorking
- (void)addbaoxiudan
{
    NSString * acceptclerk = [NSString string];
    NSString * accepttime = [NSString string];
    NSString * yufinishtime = [NSString string];
    NSString * memberid = [NSString string];
    NSString * orderid = [NSString string];
    if (self.jumpFlag == 1) {
        memberid = self.jumpDic[@"memberid"];
        orderid = self.jumpDic[@"orderid"];
    } else {
        memberid = @"";
        orderid = @"";
    }
    if (self.selectFlag == 1) {
        if (self.peoplejiedan.text.length == 0) {
            SVShowError(@"请选择接单人!");
            return;
        }
        if (self.weixiutime.text.length == 0) {
            SVShowError(@"请选择维修时间!");
            return;
        }
        acceptclerk = self.dataDic[@"clerkid"];
        accepttime = self.jiedantime.text;
        yufinishtime = self.weixiutime.text;
    } else {
        acceptclerk = @"";
        accepttime = @"";
        yufinishtime = @"";
    }
    NSString * url = @"wuye/mendbilladd.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"cpcode"] = self.dataDic[@"cpcode"];
    params[@"memberid"] = memberid;
    params[@"orderid"] = orderid;
    params[@"houseid"] = self.dataDic[@"houseid"];
    params[@"ordertype"] = self.dataDic[@"ordertypeid"];
    params[@"modid"] = self.dataDic[@"modid"];
    params[@"mendcontent"] = self.contentT.text;
    params[@"callname"] = self.baoxiupeople.text;
    params[@"calltel"] = self.phone.text;
    params[@"calltime"] = self.baoxiutime.text;
    params[@"calltype"] = self.dataDic[@"typeid"];
    params[@"isaccept"] = @(self.selectFlag);
    params[@"acceptclerk"] = acceptclerk;
    params[@"accepttime"] = accepttime;
    params[@"yufinishtime"] = yufinishtime;
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            if (self.jumpFlag == 1) {
                SVShowSuccess(@"处理成功!");
            } else {
                SVShowSuccess(@"添加成功!");
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.MyBlock) {
                    self.MyBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
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
