//
//  TJAddElseComplaintViewController.m
//  baseXcode
//
//  Created by hangshao on 16/12/14.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJAddElseComplaintViewController.h"
#import "TJChooseOrderpeopleViewController.h"
#import "TJChooseAddressViewController.h"
#import "TJChooseDetailAddressMenViewController.h"

@interface TJAddElseComplaintViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,CuiPickViewDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   weak) UILabel     * placeholderL;
@property (nonatomic,   weak) UITextView     * contentT;
@property (nonatomic,   weak) UITextField     * style;
@property (nonatomic,   weak) UITextField     * xiaoqu;
@property (nonatomic,   weak) UITextField     * titleT;
@property (nonatomic,   weak) UITextField     * complaintTime;
@property (nonatomic,   weak) UITextField     * finishTime;
@property (nonatomic,   weak) UITextField     * iscomplaintPeople;
@property (nonatomic,   weak) UITextField     * WYAddress;
@property (nonatomic,   weak) UITextField     * nameT;
@property (nonatomic,   weak) UITextField     * phoeT;
@property (nonatomic,   weak) UITextField     * complaintPeople;
@property (nonatomic,   weak) UITextField     * elseWYAddress;
@property (nonatomic,   weak) UITextField     * elsenameT;
@property (nonatomic,   weak) UITextField     * elsephoeT;
@property (nonatomic,   assign) NSInteger   chooseTime;
@property (nonatomic,   assign) CGFloat  scrollY;
@property (nonatomic,   assign) NSInteger  textFlag;
@property (nonatomic,   assign) NSInteger   flag;
@property (nonatomic, strong) CuiPickerView *cuiPickerView;
@property (nonatomic,   assign) NSInteger  touchFlag;
@property (nonatomic,   weak) UIView     * bgview;
@end

