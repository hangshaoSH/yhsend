//
//  TJOrderDetailViewController.m
//  baseXcode
//
//  Created by hangshao on 17/1/9.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJOrderDetailViewController.h"
#import "AFHTTPSessionManager.h"
#import "TJOrderTopTableViewCell.h"
#import "TJORderTowTopTableViewCell.h"
#import "TJOrderMidTableViewCell.h"
#import "TJOrderBottomTableViewCell.h"
#import "TJPushImageViewController.h"
@interface TJOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,TJOrderMidDelegate,CuiPickViewDelegate,UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) CuiPickerView     * cuiPickerView;
@property (nonatomic,   weak) UIView     * bgview;
@property (nonatomic,   assign) CGFloat   scrollY;
@property (nonatomic,   weak) UIView     * newview;
@property (nonatomic,   weak) UIView     * backgroundview;
@property (nonatomic,   weak) UITextView     * pscontent;
@property (nonatomic,   weak) UILabel     * psplaceholder;
@property (nonatomic,   weak) UITextField     * psstyle;
@property (nonatomic,   weak) UITextField     * pstime;
@property (nonatomic,   assign) NSInteger   chooseTimeFlag;//0编辑信息  1配送
@property (nonatomic,   weak) UITextField     * pscount;
@property (nonatomic,   weak) UIView     * tuihuoview;
@property (nonatomic,   weak) UIView     * huanhuoview;
@property (nonatomic,   weak) UILabel     * imageLabel;
@property (nonatomic,   strong) NSMutableArray     * imagearray;
@property (nonatomic,   strong) NSMutableDictionary     * cunzuDic;
@end

@implementation TJOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagearray = [NSMutableArray arrayWithCapacity:0];
    self.cunzuDic = [NSMutableDictionary dictionary];
    self.cunzuDic[@"count"] = @"";
    self.cunzuDic[@"time"] = [[User sharedUser] getNowTimeHaveHM];
    self.cunzuDic[@"remark"] = @"";
    [self setTableView];
    
    [self loadOrderDetailData];
}

