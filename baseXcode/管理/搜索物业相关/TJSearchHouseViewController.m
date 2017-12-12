//
//  TJSearchHouseViewController.m
//  baseXcode
//
//  Created by hangshao on 16/11/21.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJSearchHouseViewController.h"
#import "TJChooseAddressViewController.h"
#import "TJCooseLouDongViewController.h"
@interface TJSearchHouseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   weak) UITextField     * xiaoqu;
@property (nonatomic,   weak) UITextField     * loudong;
@property (nonatomic,   weak) UITextField     * style;
@property (nonatomic,   weak) UITextField     * status;
@property (nonatomic,   weak) UITextField     * huxing;
@property (nonatomic,   weak) UITextField     * fanghao;
@property (nonatomic,   strong) NSString     * xiaoquId;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@end

@implementation TJSearchHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.xiaoquId = [NSString string];
    
    [self setTopView];
    
    [self setTableView];
    
    [self setHeaderView];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardSearchWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardSearchWillHide:)
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
        [button addTarget:self action:@selector(backAndSure:)];
    }
}
- (void)backAndSure:(UIButton *)button
{
    if (button.tag == 110) {
        
    } else {
        if (self.fanghao.text.length > 0) {
            self.dataDic[@"housename"] = self.fanghao.text;
        }else {
            if ([self.jumpFlag integerValue]==1) {
                
            }else {
                self.dataDic[@"housename"]= @"";
            }
        }
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"cpcode"] = self.dataDic[@"cpcode"];
        dic[@"buildcode"] = self.dataDic[@"buildcode"];
        dic[@"housename"] = self.dataDic[@"housename"];
        dic[@"housetypeid"] = self.dataDic[@"housetypeid"];
        dic[@"housestaid"] = self.dataDic[@"housestaid"];
        dic[@"unittypeid"] = self.dataDic[@"unittypeid"];
        dic[@"cpname"] = self.xiaoqu.text;
        dic[@"buildname"] = self.loudong.text;
        dic[@"unittypename"] = self.huxing.text;
        dic[@"hstypename"] = self.style.text;
        dic[@"staname"] = self.status.text;
        if ([self.jumpFlag integerValue] == 1) {
            
        }else {
            YYCache * cache = [TJCache shareCache].yyCache;
            [cache removeObjectForKey:@"searchData"];
            [cache setObject:[dic data] forKey:@"searchData"];
        }
        if (self.MyBlock) {
            self.MyBlock();
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
    return 325 + (fifteenS.height - 18) * 6 / 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"TJSearchMainCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJSearchCell" owner:self options:nil] firstObject];
    }
    for (int i = 0; i < 6; i ++) {
        UITextField * text = (UITextField *)[cell.contentView viewWithTag:100 + i];
        text.font = fifteenFont;
    }
    for (int i = 0; i < 6; i ++) {
        UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
        label1.font = fifteenFont;
    }
    for (int i = 0; i < 6; i ++) {
        UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
        view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
        view.borderWidth = 1.0;
        view.cornerRadius = 5.0;
    }
    UITextField * xiaoqu = (UITextField *)[cell.contentView viewWithTag:100];
    self.xiaoqu = xiaoqu;
    UITextField * loudong = (UITextField *)[cell.contentView viewWithTag:101];
    self.loudong = loudong;
    UITextField * style = (UITextField *)[cell.contentView viewWithTag:102];
    self.style = style;
    UITextField * status = (UITextField *)[cell.contentView viewWithTag:103];
    self.status = status;
    UITextField * huxing = (UITextField *)[cell.contentView viewWithTag:104];
    self.huxing = huxing;
    UITextField * fanghao = (UITextField *)[cell.contentView viewWithTag:105];
    self.fanghao = fanghao;
    YYCache * cache = [TJCache shareCache].yyCache;
    NSData * data = (id)[cache objectForKey:@"searchData"];
    NSMutableDictionary * dic = [data toDictionary];
    if ([self.jumpFlag integerValue] == 1) {
        xiaoqu.text = self.jumpDic[@"cpname"];
        loudong.text = self.jumpDic[@"buildname"];
        self.dataDic[@"cpcode"] = self.jumpDic[@"cpcode"];
        self.dataDic[@"buildcode"] = self.jumpDic[@"buildcode"];
        self.dataDic[@"housename"] = self.jumpDic[@"housename"];
    } else {
        if ([dic count] > 0) {
            xiaoqu.text = dic[@"cpname"];
            loudong.text = dic[@"buildname"];
            style.text = dic[@"hstypename"];
            status.text = dic[@"unittypename"];
            huxing.text = dic[@"staname"];
            fanghao.text = dic[@"housename"];
            self.dataDic[@"cpcode"] = dic[@"cpcode"];
            self.dataDic[@"buildcode"] = dic[@"buildcode"];
            self.dataDic[@"housename"] = dic[@"housename"];
            self.dataDic[@"housetypeid"] = dic[@"housetypeid"];
            self.dataDic[@"housestaid"] = dic[@"housestaid"];
            self.dataDic[@"unittypeid"] = dic[@"unittypeid"];
        }
    }
    fanghao.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    for (int i = 0; i < 5; i ++) {
        UIButton * edite = (UIButton *)[cell.contentView viewWithTag:110 + i];
        [edite addTarget:self action:@selector(allbutAc:)];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - buttonAction
- (void)allbutAc:(UIButton *)button
{
    YYCache * cache = [TJCache shareCache].yyCache;
    NSData * data = (id)[cache objectForKey:@"houseBaseData"];
    NSMutableDictionary * dataDic = [data toDictionary];
    if (button.tag == 110) {
        TJChooseAddressViewController * vc = [[TJChooseAddressViewController alloc] init];
        vc.MyBlock = ^(NSMutableDictionary * dic){
             [self.dataDic removeObjectForKey:@"cpcode"];
            [self.dataDic removeObjectForKey:@"cpname"];
            self.xiaoqu.text = dic[@"cpname"];
            self.dataDic[@"cpcode"] = dic[@"cpcode"];
            self.dataDic[@"cpname"] = dic[@"cpname"];
            [self.dataDic removeObjectForKey:@"buildcode"];
            [self.dataDic removeObjectForKey:@"buildname"];
            self.loudong.text = @"";
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 111) {
        if (self.xiaoqu.text.length == 0) {
            SVShowError(@"请选择小区!");
            return;
        }
        TJCooseLouDongViewController * vc = [[TJCooseLouDongViewController alloc] init];
        vc.cpcode = self.dataDic[@"cpcode"];
        vc.MyBlock = ^(NSMutableDictionary * dic){
            [self.dataDic removeObjectForKey:@"buildcode"];
            [self.dataDic removeObjectForKey:@"buildname"];
            self.loudong.text = dic[@"buildname"];
            self.dataDic[@"buildcode"] = dic[@"buildcode"];
            self.dataDic[@"buildname"] = dic[@"buildname"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 112) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@""];
        for (int i = 0; i < [dataDic[@"hstypelist"] count]; i ++) {
            [array addObject:dataDic[@"hstypelist"][i][@"hstypename"]];
        }
        CGSize s = [@"性别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 144+(fifteenS.height - 18)*3/2 andWidth:133 andHeight:(kScreenHeigth - (64 + 144+(fifteenS.height - 18)*3/2)) andData:array withString:self.style.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"housetypeid"];
            if ([dic[@"index"] integerValue] == 0) {
                self.style.text = @"";
                self.dataDic[@"housetypeid"] = @"";
                self.dataDic[@"hstypename"] = @"";
                return ;
            }
            self.style.text = dic[@"label"];
            self.dataDic[@"housetypeid"] = dataDic[@"hstypelist"][[dic[@"index"] integerValue] - 1][@"hstypeid"];
            self.dataDic[@"hstypename"] = dataDic[@"hstypelist"][[dic[@"index"] integerValue] - 1][@"hstypename"];
        }];
    }
    if (button.tag == 113) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@""];
        for (int i = 0; i < [dataDic[@"stalist"] count]; i ++) {
            [array addObject:dataDic[@"stalist"][i][@"staname"]];
        }
        CGSize s = [@"性别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 192+(fifteenS.height - 18)*4/2 andWidth:133 andHeight:(kScreenHeigth - (64 + 192+(fifteenS.height - 18)*4/2)) andData:array withString:self.status.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"staid"];
            if ([dic[@"index"] integerValue] == 0) {
                self.status.text = @"";
                self.dataDic[@"staid"] = @"";
                self.dataDic[@"staname"] = @"";
                return ;
            }
            self.status.text = dic[@"label"];
            self.dataDic[@"staid"] = dataDic[@"stalist"][[dic[@"index"] integerValue] - 1][@"staid"];
            self.dataDic[@"staname"] = dataDic[@"stalist"][[dic[@"index"] integerValue] - 1][@"staname"];
        }];
    }
    if (button.tag == 114) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@""];
        for (int i = 0; i < [dataDic[@"unitlist"] count]; i ++) {
            [array addObject:dataDic[@"unitlist"][i][@"unittypename"]];
        }
        CGSize s = [@"性别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 240+(fifteenS.height - 18)*5/2 andWidth:133 andHeight:(kScreenHeigth - (64 + 240+(fifteenS.height - 18)*5/2)) andData:array withString:self.huxing.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"unittypeid"];
            if ([dic[@"index"] integerValue] == 0) {
                self.huxing.text = @"";
                self.dataDic[@"unittypeid"] = @"";
                self.dataDic[@"unittypename"] = @"";
                return ;
            }
            self.huxing.text = dic[@"label"];
            self.dataDic[@"unittypeid"] = dataDic[@"unitlist"][[dic[@"index"] integerValue] - 1][@"unittypeid"];
            self.dataDic[@"unittypename"] = dataDic[@"unitlist"][[dic[@"index"] integerValue] - 1][@"unittypename"];
        }];
    }
}

#pragma mark - delegate
- (void)keyboardSearchWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    if (kScreenWidth < 375) {
        self.tableView.frame = Rect(0, 64 - (311 + height + (fifteenS.height - 18) * 5 / 2) + (kScreenHeigth - 64), kScreenWidth, kScreenHeigth - 64);
    }
}
- (void)keyboardSearchWillHide:(NSNotification *)aNotification
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