@implementation TJAddElseComplaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableView];
    
    [self setHeaderView];
    
    [self loadComplaintBaseData];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addElseKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addElseKeyboardWillHide:)
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
    label.text = @"添加投诉单";
    label.font = seventeenFont;
    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        [button addTarget:self action:@selector(backAndComplaint:)];
    }
}
- (void)backAndComplaint:(UIButton *)button
{
    if (button.tag == 110) {
        [YHNetWork stopTheVcRequset:self];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.style.text.length == 0) {
            SVShowError(@"请选择投诉类型!");
            return;
        }
        if (self.xiaoqu.text.length == 0) {
            SVShowError(@"请选择投诉小区!");
            return;
        }
        if (self.titleT.text.length == 0) {
            SVShowError(@"请输入投诉标题!");
            return;
        }
        if (self.contentT.text.length == 0) {
            SVShowError(@"请输入投诉内容!");
            return;
        }
        if (self.finishTime.text.length == 0) {
            SVShowError(@"请选择预计完成时间!");
            return;
        }
        if (self.iscomplaintPeople.text.length == 0) {
            SVShowError(@"请选择被投诉人类型!");
            return;
        }
        if (self.nameT.text.length == 0) {
            SVShowError(@"请输入被投诉人姓名!");
            return;
        }
        if (self.phoeT.text.length == 0) {
            SVShowError(@"请输入被投诉人电话!");
            return;
        }
        if (self.complaintPeople.text.length == 0) {
            SVShowError(@"请选择投诉人类型!");
            return;
        }
        if (self.elseWYAddress.text.length == 0) {
            SVShowError(@"请选择投诉人的物业地址!");
            return;
        }
        if (self.elsenameT.text.length == 0) {
            SVShowError(@"请选择投诉员工!");
            return;
        }
        if (self.elsephoeT.text.length == 0) {
            SVShowError(@"请输入投诉人电话!");
            return;
        }
        [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"信息提交后将不能修改，是否提交?" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self addComplaintAc];
            }
        }];
    }
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
    return 744+13*fifteenS.height - 12 * 18;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"TJElseAddCpomplainCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJCpomplainMainCell" owner:self options:nil] objectAtIndex:2];
    }
    for (int i = 0; i < 12; i ++) {
        UITextField * text = (UITextField *)[cell.contentView viewWithTag:100 + i];
        text.font = fifteenFont;
    }
    for (int i = 0; i < 13; i ++) {
        UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
        label1.font = fifteenFont;
    }
    for (int i = 0; i < 13; i ++) {
        UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
        view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
        view.borderWidth = 1.0;
        view.cornerRadius = 5.0;
    }
    UILabel * placeholderL = (UILabel *)[cell.contentView viewWithTag:98];
    placeholderL.font = fifteenFont;
    placeholderL.textColor = [UIColor lightGrayColor];
    self.placeholderL = placeholderL;
    UITextView * contentT = (UITextView *)[cell.contentView viewWithTag:99];
    contentT.font = fifteenFont;
    contentT.delegate = self;
    self.contentT = contentT;
    for (int i = 0; i < 7; i ++) {
        UIButton * edite = (UIButton *)[cell.contentView viewWithTag:150 + i];
        [edite addTarget:self action:@selector(allComplaintButAc:)];
    }
    UITextField * style = (UITextField *)[cell.contentView viewWithTag:100];
    self.style = style;
    UITextField * xiaoqu = (UITextField *)[cell.contentView viewWithTag:101];
    self.xiaoqu = xiaoqu;
    UITextField * titleT = (UITextField *)[cell.contentView viewWithTag:102];
    self.titleT = titleT;
    UITextField * complaintTime = (UITextField *)[cell.contentView viewWithTag:103];
    self.complaintTime = complaintTime;
    UITextField * finishTime = (UITextField *)[cell.contentView viewWithTag:104];
    self.finishTime = finishTime;
    UITextField * iscomplaintPeople = (UITextField *)[cell.contentView viewWithTag:105];
    self.iscomplaintPeople = iscomplaintPeople;
    UITextField * nameT = (UITextField *)[cell.contentView viewWithTag:106];
    nameT.delegate = self;
    nameT.returnKeyType = UIReturnKeyNext;
    nameT.inputAccessoryView  = [SLInputAccessoryView inputAccessoryView];
    self.nameT = nameT;
    UITextField * phoeT = (UITextField *)[cell.contentView viewWithTag:107];
    phoeT.delegate = self;
    phoeT.returnKeyType = UIReturnKeyDone;
    phoeT.keyboardType = UIKeyboardTypeNumberPad;
    phoeT.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    self.phoeT = phoeT;
    UITextField * complaintPeople = (UITextField *)[cell.contentView viewWithTag:108];
    self.complaintPeople = complaintPeople;
    UITextField * elseWYAddress = (UITextField *)[cell.contentView viewWithTag:109];
    self.elseWYAddress = elseWYAddress;
    UITextField * elsenameT = (UITextField *)[cell.contentView viewWithTag:110];
    elsenameT.delegate = self;
    elsenameT.returnKeyType = UIReturnKeyNext;
    self.elsenameT = elsenameT;
    UITextField * elsephoeT = (UITextField *)[cell.contentView viewWithTag:111];
    elsephoeT.keyboardType = UIKeyboardTypeNumberPad;
    elsephoeT.delegate = self;
    elsephoeT.returnKeyType = UIReturnKeyDone;
    self.elsephoeT = elsephoeT;
    if (self.chooseTime == 0) {
        complaintTime.text = [[User sharedUser] getNowTimeHaveHM];
    }
    if (self.jumpFlag == 1) {
        style.text = self.jumpDic[@"modname"];
        xiaoqu.text = self.jumpDic[@"cpname"];
        titleT.text = @"";
        contentT.text = self.jumpDic[@"msgcontent"];
        complaintTime.text = [[User sharedUser] getNowTimeHaveHM];
        finishTime.text = @"";
        iscomplaintPeople.text = self.jumpDic[@"totypename"];
        nameT.text = self.jumpDic[@"tocallname"];
        phoeT.text = self.jumpDic[@"tocalltel"];
        complaintPeople.text = self.jumpDic[@"fromtypename"];
        elseWYAddress.text = self.jumpDic[@"fromname"];
        elsenameT.text = self.jumpDic[@"callname"];
        elsephoeT.text = self.jumpDic[@"calltel"];
        self.dataDic[@"cpcode"] = self.jumpDic[@"cpcode"];
        self.dataDic[@"fromtype"] = self.jumpDic[@"fromtype"];
        self.dataDic[@"fromhouseid"] = self.jumpDic[@"fromid"];
        self.dataDic[@"totype"] = self.jumpDic[@"totype"];
        self.dataDic[@"tohouseid"] = self.jumpDic[@"toid"];
        self.dataDic[@"modid"] = self.jumpDic[@"modid"];
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
- (void)allComplaintButAc:(UIButton *)button
{
    YYCache * cache = [TJCache shareCache].yyCache;
    NSData * data = (id)[cache objectForKey:@"complaintBaseData"];
    NSMutableDictionary * dataDic = [data toDictionary];
    if (button.tag == 150) {
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
    if (button.tag == 151) {
        TJChooseAddressViewController * vc = [[TJChooseAddressViewController alloc] init];
        vc.MyBlock= ^(NSMutableDictionary * dic){
            self.xiaoqu.text = dic[@"cpname"];
            [self.dataDic removeObjectForKey:@"cpcode"];
            self.dataDic[@"cpcode"] = dic[@"cpcode"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 152 || button.tag == 153) {
        UIView * bgview = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeigth)];
        bgview.backgroundColor = [UIColor blackColor];
        bgview.alpha = 0.2;
        [[UIApplication sharedApplication].keyWindow addSubview:bgview];
        self.bgview = bgview;
        
        _cuiPickerView = [[CuiPickerView alloc]init];
        _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
        _cuiPickerView.backgroundColor = [UIColor whiteColor];
        if (button.tag == 152) {
            self.chooseTime = 1;
            self.touchFlag = 2;
            _cuiPickerView.myTextField = self.complaintTime;
            _cuiPickerView.string = self.complaintTime.text;
        }
        if (button.tag == 153) {
            self.touchFlag = 3;
            _cuiPickerView.myTextField = self.finishTime;
            _cuiPickerView.string = self.finishTime.text;
        }
        _cuiPickerView.delegate = self;
        _cuiPickerView.curDate=[NSDate date];
        [[UIApplication sharedApplication].keyWindow addSubview:_cuiPickerView];
        [_cuiPickerView showInView:[UIApplication sharedApplication].keyWindow];
    }
    if (button.tag == 154) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < [dataDic[@"totypelist"] count]; i ++) {
            [array addObject:dataDic[@"totypelist"][i][@"totypename"]];
        }
        CGSize s = [@"性别性别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 429+(fifteenS.height - 18)*7/2 - self.scrollY andWidth:133 andHeight:34 * 3 andData:array withString:self.iscomplaintPeople.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"totype"];
            [self.dataDic removeObjectForKey:@"totypename"];
            self.iscomplaintPeople.text = dic[@"label"];
            self.dataDic[@"totype"] = dataDic[@"totypelist"][[dic[@"index"] integerValue]][@"totypeid"];
            self.dataDic[@"totypename"] = dataDic[@"totypelist"][[dic[@"index"] integerValue]][@"totypename"];
        }];
    }
    if (button.tag == 155) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < [dataDic[@"totypelist"] count]; i ++) {
            [array addObject:dataDic[@"totypelist"][i][@"totypename"]];
        }
        CGSize s = [@"投  诉 人:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 590+(fifteenS.height - 18)*10/2 - self.scrollY andWidth:133 andHeight:(kScreenHeigth - (64 + 590+(fifteenS.height - 18)*10/2 - self.scrollY)) andData:array withString:self.complaintPeople.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"fromtype"];
            [self.dataDic removeObjectForKey:@"totypename"];
            self.complaintPeople.text = dic[@"label"];
            self.dataDic[@"fromtype"] = dataDic[@"totypelist"][[dic[@"index"] integerValue]][@"totypeid"];
            self.dataDic[@"totypename"] = dataDic[@"totypelist"][[dic[@"index"] integerValue]][@"totypename"];
        }];
    }
    if (button.tag == 156) {
        TJChooseDetailAddressMenViewController * vc = [[TJChooseDetailAddressMenViewController alloc] init];
        vc.MyBlock= ^(NSMutableDictionary * dic){
            self.elseWYAddress.text = [NSString stringWithFormat:@"%@%@%@",dic[@"cpname"],dic[@"buildname"],dic[@"housename"]];
            [self.dataDic removeObjectForKey:@"fromhouseid"];
            self.dataDic[@"fromhouseid"] = dic[@"houseid"];
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType==UIReturnKeyNext) {
        switch (textField.tag - 100) {
            case 6:
                [self.phoeT becomeFirstResponder];
                break;
            case 10:
                [self.elsephoeT becomeFirstResponder];
                break;
            default:
                break;
        }
    } else {
         [self.view endEditing:YES];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textFlag = textField.tag - 100;
}
- (void)addElseKeyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    if (self.textFlag == 6 || self.textFlag == 7 || self.textFlag == 10 || self.textFlag == 11) {
        if (self.textFlag >= 6) {
            self.tableView.frame = Rect(0, 64 - (477 + (self.textFlag - 6) * 48 + height + (fifteenS.height - 18) * (8 + self.textFlag - 6) / 2) + (kScreenHeigth - 64) - self.scrollY * self.flag, kScreenWidth, kScreenHeigth * 3 / 2);
        }
        if (self.textFlag >= 10) {
            self.tableView.frame = Rect(0, 64 - (686 + (self.textFlag - 10) * 48 + height + (fifteenS.height - 18) * (12 + self.textFlag - 10) / 2) + (kScreenHeigth - 64) - self.scrollY * self.flag, kScreenWidth, kScreenHeigth * 3 / 2);
        }
        self.flag = 1;
    }
}
- (void)addElseKeyboardWillHide:(NSNotification *)aNotification
{
    if (self.textFlag == 6 || self.textFlag == 7 || self.textFlag == 10 || self.textFlag == 11) {
        self.flag = 0;
        self.tableView.frame = Rect(0, 64, kScreenWidth, kScreenHeigth-64);
        self.tableView.contentOffset = CGPointMake(0, 162);
        self.textFlag = 0;
    }
}
- (void)didFinishPickView:(NSString *)date
{
    if (self.touchFlag == 2) {
        self.complaintTime.text = date;
        if (date.length == 0) {
            self.complaintPeople.text = [[User sharedUser] getNowTimeHaveHM];
        }
    }
    if (self.touchFlag == 3) {
        self.finishTime.text = date;
        if (date.length == 0) {
            self.finishTime.text = [[User sharedUser] getNowTimeHaveHM];
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
- (void)loadComplaintBaseData
{
    NSString * url = @"wuye/tsdata.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            if ([request[@"data"] count] > 0) {
                YYCache * cache = [TJCache shareCache].yyCache;
                [cache removeObjectForKey:@"complaintBaseData"];
                [cache setObject:[request[@"data"] data] forKey:@"complaintBaseData"];
            }else {
                
            }
        }else {
            [self loadComplaintBaseData];
        }
    } failBlock:^(NSError *error) {
        [self loadComplaintBaseData];
    }];
}
- (void)addComplaintAc
{
    NSString * url = @"wuye/tousubilladd.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"cpcode"] = self.dataDic[@"cpcode"];
    params[@"memberid"] = self.jumpDic[@"memberid"];
    params[@"orderid"] = self.jumpDic[@"orderid"];
    params[@"calltime"] = self.complaintTime.text;
    params[@"fromtype"] = self.dataDic[@"fromtype"];
    params[@"fromhouseid"] = self.dataDic[@"fromhouseid"];
    params[@"fromhousename"] = self.elsenameT.text;
    params[@"fromtel"] = self.elsephoeT.text;
    params[@"totype"] = self.dataDic[@"totype"];
    params[@"tohouseid"] = self.dataDic[@"tohouseid"];
    params[@"tohousename"] = self.nameT.text;
    params[@"totel"] = self.phoeT.text;
    params[@"tousutitle"] = self.titleT.text;
    params[@"tousucontent"] = self.contentT.text;
    params[@"modid"] = self.dataDic[@"modid"];
    params[@"yufinishtime"] = self.finishTime.text;
    params[@"calltype"] = @"1";
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(@"处理成功!");
            if (self.MyBlock) {
                self.MyBlock();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