#pragma mark - setview
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
    
    WeakSelf
    wself.ts_navgationBar = [TSNavigationBar navWithTitle:@"订单详情　" backAction:^{
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
    return 6;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataDic count] == 0) {
        return self.tableView.height;
    }
    NSInteger status = [self.dataDic[@"ordersta"] integerValue];
    if (indexPath.row == 0) {
        NSArray * dataarray = [self.dataDic[@"orderstr"] componentsSeparatedByString:@"^"];
        CGSize s = [dataarray[5] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-42];
        return 395 + [self.dataDic[@"topheight"] floatValue] - 12 * 18 + 11 * fifteenS.height + s.height;
    } else if (indexPath.row == 1) {
        return [self.dataDic[@"toptowheight"] floatValue] + 61 - 18 + fifteenS.height;
    } else if (indexPath.row == 2) {
        return 200 - 54 + fifteenS.height * 3;
    } else if (indexPath.row == 3) {
        if (status == 0|| status == 1|| status == 3) {
            return 0;
        }
        if (status == 7) {
            NSArray * dataarray = [self.dataDic[@"orderback"][0][@"backstr"] componentsSeparatedByString:@"^"];
            CGSize s = [dataarray[3] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-42];
            return 268 - 8 * 18 + 6 * fifteenS.height + s.height;
        }
        NSArray * dataarray = [self.dataDic[@"ordersend"][0][@"sendstr"] componentsSeparatedByString:@"^"];
        CGSize s = [dataarray[5] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-42];
        return 268 - 8 * 18 + 8 * fifteenS.height + s.height;
    } else if (indexPath.row == 4) {//状态 0:待付款 1:已付款未配送 2: 已配送 3:已关闭  5:待退款 6:已过期  7:已退款 8:待评价 9:已评价
        if ([self.dataDic[@"ordersend"] count] < 2) {
            return 0;
        }
        NSArray * dataarray = [self.dataDic[@"ordersend"][1][@"sendstr"] componentsSeparatedByString:@"^"];
        CGSize s = [dataarray[3] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-42];
        return 268 - 8 * 18 + 8 * fifteenS.height + s.height;
    }else {
        if (status == 0 || status == 3 || status == 7) {
            return 0;
        }
        if (status == 1) {
            return 55 + 25*ScaleModel;
        }
        if (status == 2 || status >=5) {
            return 114 + 25*ScaleModel;
        }
        return 0;
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
    NSInteger status = [self.dataDic[@"ordersta"] integerValue];
    if (indexPath.row == 0) {
        TJOrderTopTableViewCell * cell = [TJOrderTopTableViewCell cellWithTableView:tableView];
        [cell setDataWithLabel:self.dataDic];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == 1) {
        TJORderTowTopTableViewCell * cell = [TJORderTowTopTableViewCell cellWithTableView:tableView];
        [cell setDataWithLabel:self.dataDic];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == 2) {
        TJOrderMidTableViewCell * cell = [TJOrderMidTableViewCell cellWithTableView:tableView];
        [cell setDataWithLabel:self.dataDic];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == 3) {
        if (status == 0|| status == 1|| status == 3) {
            return [UITableViewCell new];
        }
        TJOrderBottomTableViewCell * cell = [TJOrderBottomTableViewCell cellWithTableView:tableView];
        if (status == 7) {
            [cell setDataWithLabel:self.dataDic[@"orderback"][0][@"backstr"] andFlag:2];
        }else {
            [cell setDataWithLabel:self.dataDic[@"ordersend"][0][@"sendstr"] andFlag:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == 4) {
        if ([self.dataDic[@"ordersend"] count] < 2) {
            return [UITableViewCell new];
        }
        TJOrderBottomTableViewCell * cell = [TJOrderBottomTableViewCell cellWithTableView:tableView];
        [cell setDataWithLabel:self.dataDic[@"ordersend"][1][@"sendstr"] andFlag:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        if (status == 0 || status == 3 || status == 7) {//状态 0:待付款 1:已付款未配送 2: 已配送 3:已关闭  5:待退款 6:已过期  7:已退款 8:待评价 9:已评价
            return [UITableViewCell new];
        }
        if (status == 1) {
            static NSString * ID = @"TJOrderPSCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"TJOrderDetailCell" owner:self options:nil] objectAtIndex:4];
            }
            UIButton * nowPeiSong = (UIButton *)[cell.contentView viewWithTag:110];
            [nowPeiSong addTarget:self action:@selector(rightNowSend)];
            nowPeiSong.cornerRadius = 5.0;
            nowPeiSong.backgroundColor = [UIColor colorWithHexString:@"ffb400"];
            nowPeiSong.titleFont = 15 * ScaleModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (status == 2 || status >=5) {
            static NSString * ID = @"TJOrderHuanHuoCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"TJOrderDetailCell" owner:self options:nil] objectAtIndex:5];
            }
            UIButton * huanhuo = (UIButton *)[cell.contentView viewWithTag:110];
            [huanhuo addTarget:self action:@selector(huanhuoAc)];
            huanhuo.cornerRadius = 5.0;
            huanhuo.backgroundColor = [UIColor colorWithHexString:@"ffb400"];
            huanhuo.titleFont = 15 * ScaleModel;
            UIButton * tuihuo = (UIButton *)[cell.contentView viewWithTag:111];
            [tuihuo addTarget:self action:@selector(tuihuoAc)];
            tuihuo.cornerRadius = 5.0;
            tuihuo.backgroundColor = [UIColor colorWithHexString:@"ffb400"];
            tuihuo.titleFont = 15 * ScaleModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        return [UITableViewCell new];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataDic.count == 0) {
        if ([[User sharedUser].showMidLoading isEqualToString:@"点击进行刷新!"]) {
            [User sharedUser].showMidLoading = @"数据加载中...";
            [self.tableView reloadData];
            [self loadOrderDetailData];
        }
        return;
    }
}

#pragma mark - buttonAction
#pragma mark - peisong
- (void)rightNowSend
{
    UIView * bgview = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeigth)];
    bgview.backgroundColor = [UIColor blackColor];
    bgview.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:bgview];
    self.backgroundview = bgview;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pskeyboardhide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [bgview addGestureRecognizer:tapGestureRecognizer];
    
    UIView * midview = [[[NSBundle mainBundle] loadNibNamed:@"TJOrderDetailCell" owner:self options:nil] objectAtIndex:7];
    midview.cornerRadius = 5.0;
    midview.width = kScreenWidth-30*ScaleModel;
    midview.height = 467;
    midview.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:midview];
    
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pskeyboardhide1)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer1.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [midview addGestureRecognizer:tapGestureRecognizer1];
    
    self.newview = midview;
    UILabel * kucun = (UILabel *)[midview viewWithTag:100];
    kucun.text = self.dataDic[@"storenum"];
    UILabel * jingbanren = (UILabel *)[midview viewWithTag:101];
    jingbanren.text = [User sharedUser].userInfo[@"clerkname"];
    UITextView * content = (UITextView *)[midview viewWithTag:105];
    content.delegate = self;
    content.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    self.pscontent = content;
    UITextField * style = (UITextField *)[midview viewWithTag:102];
    style.text = @"项目配送";
    self.psstyle = style;
    UITextField * pscount = (UITextField *)[midview viewWithTag:103];
    pscount.keyboardType = UIKeyboardTypeNumberPad;
    pscount.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    self.pscount = pscount;
    UITextField * time = (UITextField *)[midview viewWithTag:104];
    time.text = [[User sharedUser] getNowTimeHaveHM];
    self.pstime = time;
    UILabel *  placeholder  = (UILabel *)[midview viewWithTag:106];
    placeholder.textColor = [UIColor lightGrayColor];
    self.psplaceholder = placeholder;
    for (int i = 0; i < 4; i ++) {
        UIView * view = (UIView *)[midview viewWithTag:300 + i];
        view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
        view.borderWidth = 1.0;
        view.cornerRadius = 5.0;
    }
    for (int i = 0; i < 4; i ++) {
        UIButton * cancle = (UIButton *)[midview viewWithTag:110 + i];
        if (i == 2) {
            cancle.cornerRadius = 5.0;
            cancle.backgroundColor = [UIColor colorWithHexString:@"d1d1d1"];
        }
        if (i == 3) {
            cancle.cornerRadius = 5.0;
            cancle.backgroundColor = fiveblueColor;
        }
        [cancle addTarget:self action:@selector(psbuttonAc:)];
    }
}
-(void)pskeyboardhide{
     [self resetHuanhuodata];
    [self.backgroundview removeFromSuperview];
    [self.newview removeFromSuperview];
    self.backgroundview = nil;
    self.newview = nil;
}
- (void)pskeyboardhide1
{
    [self.newview endEditing:YES];
}
- (void)psbuttonAc:(UIButton *)button
{
    if (button.tag == 110) {//类型  164
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@"项目配送"];
        [array addObject:@"客户自提"];
        CGSize s = [@"性别：" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 + 15*ScaleModel andOriginY: 164 + (kScreenHeigth - 467)/2 andWidth:133 andHeight:2*34 andData:array withString:self.psstyle.text clickAtIndex:^(NSMutableDictionary * dic) {
            self.psstyle.text = dic[@"label"];
        }];
    }
    if (button.tag == 111) {//时间
        [self chooseElsetime];
    }
    if (button.tag == 112) {//取消
        [self pskeyboardhide];
    }
    if (button.tag == 113) {//确定
        if (self.pscount.text.length == 0) {
            SVShowError(@"请输入数量!");
            return;
        }
        [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"信息确认后将发布，是否发布?" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self peisongOrder];
            }
        }];
    }
}
#pragma mark - huanhuo
- (void)resetHuanhuodata
{
    [self.cunzuDic removeObjectForKey:@"time"];
    [self.cunzuDic removeObjectForKey:@"remark"];
    [self.cunzuDic removeObjectForKey:@"count"];
    self.cunzuDic[@"count"] = @"";
    self.cunzuDic[@"time"] = [[User sharedUser] getNowTimeHaveHM];
    self.cunzuDic[@"remark"] = @"";
}
- (void)huanhuoAc
{
    UIView * bgview = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeigth)];
    bgview.backgroundColor = [UIColor blackColor];
    bgview.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:bgview];
    self.backgroundview = bgview;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hhkeyboardhide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
