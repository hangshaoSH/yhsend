//
//  TJHomeViewController.m
//  baseXcode
//
//  Created by hangshao on 16/11/15.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJHomeViewController.h"
#import "TJLoginView.h"
#import "TJHomeTopView.h"
#import "TJHomeTopTableViewCell.h"
#import "TJHomeNormalTableViewCell.h"
#import "TJMemberDetailViewController.h"
#import "TJDetailPersonDataViewController.h"
#import "TJComplaintDetailViewController.h"
#import "TJRepaireComplaintDetailViewController.h"
#import "TJRepaireDetailViewController.h"
#import "TJRepaireBackViewController.h"
#import "TJRepaireDetailElseViewController.h"
#import "TJReserveManagerViewController.h"
@interface TJHomeViewController ()<TJLoginDelegate,TJHomeTopDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) TJLoginView     * loginView;
@property (nonatomic,   weak) UILabel     * nameL;
@property (nonatomic,   weak) UILabel     * positionL;
@property (nonatomic,   weak) UILabel     * departmentL;
@property (nonatomic,   weak) UILabel     * jobNumberL;
@property (nonatomic,   weak) UIImageView     * photoImage;
@property (nonatomic,   weak) UILabel     * showLabel;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   weak) UIView     * midView;
@end

@implementation TJHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [User sharedUser].refreshFlag = 1;
    if (![User sharedUser].login || [User sharedUser].login == NO) {
        [self setLoginView];
        return;
    }
    if (self.dataArray.count > 0) {
        [self loadHomeBaseData];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [User sharedUser].refreshFlag = 0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHeaderView];
    
    [self setTopView];
    
    [self setMidView];
    
    [self setTableView];
    
    [self loadHomeBaseData];
    
    [self loadBaoxiuBaseData];
    [self loadComplainBaseData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumphometWithBillid1:) name:@"homenotRepaire" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumphomeWithBillid2:) name:@"homerepaireSucc" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshhomedata) name:@"refreshhome" object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"homenotRepaire" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"homerepaireSucc" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshhome" object:nil];
}
- (void)refreshhomedata
{
    [self loadHomeBaseData];
}
#pragma mark - setview
- (void)setHeaderView
{
    TJHomeTopView * topview = [[[NSBundle mainBundle] loadNibNamed:@"TJHomeMainXib" owner:self options:nil] firstObject];
    topview.origin = CGPointMake(0, 0);
    topview.width = kScreenWidth;
    topview.height = 64;
    topview.delegate = self;
    topview.nowDayShow.text = [[User sharedUser] getNowTime];
    topview.xingqi.text = [[User sharedUser] getNowDay];
    topview.backgroundColor = [UIColor colorWithHexString:@"c9383a"];
    [self.view addSubview:topview];
}
- (void)setTopView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    UIView * topView = [[UIView alloc] initWithFrame:Rect(12*ScaleModel, 64+8*ScaleModel, kScreenWidth-24*ScaleModel, 148*ScaleModel)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.cornerRadius = 5.0f;
    topView.borderColor = [UIColor colorWithHexString:@"d0d0d0"];
    topView.borderWidth = 0.6;
    [self.view addSubview:topView];
    UIView * leftRedView = [[UIView alloc] initWithFrame:Rect(0, 20*ScaleModel, 35*ScaleModel, 26*ScaleModel)];
    leftRedView.backgroundColor = TopBgColor;
    [topView addSubview:leftRedView];
    UIView * leftGrayView = [[UIView alloc] initWithFrame:Rect(0, 46*ScaleModel, 35*ScaleModel, 8*ScaleModel)];
    leftGrayView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [topView addSubview:leftGrayView];
    UIImageView * tianjiaoloveimage = [[UIImageView alloc] initWithFrame:Rect(43*ScaleModel, 25*ScaleModel, 104*ScaleModel, 21*ScaleModel)];
    tianjiaoloveimage.image = [UIImage imageNamed:@"tianjiaolove"];
    [topView addSubview:tianjiaoloveimage];
     UIView * rightRedView = [[[NSBundle mainBundle] loadNibNamed:@"TJHomeMainXib" owner:self options:nil] objectAtIndex:1];
    rightRedView.frame = Rect(tianjiaoloveimage.width+16*ScaleModel+leftRedView.width, leftRedView.origin.y, topView.width-leftRedView.width-tianjiaoloveimage.width-16*ScaleModel, leftRedView.height);
    rightRedView.backgroundColor = TopBgColor;
    [topView addSubview:rightRedView];
    
    UILabel * nameL = (UILabel *)[rightRedView viewWithTag:100];
    nameL.text = [User sharedUser].userInfo[@"clerkname"];
    nameL.font = [UIFont systemFontOfSize:18 * ScaleModel];
    self.nameL = nameL;
    UILabel * zhiwei = (UILabel *)[rightRedView viewWithTag:101];
    zhiwei.font = [UIFont systemFontOfSize:14 * ScaleModel];
    zhiwei.text = [User sharedUser].userInfo[@"dutyname"];
    self.positionL = zhiwei;
    UIView * rightGrayView = [[UIView alloc] initWithFrame:Rect(rightRedView.origin.x, rightRedView.endY, rightRedView.width, 8*ScaleModel)];
    rightGrayView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [topView addSubview:rightGrayView];
    
    UIImageView * logotianjiao = [[UIImageView alloc] initWithFrame:Rect(28*ScaleModel, leftGrayView.endY+18*ScaleModel, 129*ScaleModel, 8*ScaleModel)];
    logotianjiao.image = [UIImage imageNamed:@"天骄爱生活logo(1)"];
    [topView addSubview:logotianjiao];
    
    UIView * midView = [[[NSBundle mainBundle] loadNibNamed:@"TJHomeMainXib" owner:self options:nil] objectAtIndex:2];
    midView.frame = Rect(28*ScaleModel, logotianjiao.endY+1*ScaleModel, 241*ScaleModel, 75*ScaleModel-logotianjiao.endY+leftGrayView.endY);
    [topView addSubview:midView];
    
    UILabel * bumen = (UILabel *)[midView viewWithTag:100];
    bumen.text = [User sharedUser].userInfo[@"deptname"];
    bumen.font = [UIFont systemFontOfSize:13 * ScaleModel];
    self.departmentL = bumen;
    UILabel * gonghao = (UILabel *)[midView viewWithTag:101];
    gonghao.font = [UIFont systemFontOfSize:13 * ScaleModel];
    gonghao.text = [User sharedUser].userInfo[@"clerkno"];
    self.jobNumberL = gonghao;
    UIImageView * photo = [[UIImageView alloc] initWithFrame:Rect(midView.endX, leftGrayView.endY+5*ScaleModel, 66*ScaleModel, 70*ScaleModel)];
    photo.image = [UIImage imageNamed:@"home_photo"];
    photo.borderWidth = 0.7;
    photo.borderColor = [UIColor colorWithHexString:@"d0d0d0"];
    [topView addSubview:photo];
    self.photoImage = photo;
    UIButton * gotoperson = [[UIButton alloc] initWithFrame:Rect(0, 0, kScreenWidth-24*ScaleModel, 148*ScaleModel)];
    [gotoperson addTarget:self action:@selector(jumpPerson)];
    [topView addSubview:gotoperson];
}
- (void)setMidView
{
    UIView * midView = [[[NSBundle mainBundle] loadNibNamed:@"TJHomeMainXib" owner:self options:nil] objectAtIndex:3];
    midView.frame = Rect(12*ScaleModel, 64+182*ScaleModel, kScreenWidth-24*ScaleModel, 40*ScaleModel);
    midView.borderColor = TopBgColor;
    midView.borderWidth = 0.7;
    [self.view addSubview:midView];
    self.midView = midView;
    UIButton * refreshBut = (UIButton *)[midView viewWithTag:110];
    [refreshBut addTarget:self action:@selector(loadHomeBaseData)];
    UIView * redView = [[UIView alloc] initWithFrame:Rect(0, 0, 114*ScaleModel, 40*ScaleModel)];
    [midView addSubview:redView];
    UIImageView * image = [[UIImageView alloc] initWithFrame:Rect(0, 0, redView.width, redView.height)];
    image.image = [UIImage imageNamed:@"redlineBg"];
    [redView addSubview:image];
    
    UILabel * daiban = [[UILabel alloc] initWithFrame:Rect(0, 0, redView.width, redView.height)];
    daiban.centerX = redView.width/2;
    daiban.centerY = redView.height/2;
    daiban.text = @"待办";
    daiban.textColor = [UIColor whiteColor];
    daiban.textAlignment = NSTextAlignmentCenter;
    daiban.font = seventeenFont;
    [redView addSubview:daiban];
    
    UILabel * showLabel = [[UILabel alloc] initWithFrame:Rect(128*ScaleModel, 0, kScreenWidth-56-140*ScaleModel, 30)];
    showLabel.centerY = redView.height/2;
    showLabel.textColor = [UIColor redColor];
    showLabel.text = @"当前共有0条待办事项";
    showLabel.font = sixteentFont;
    showLabel.attributedText = [[HSUser sharedUser] attributedstringWithText:showLabel.text range1:NSMakeRange(0, 4) font1:16*ScaleModel color1:zeroblackColor range2:NSMakeRange(5, 5) font2:16*ScaleModel color2:zeroblackColor];
    [redView addSubview:showLabel];
    self.showLabel = showLabel;
}
- (void)setTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    初始化tabelView
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(12*ScaleModel, self.midView.endY, kScreenWidth-24*ScaleModel, kScreenHeigth - self.midView.endY - 49) style:UITableViewStylePlain];
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
    if (self.dataArray.count == 0) {
        return 1;
    }
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        return 1;
    }
    if ([self.dataArray[section][@"itemlist"] count] == 0) {
        return 0;
    }
    return [self.dataArray[section][@"itemlist"] count] + 1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return self.tableView.height;
    }
    if (indexPath.row == 0) {
        if (seventeenS.height <= 18) {
            return 29;
        }
        return 11+seventeenS.height;
    } else {
        if ([self.dataArray[indexPath.section][@"itemlist"] count] == 0) {
            return 0;
        }
        CGSize s = [self.dataArray[indexPath.section][@"itemlist"][indexPath.row - 1][@"content"] getStringRectWithfontSize:14*ScaleModel width:kScreenWidth-50];
//        if (s.height > fourteenS.height * 2) {
//            return 46 + fourteenS.height*3;
//        }
        return 46 + 12 * ScaleModel+fourteenS.height + s.height;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
        [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 0) {
        BOOL hidden;
        TJHomeTopTableViewCell * cell = [TJHomeTopTableViewCell cellWithTableView:tableView];
        if (indexPath.section == 0) {
            hidden = YES;
        } else {
            hidden = NO;
        }
        [cell setTitle:self.dataArray[indexPath.section][@"typename"] andHidden:hidden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        TJHomeNormalTableViewCell * cell = [TJHomeNormalTableViewCell cellWithTableView:tableView];
        [cell setdataWithDic:self.dataArray[indexPath.section][@"itemlist"][indexPath.row-1]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
//    1：网上报修   对应权限 4：报修受理
//    2：网上投诉   对应权限 6：投诉受理
//    3：会员核验   对应权限 3：会员核验
//    4：工程派单   对应权限 8：工程派单
//    5：工程维修   对应权限 9：工程维修
//    6：团购配送   对应权限 4：报修受理（临时）
//    7：网上预约   对应权限 4：报修受理（临时）
//    8：网上房源   对应权限 4：报修受理（临时）
//    9：网上找房   对应权限 4：报修受理（临时）
    if (self.dataArray.count == 0) {
        return;
    }
    if (indexPath.row == 0) {
        return;
    }
    NSInteger flag = [self.dataArray[indexPath.section][@"typeid"] integerValue];
    if (flag==1) {
        TJRepaireComplaintDetailViewController * vc = [[TJRepaireComplaintDetailViewController alloc] init];
        vc.orderid = self.dataArray[indexPath.section][@"itemlist"][indexPath.row-1][@"orderid"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (flag==2) {
        TJComplaintDetailViewController * vc = [[TJComplaintDetailViewController alloc] init];
        vc.orderid = self.dataArray[indexPath.section][@"itemlist"][indexPath.row-1][@"orderid"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (flag==3) {
        TJMemberDetailViewController * vc = [[TJMemberDetailViewController alloc] init];
        vc.reqid = self.dataArray[indexPath.section][@"itemlist"][indexPath.row-1][@"orderid"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (flag==4) {
        TJRepaireDetailViewController * vc = [[TJRepaireDetailViewController alloc] init];
        vc.billid = self.dataArray[indexPath.section][@"itemlist"][indexPath.row-1][@"orderid"];
        vc.jumpFlag = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (flag==5) {
        TJRepaireDetailViewController * vc = [[TJRepaireDetailViewController alloc] init];
        vc.billid = self.dataArray[indexPath.section][@"itemlist"][indexPath.row-1][@"orderid"];
        vc.jumpFlag = 3;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (flag==10) {
        TJReserveManagerViewController * vc = [[TJReserveManagerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (flag==7) {
        
    }
    if (flag==8) {
        
    }
    if (flag==9) {
        
    }
}
#pragma mark - buttonAc
- (void)jumpPerson
{
    TJDetailPersonDataViewController * vc = [[TJDetailPersonDataViewController alloc] init];
    vc.navTitle = [User sharedUser].userInfo[@"clerkname"];
    vc.personID = userClerkid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - delegate
- (void)changePerson
{
    [self changeToken:1];
    if ([User sharedUser].jumpflag == 1) {
        [[User sharedUser] removeUserInfo];
    } else {
        [User sharedUser].userInfo = nil;
    }
    [User sharedUser].jumpflag = 0;
    [User sharedUser].login = NO;
    [self setLoginView];
}
- (void)setLoginView
{
    self.loginView = [[TJLoginView alloc] initWithFrame:Rect(0, kScreenHeigth, kScreenWidth, kScreenHeigth)];
    self.loginView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self.loginView];
    [UIView animateWithDuration:0.4 animations:^{
        self.loginView.frame = Rect(0, 0, kScreenWidth, kScreenHeigth);
    }];
}
- (void)loginSucc
{
    [self changeToken:0];
    self.nameL.text = [User sharedUser].userInfo[@"clerkname"];
    self.positionL.text = [User sharedUser].userInfo[@"dutyname"];
    self.departmentL.text = [User sharedUser].userInfo[@"deptname"];
    self.jobNumberL.text = [User sharedUser].userInfo[@"clerkno"];
    [self loadHomeBaseData];
    [UIView animateWithDuration:0.4 animations:^{
        self.loginView.frame = Rect(0, kScreenHeigth, kScreenWidth, kScreenHeigth);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.42 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loginView removeFromSuperview];
        self.loginView = nil;
    });
}

#pragma mark - tongzhi
- (void)jumphometWithBillid1:(NSNotification *)userinfo
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:userinfo.userInfo];
    TJRepaireDetailElseViewController * vc = [[TJRepaireDetailElseViewController alloc] init];
    vc.billid = dic[@"billid"];
    vc.jumpFlag = 3;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)jumphomeWithBillid2:(NSNotification *)userinfo
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:userinfo.userInfo];
    TJRepaireBackViewController * vc = [[TJRepaireBackViewController alloc] init];
    vc.billid = dic[@"billid"];
    vc.jumpFlag = 3;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - networking
- (void)loadHomeBaseData
{
    self.showLabel.text = @"当前共有0条待办事项";
    self.showLabel.attributedText = [[HSUser sharedUser] attributedstringWithText:self.showLabel.text range1:NSMakeRange(0, 4) font1:16*ScaleModel color1:zeroblackColor range2:NSMakeRange(5, 5) font2:16*ScaleModel color2:zeroblackColor];
    [self.dataArray removeAllObjects];
    [User sharedUser].showMidLoading = @"数据加载中...";
    [self.tableView reloadData];
    
    NSString * url = @"alertinfo.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            self.showLabel.text = [NSString stringWithFormat:@"当前共有%@条待办事项",request[@"infonum"]];
            self.showLabel.attributedText = [[HSUser sharedUser] attributedstringWithText:self.showLabel.text range1:NSMakeRange(0, 4) font1:16*ScaleModel color1:zeroblackColor range2:NSMakeRange(4 + [request[@"infonum"] length], 5) font2:16*ScaleModel color2:zeroblackColor];
            if ([request[@"data"] count] == 0) {
                [User sharedUser].showMidLoading = @"";
            } else {
                [self.dataArray addObjectsFromArray:request[@"data"]];
            }
            [self.tableView reloadData];
        }else {
            [User sharedUser].showMidLoading = @"点击进行刷新!";
        }
    } failBlock:^(NSError *error) {
        [User sharedUser].showMidLoading = @"网络连接错误，请检查您的网络!";
        [self.tableView reloadData];
    }];
}
- (void)changeToken:(NSInteger)act
{
    NSString * devicetoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"];
    NSString * url = @"mobiletoken.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"devicetoken"] = devicetoken;
    params[@"act"] = @(act);
    params[@"fromos"] = @"iOS";
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            TSLog(@"切换账号上传成功....");
        }else {;
            TSLog(request[@"err"]);
        }
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        TSLog(@"err");
    }];
}
#pragma mark - loadBaseData
- (void)loadBaoxiuBaseData
{
    NSString * url = @"wuye/bxdata.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            if ([request[@"data"] count] > 0) {
                YYCache * cache = [TJCache shareCache].yyCache;
                [cache removeObjectForKey:@"baoxiuBaseData"];
                [cache setObject:[request[@"data"] data] forKey:@"baoxiuBaseData"];
            }else {
                
            }
        }else {
            [self loadBaoxiuBaseData];
        }
    } failBlock:^(NSError *error) {
        [self loadBaoxiuBaseData];
    }];
}
- (void)loadComplainBaseData
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
            [self loadComplainBaseData];
        }
        
    } failBlock:^(NSError *error) {
        [self loadComplainBaseData];
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
@end
