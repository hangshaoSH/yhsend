//
//  TJAddReserveViewController.m
//  baseXcode
//
//  Created by hangshao on 17/1/11.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJAddReserveViewController.h"
#import "TJChooseAddressViewController.h"
#import "TJPushImageViewController.h"
@interface TJAddReserveViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableArray     * imageArray;
@property (nonatomic,   weak) UITextField     * xiaoqu;
@property (nonatomic,   weak) UITextField     * styleT;
@property (nonatomic,   weak) UITextField     * goods;
@property (nonatomic,   weak) UITextField     * countt;
@property (nonatomic,   weak) UITextView     * content;
@property (nonatomic,   weak) UILabel     * placeholder;
@property (nonatomic,   weak) UILabel     * imageLabel;
@property (nonatomic,   assign) NSInteger   selectFlag;
@property (nonatomic,   weak) UIView     * bgview;

@end

@implementation TJAddReserveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectFlag = 0;
    
    self.imageArray = [NSMutableArray arrayWithCapacity:0];
    
    [self setTopView];
    
    [self setHeaderView];
    
    [self setTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseGoods:) name:@"choosegoodsOk" object:nil];
}
- (void)chooseGoods:(NSNotification *)user
{
    NSString * url = @"psp/orderstorenum.jsp";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"cpcode"] = user.userInfo[@"cpcode"];
    params[@"billid"] = user.userInfo[@"billid"];
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            if ([request[@"data"] count] > 0) {
                if ([request[@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:request[@"data"]];
                    self.dataDic[@"kucun"] = dic[@"storenum"];
                }else if([request[@"data"] isKindOfClass:[NSArray class]]){
                    NSMutableDictionary * dic  = [NSMutableDictionary dictionaryWithDictionary:request[@"data"][0]];
                    self.dataDic[@"kucun"] = dic[@"storenum"];
                }
                self.dataDic[@"billtitle"] = user.userInfo[@"billtitle"];
                self.dataDic[@"billid"] = user.userInfo[@"billid"];
                self.dataDic[@"cpcode"] = user.userInfo[@"cpcode"];
            }else {
                self.dataDic[@"kucun"] = @"0";
                self.dataDic[@"billtitle"] = user.userInfo[@"billtitle"];
                self.dataDic[@"billid"] = user.userInfo[@"billid"];
                self.dataDic[@"cpcode"] = user.userInfo[@"cpcode"];
            }
        }else {
            SVShowError(request[@"err"]);
        }
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        SVShowError(@"添加失败，请重试!");
    }];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"choosegoodsOk" object:nil];
}
#pragma mark - setview
- (void)setHeaderView
{
    UIView * topView = [[[NSBundle mainBundle] loadNibNamed:@"TJManageTopCell" owner:self options:nil] objectAtIndex:1];
    topView.origin = zeroOrigin;
    topView.width = kScreenWidth;
    topView.height = 64;
    topView.backgroundColor = TopBgColor;
    [self.view addSubview:topView];
    
    UILabel * label = (UILabel *)[topView viewWithTag:100];
    label.font = seventeenFont;
    label.text = @"仓库调拨";
    
    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        [button addTarget:self action:@selector(backAndOk:)];
    }
}
- (void)backAndOk:(UIButton *)button
{
    if (button.tag == 110) {
        [YHNetWork stopTheVcRequset:self];
        if (self.refreshBlock) {
            self.refreshBlock(0);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.goods.text.length == 0) {
            SVShowError(@"请选择商品!");
            return;
        }
        if (self.countt.text.length == 0) {
            SVShowError(@"请输数量!");
            return;
        }
        if (self.selectFlag == 1) {
            if (self.xiaoqu.text.length == 0) {
                SVShowError(@"请选择调入小区!");
                return;
            }
        }
//        if (self.content.text.length == 0) {
//            SVShowError(@"请输入内容!");
//            return;
//        }
        if ([self.dataDic[@"style"] isEqualToString:@"损耗"]) {
            if (self.imageArray.count == 0) {
                SVShowError(@"请上传图片!");
                return;
            }
        }
        
        [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"信息确认后将发布，是否发布?" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self addkeepSearch];
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
    if (self.selectFlag == 0) {
        return 349 + 7 * fifteenS.height;
    }else {
        return 475 - 8 * 18 + 8 * fifteenS.height;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"TJAddKuCunOneCell";
    if (self.selectFlag == 0) {
        ID = @"TJAddKuCunOneCell";
    }else {
        ID = @"TJAddKuCunTwoCell";
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        if (self.selectFlag == 1) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TJReserveManagerCell" owner:self options:nil] objectAtIndex:8];
        } else {
           cell = [[[NSBundle mainBundle] loadNibNamed:@"TJReserveManagerCell" owner:self options:nil] objectAtIndex:9];
        }
        
    }
    for (int i = 0; i < 8; i ++) {
        UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
        label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
    }
    for (int i = 0; i < 4; i ++) {
        UITextField * text = (UITextField *)[cell.contentView viewWithTag:100 + i];
        text.font = fifteenFont;
    }
    for (int i = 0; i < 5; i ++) {
        UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
        if (i == 4) {
            self.bgview = view;
        }
        view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
        view.borderWidth = 1.0;
        view.cornerRadius = 5.0;
    }
    for (int i = 0; i < 4; i ++) {
        UIButton * edite = (UIButton *)[cell.contentView viewWithTag:110 + i];
        if (i == 3) {
            edite.cornerRadius = 5.0;
            edite.borderColor = fiveblueColor;
            edite.borderWidth = 0.7;
        }
        [edite addTarget:self action:@selector(chooseaddKeepXiaoquAndstyle:)];
    }
    UITextField * goods = (UITextField *)[cell.contentView viewWithTag:100];
    goods.text = self.dataDic[@"billtitle"];
    self.goods = goods;
    UITextField * xiaoqu = (UITextField *)[cell.contentView viewWithTag:102];
    xiaoqu.text = self.dataDic[@"cpname"];
    self.xiaoqu = xiaoqu;
    UITextField * styleT = (UITextField *)[cell.contentView viewWithTag:101];
    styleT.text = self.dataDic[@"style"];
    self.styleT = styleT;
    UITextField * countt = (UITextField *)[cell.contentView viewWithTag:103];
    countt.text = self.dataDic[@"count"];
    countt.keyboardType = UIKeyboardTypeNumberPad;
    countt.delegate = self;
    self.countt = countt;
    UITextView * content = (UITextView *)[cell.contentView viewWithTag:104];
    content.delegate = self;
    content.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    content.text = self.dataDic[@"content"];
    self.content = content;
     UILabel * kucun = (UILabel *)[cell.contentView viewWithTag:207];
    kucun.text = [NSString stringWithFormat:@"当前库存：%@",self.dataDic[@"kucun"]];
    UILabel * placeholder = (UILabel *)[cell.contentView viewWithTag:105];
    placeholder.textColor = [UIColor lightGrayColor];
    placeholder.font = fifteenFont;
    self.placeholder = placeholder;
    if (content.text.length == 0) {//self.dataDic[@"kucun"]
        placeholder.hidden = NO;
    }else {
         placeholder.hidden = YES;
    }
    UILabel * image = (UILabel *)[cell.contentView viewWithTag:106];
    image.font = [UIFont systemFontOfSize:15 * ScaleModel];
    image.textColor = fiveblueColor;
    if (self.imageArray.count > 0) {
        image.text = [NSString stringWithFormat:@"已上传%lu张",(unsigned long)self.imageArray.count];
    }else {
        image.text = @"上传图片";
    }
    self.imageLabel = image;
    UILabel * name = (UILabel *)[cell.contentView viewWithTag:107];
    name.text = [User sharedUser].userInfo[@"clerkname"];
    UILabel * time = (UILabel *)[cell.contentView viewWithTag:108];
    time.text = [[User sharedUser] getNowTimeHaveHM];
    image.font = [UIFont systemFontOfSize:15 * ScaleModel];
    time.font = [UIFont systemFontOfSize:15 * ScaleModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return;
}

#pragma mark - buttonAction
- (void)chooseaddKeepXiaoquAndstyle:(UIButton *)button
{
    if (button.tag == 110) {
        TJChooseAddressViewController * vc = [[TJChooseAddressViewController alloc] init];
        vc.cankuJump = 2;//跳转之后  必须发通知返回
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 111) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@"损耗"];
        [array addObject:@"调出"];
        [array addObject:@"返厂"];
        CGSize s = [@"性别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 96+(fifteenS.height - 18)*2/2 andWidth:133 andHeight:34*3 andData:array withString:self.styleT.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"style"];
            self.styleT.text = dic[@"label"];
            self.dataDic[@"style"] = dic[@"label"];
            if ([dic[@"index"] integerValue] == 1) {
                self.selectFlag = 1;
            } else {
                self.selectFlag = 0;
            }
            [self.tableView reloadData];
        }];
    }
    if (button.tag == 112) {
        TJChooseAddressViewController * vc = [[TJChooseAddressViewController alloc] init];
        vc.MyBlock = ^(NSMutableDictionary * dic){
            if ([self.dataDic count] > 0) {
                [self.dataDic removeObjectForKey:@"incpcode"];
                [self.dataDic removeObjectForKey:@"cpname"];
            }
            self.xiaoqu.text = dic[@"cpname"];
            self.dataDic[@"incpcode"] = dic[@"cpcode"];
            self.dataDic[@"cpname"] = dic[@"cpname"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 113) {
        TJPushImageViewController * vc = [[TJPushImageViewController alloc] init];
        vc.haveImageArray = [NSMutableArray arrayWithArray:self.imageArray];
        vc.imageCount = 3;
        vc.MyBlock = ^(NSMutableArray * imageArray){
            [self.imageArray removeAllObjects];
            [self.imageArray addObjectsFromArray:imageArray];
            [self setchangedata];
        };
        vc.deleteBlock = ^(NSMutableArray * imageArray){
            [self.imageArray removeAllObjects];
            [self.imageArray addObjectsFromArray:imageArray];
            [self setchangedata];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)setchangedata
{
    if (self.imageArray.count > 0) {
        self.imageLabel.text = [NSString stringWithFormat:@"已上传%lu张",(unsigned long)self.imageArray.count];
    }else {
        self.imageLabel.text = @"上传图片";
    }
}
#pragma mark - delete
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 0) {
        [self.dataDic removeObjectForKey:@"count"];
        self.dataDic[@"count"] = textField.text;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.content.text = textView.text;
    if (self.content.text.length == 0) {
        self.placeholder.hidden = NO;
    } else {
        self.placeholder.hidden = YES;
        [self.dataDic removeObjectForKey:@"content"];
        self.dataDic[@"content"] = textView.text;
    }
    self.bgview.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
    if (self.selectFlag == 1) {
        self.tableView.contentOffset = CGPointMake(0, 0);
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeholder.hidden = YES;
    self.bgview.borderColor = orangecolor;
    if (self.selectFlag == 1) {
        if (kScreenWidth < 375) {
            self.tableView.contentOffset = CGPointMake(0, 50);
        }
    }
}
#pragma mark - netWorking
- (void)addkeepSearch
{
    NSString * storetype = [NSString string];
    if ([self.dataDic[@"style"] isEqualToString:@"损耗"]) {
        storetype = @"2";
    }else if ([self.dataDic[@"style"] isEqualToString:@"调出"]){
        storetype = @"4";
    }else {
        storetype = @"5";
    }
    NSString * pprocpic = [NSString string];
    if (self.imageArray.count == 0) {
        pprocpic = @"";
    }else {
        for (int i = 0; i < self.imageArray.count; i ++) {
            pprocpic = [NSString stringWithFormat:@"%@%@,",pprocpic,self.imageArray[i]];
        }
        pprocpic = [pprocpic substringToIndex:pprocpic.length - 1];
    }
    NSString * url = @"wuye/newsadd.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"billid"] = self.dataDic[@"billid"];
    params[@"cpcode"] = self.dataDic[@"cpcode"];
    params[@"storetype"] = storetype;
    params[@"storenum"] = self.dataDic[@"count"];
    params[@"storedate"] = [[User sharedUser] getNowTimeHaveHM];
    params[@"checkid"] = userClerkid;
    params[@"remark"] = self.dataDic[@"content"];
    params[@"incpcode"] = self.dataDic[@"incpcode"];
    params[@"indexpic"] = pprocpic;
    if (self.selectFlag == 0) {
        [params removeObjectForKey:@"incpcode"];
    }
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(@"操作成功!");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.refreshBlock) {
                    self.refreshBlock(1);
                }
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else {
            SVShowError(request[@"err"]);
        }
        [self.tableView reloadData];
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
        self.dataDic[@"storetype"] = @"2";
        self.dataDic[@"style"] = @"损耗";
        self.dataDic[@"billtitle"] = @"";
        self.dataDic[@"count"] = @"";
        self.dataDic[@"kucun"] = @"";
        self.dataDic[@"content"] = @"";
        self.dataDic[@"cpname"] = @"";
    }
    return _dataDic;
}
@end