//    [bgview addGestureRecognizer:tapGestureRecognizer];
    
    UIView * midview = [[[NSBundle mainBundle] loadNibNamed:@"TJOrderDetailCell" owner:self options:nil] objectAtIndex:9];
    midview.cornerRadius = 5.0;
    midview.width = kScreenWidth-30*ScaleModel;
    midview.height = 438;
    midview.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:midview];
    
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hhkeyboardhide1)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer1.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [midview addGestureRecognizer:tapGestureRecognizer1];
    
    self.huanhuoview = midview;
    UILabel * jingbanren = (UILabel *)[midview viewWithTag:100];
    jingbanren.text = [User sharedUser].userInfo[@"clerkname"];
    UITextField * pscount = (UITextField *)[midview viewWithTag:101];
    pscount.keyboardType = UIKeyboardTypeNumberPad;
    pscount.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    pscount.text = self.cunzuDic[@"count"];
    pscount.delegate = self;
    self.pscount = pscount;
    UITextView * content = (UITextView *)[midview viewWithTag:103];
    content.delegate = self;
    content.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    content.text = self.cunzuDic[@"remark"];
    self.pscontent = content;
    UITextField * time = (UITextField *)[midview viewWithTag:102];
    time.text = self.cunzuDic[@"time"];
    self.pstime = time;
    UILabel *  placeholder  = (UILabel *)[midview viewWithTag:104];
    placeholder.textColor = [UIColor lightGrayColor];
    self.psplaceholder = placeholder;
    if (content.text.length > 0) {
        placeholder.hidden = YES;
    }
    UILabel *  imageLabel  = (UILabel *)[midview viewWithTag:105];
    imageLabel.textColor = fiveblueColor;
    self.imageLabel = imageLabel;
    if (self.imagearray.count == 0) {
        imageLabel.text = @"上传图片";
    } else {
        imageLabel.text = [NSString stringWithFormat:@"已上传%ld张",(unsigned long)self.imagearray.count];
    }
    for (int i = 0; i < 3; i ++) {
        UIView * view = (UIView *)[midview viewWithTag:300 + i];
        view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
        view.borderWidth = 1.0;
        view.cornerRadius = 5.0;
    }
    for (int i = 0; i < 4; i ++) {
        UIButton * cancle = (UIButton *)[midview viewWithTag:110 + i];
        if (i == 1) {
            cancle.cornerRadius = 5.0;
            cancle.borderColor = fiveblueColor;
            cancle.borderWidth = 0.7;
        }
        if (i == 2) {
            cancle.cornerRadius = 5.0;
            cancle.backgroundColor = [UIColor colorWithHexString:@"d1d1d1"];
        }
        if (i == 3) {
            cancle.cornerRadius = 5.0;
            cancle.backgroundColor = fiveblueColor;
        }
        [cancle addTarget:self action:@selector(huanhuobuttonAc:)];
    }
}
-(void)hhkeyboardhide{
    [self.backgroundview removeFromSuperview];
    [self.huanhuoview removeFromSuperview];
    self.backgroundview = nil;
    self.huanhuoview = nil;
}
- (void)hhkeyboardhide1
{
    [self.huanhuoview endEditing:YES];
}
- (void)huanhuobuttonAc:(UIButton *)button
{
    if (button.tag == 110) {
        [self chooseElsetime];
    }
    if (button.tag == 111) {
        [self hhkeyboardhide];
        TJPushImageViewController * vc = [[TJPushImageViewController alloc] init];
        vc.haveImageArray = [NSMutableArray arrayWithArray:self.imagearray];
        vc.imageCount = 3;
        vc.returnBlock = ^(){
            [self huanhuoAc];
        };
        vc.MyBlock = ^(NSMutableArray * imageArray){
            [self.imagearray removeAllObjects];
            [self.imagearray addObjectsFromArray:imageArray];
            [self huanhuoAc];
        };
        vc.deleteBlock = ^(NSMutableArray * imageArray){
            [self.imagearray removeAllObjects];
            [self.imagearray addObjectsFromArray:imageArray];
            [self huanhuoAc];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 112) {
        [self resetHuanhuodata];
        [self.imagearray removeAllObjects];
        [self hhkeyboardhide];
    }
    if (button.tag == 113) {
        if ([self.cunzuDic[@"count"] length] == 0) {
            SVShowError(@"请输入数量!");
            return;
        }
        [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"信息确认后将发布，是否发布?" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self huanhuoOrder];
            }
        }];
    }
}
#pragma mark - tuihuo
- (void)tuihuoAc
{
    UIView * bgview = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeigth)];
    bgview.backgroundColor = [UIColor blackColor];
    bgview.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:bgview];
    self.backgroundview = bgview;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thkeyboardhide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [bgview addGestureRecognizer:tapGestureRecognizer];
    
    UIView * midview = [[[NSBundle mainBundle] loadNibNamed:@"TJOrderDetailCell" owner:self options:nil] objectAtIndex:8];
    midview.cornerRadius = 5.0;
    midview.width = kScreenWidth-30*ScaleModel;
    midview.height = 331;
    midview.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:midview];
    
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thkeyboardhide1)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer1.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [midview addGestureRecognizer:tapGestureRecognizer1];
    
    self.tuihuoview = midview;
    UILabel * jingbanren = (UILabel *)[midview viewWithTag:100];
    jingbanren.text = [User sharedUser].userInfo[@"clerkname"];
    UITextView * content = (UITextView *)[midview viewWithTag:102];
    content.delegate = self;
    content.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    self.pscontent = content;
    UITextField * time = (UITextField *)[midview viewWithTag:101];
    time.text = [[User sharedUser] getNowTimeHaveHM];
    self.pstime = time;
    UILabel *  placeholder  = (UILabel *)[midview viewWithTag:103];
    placeholder.textColor = [UIColor lightGrayColor];
    self.psplaceholder = placeholder;
    for (int i = 0; i < 2; i ++) {
        UIView * view = (UIView *)[midview viewWithTag:300 + i];
        view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
        view.borderWidth = 1.0;
        view.cornerRadius = 5.0;
    }
    for (int i = 0; i < 3; i ++) {
        UIButton * cancle = (UIButton *)[midview viewWithTag:110 + i];
        if (i == 1) {
            cancle.cornerRadius = 5.0;
            cancle.backgroundColor = [UIColor colorWithHexString:@"d1d1d1"];
        }
        if (i == 2) {
            cancle.cornerRadius = 5.0;
            cancle.backgroundColor = fiveblueColor;
        }
        [cancle addTarget:self action:@selector(tuihuobuttonAc:)];
    }
}
- (void)tuihuobuttonAc:(UIButton *)button
{
    if (button.tag == 110) {
        [self chooseElsetime];
    }
    if (button.tag == 111) {
        [self thkeyboardhide];
    }
    if (button.tag == 112) {
        [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"信息确认后将发布，是否发布?" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self tuihuoOrder];
            }
        }];
    }
}
-(void)thkeyboardhide{
     [self resetHuanhuodata];
    [self.backgroundview removeFromSuperview];
    [self.tuihuoview removeFromSuperview];
    self.backgroundview = nil;
    self.tuihuoview = nil;
}
- (void)thkeyboardhide1
{
    [self.tuihuoview endEditing:YES];
}
#pragma mark - delete
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.cunzuDic removeObjectForKey:@"count"];
    if (textField.text.length == 0) {
        self.cunzuDic[@"count"] = @"";
    } else {
        self.cunzuDic[@"count"] = textField.text;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.psplaceholder.hidden = YES;
    self.newview.centerY = self.view.centerY - 125;
    self.tuihuoview.centerY = self.view.centerY - 50;
    self.huanhuoview.centerY = self.view.centerY - 50;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.pscontent.text.length > 0) {
        [self.cunzuDic removeObjectForKey:@"remark"];
        self.cunzuDic[@"remark"] = textView.text;
        self.psplaceholder.hidden = YES;
    } else {
         self.psplaceholder.hidden = NO;
    }
    self.newview.centerY = self.view.centerY;
    self.tuihuoview.centerY = self.view.centerY;
    self.huanhuoview.centerY = self.view.centerY;
}
- (void)beginTextview:(UITextView *)text
{
    self.scrollY = self.tableView.contentOffset.y;
    self.tableView.contentOffset = CGPointMake(0, self.scrollY + 300);
}
- (void)endTextview:(UITextView *)text
{
    [self.dataDic removeObjectForKey:@"orderremark"];
    self.dataDic[@"orderremark"] = text.text;
    self.tableView.contentOffset = CGPointMake(0, self.scrollY);
}
- (void)editOrSave
{
    if ([self.dataDic[@"flag"] integerValue] == 0) {
        [self.dataDic removeObjectForKey:@"flag"];
        self.dataDic[@"flag"] = @"1";
        [self.tableView reloadData];
    }else {
        [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"是否更改信息?" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self saveOrderData];
            }
        }];
    }
}
- (void)chooseTime
{
    self.chooseTimeFlag = 0;
    UIView * bgview = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeigth)];
    bgview.backgroundColor = [UIColor blackColor];
    bgview.alpha = 0.2;
    [[UIApplication sharedApplication].keyWindow addSubview:bgview];
    self.bgview = bgview;
    
    _cuiPickerView = [[CuiPickerView alloc]init];
    _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
    _cuiPickerView.backgroundColor = [UIColor whiteColor];
    _cuiPickerView.myTextField = [UITextField new];
    _cuiPickerView.string = self.dataDic[@"ordertime"];
    _cuiPickerView.delegate = self;
    _cuiPickerView.curDate=[NSDate date];
    [[UIApplication sharedApplication].keyWindow addSubview:_cuiPickerView];
    [_cuiPickerView showInView:[UIApplication sharedApplication].keyWindow];
}
#pragma mark - 配送  退货  换货选择时间
- (void)chooseElsetime
{
    self.chooseTimeFlag = 1;
    UIView * bgview = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeigth)];
    bgview.backgroundColor = [UIColor blackColor];
    bgview.alpha = 0.2;
    [[UIApplication sharedApplication].keyWindow addSubview:bgview];
    self.bgview = bgview;
    
    _cuiPickerView = [[CuiPickerView alloc]init];
    _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
    _cuiPickerView.backgroundColor = [UIColor whiteColor];
    _cuiPickerView.myTextField = [UITextField new];
    _cuiPickerView.string = [[User sharedUser] getNowTimeHaveHM];
    _cuiPickerView.delegate = self;
    _cuiPickerView.curDate=[NSDate date];
    [[UIApplication sharedApplication].keyWindow addSubview:_cuiPickerView];
    [_cuiPickerView showInView:[UIApplication sharedApplication].keyWindow];
}
- (void)didFinishPickView:(NSString *)date
{
    if (self.chooseTimeFlag == 0) {
        self.dataDic[@"choosetime"] = date;
        if (date.length == 0) {
            self.dataDic[@"choosetime"] = [[User sharedUser]getNowTimeHaveHM];
        }
        [self.tableView reloadData];
        [self.bgview removeFromSuperview];
        self.bgview = nil;
    }
    if (self.chooseTimeFlag == 1) {
        self.pstime.text = date;
        if (date.length == 0) {
            self.pstime.text = [[User sharedUser]getNowTimeHaveHM];
        }
        [self.cunzuDic removeObjectForKey:@"time"];
        self.cunzuDic[@"time"] = self.pstime.text;
        [self.bgview removeFromSuperview];
        self.bgview = nil;
    }
}
- (void)hiddenPickerView
{
    [self.bgview removeFromSuperview];
    self.bgview = nil;
}
#pragma mark - netWorking
- (void)loadOrderDetailData
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"orderid"] = self.orderid;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://wy.cqtianjiao.com/guanjia/sincere/psp/orderdetail.jsp" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * obj = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([obj containsString:@"\t"]) {
            obj = [obj stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        }
        if ([obj containsString:@"\n"]) {
            obj = [obj stringByReplacingOccurrencesOfString:@"\n" withString:@"^"];
        }
        if ([obj containsString:@"\r\n"]) {
            obj = [obj stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        }
        obj = [obj substringToIndex:[obj length] - 1];
        NSError * err;
        NSData * jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];//字符串json转字典
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        TSLog(dic);
        if ([dic[@"flag"] integerValue] == 0) {
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:dic[@"data"]];
            self.dataDic[@"flag"] = @"0";
            self.dataDic[@"choosetime"] = dic[@"data"][@"ordertime"];
            if ([dic[@"data"][@"orderguest"] length] == 0) {
                self.dataDic[@"topheight"] = @(18*ScaleModel + 8 + 20*ScaleModel);
            }else {
                CGFloat height = 0;
                NSArray * kehudata = [dic[@"data"][@"orderguest"] componentsSeparatedByString:@"^"];
                for (int i = 0; i < kehudata.count; i ++) {
                    CGSize s = [kehudata[i] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-42];
                    height = height + s.height + 8;
                }
                if (height < 30) {
                    height = height + 20 * ScaleModel;
                }
                self.dataDic[@"topheight"] = @(height);
            }
            if ([dic[@"data"][@"orderpay"] length] == 0) {
                self.dataDic[@"toptowheight"] = @(18*ScaleModel + 8 + 20*ScaleModel);
            }else {
                CGFloat height = 0;
                NSArray * paydata = [dic[@"data"][@"orderpay"] componentsSeparatedByString:@"^"];
                for (int i = 0; i < paydata.count; i ++) {
                    CGSize s = [paydata[i] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-42];
                    height = height + s.height + 8;
                }
                if (height < 30) {
                    height = height + 20 * ScaleModel;
                }
                self.dataDic[@"toptowheight"] = @(height);
            }
        }else {
            SVShowError(dic[@"err"]);
            [User sharedUser].showMidLoading = @"点击进行刷新!";
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [User sharedUser].showMidLoading = @"网络连接错误，请检查您的网络!";
        [self.tableView reloadData];
    }];
}
- (void)saveOrderData//保存信息
{
    NSString * url = @"psp/orderedit.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"orderid"] = self.orderid;
    params[@"orderdate"] = self.dataDic[@"choosetime"];
    params[@"orderremark"] = self.dataDic[@"orderremark"];
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(@"编辑成功!");
            [self.dataDic removeObjectForKey:@"flag"];
            self.dataDic[@"flag"] = @"0";
            [self.dataDic removeObjectForKey:@"ordertime"];
            self.dataDic[@"ordertime"] = self.dataDic[@"choosetime"];
            [self.tableView reloadData];
        }else {
            SVShowError(request[@"err"]);
        }
    } failBlock:^(NSError *error) {
        SVShowError(@"网络连接错误，请检查您的网络!");
    }];
}
- (void)peisongOrder//立即配送
{
    [self resetHuanhuodata];
    NSString * sendtype = [NSString string];
    if ([self.psstyle.text isEqualToString:@"项目配送"]) {
        sendtype =@"0";
    }else {
        sendtype = @"1";
    }
    NSString * url = @"psp/ordersend.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"orderid"] = self.orderid;
    params[@"sendnum"] = self.pscount.text;
    params[@"senddate"] = self.pstime.text;
    params[@"sendtype"] = sendtype;
    params[@"sendclerkid"] = userClerkid;
    params[@"sendtel"] = @"";
    params[@"remark"] = self.pscontent.text;
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(@"操作成功!");
            self.dataDic = nil;
            [User sharedUser].showMidLoading = @"数据加载中...";
            [self.tableView reloadData];
            [self loadOrderDetailData];
        }else {
            SVShowError(request[@"err"]);
        }
    } failBlock:^(NSError *error) {
        SVShowError(@"网络连接错误，请检查您的网络!");
    }];
}
- (void)huanhuoOrder//办理换货
{
    NSString * huanpic = [NSString string];
    if (self.imagearray.count == 0) {
        huanpic = @"";
    }else {
        for (int i = 0; i < self.imagearray.count; i ++) {
            huanpic = [NSString stringWithFormat:@"%@%@,",huanpic,self.imagearray[i]];
        }
        huanpic = [huanpic substringToIndex:huanpic.length - 1];
    }
    NSString * url = @"psp/orderhuan.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"orderid"] = self.orderid;
    params[@"huannum"] = self.cunzuDic[@"count"];
    params[@"huandate"] = self.cunzuDic[@"time"];
    params[@"huanclerkid"] = userClerkid;
    params[@"huanpic"] = huanpic;
    params[@"remark"] = self.cunzuDic[@"remark"];
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
             [self resetHuanhuodata];
            [self.imagearray removeAllObjects];
            SVShowSuccess(@"操作成功!");
            self.dataDic = nil;
            [User sharedUser].showMidLoading = @"数据加载中...";
            [self.tableView reloadData];
            [self loadOrderDetailData];
        }else {
            SVShowError(request[@"err"]);
        }
    } failBlock:^(NSError *error) {
        SVShowError(@"网络连接错误，请检查您的网络!");
    }];
}
- (void)tuihuoOrder//办理退货
{
    NSString * url = @"psp/orderback.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"orderid"] = self.orderid;
    params[@"reqdate"] = self.pstime.text;
    params[@"reqclerkid"] = userClerkid;
    params[@"remark"] = self.pscontent.text;
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(@"操作成功!");
            self.dataDic = nil;
            [User sharedUser].showMidLoading = @"数据加载中...";
            [self.tableView reloadData];
            [self loadOrderDetailData];
        }else {
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
