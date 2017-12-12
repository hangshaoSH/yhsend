//
//  TJAddKeepDataViewController.m
//  baseXcode
//
//  Created by hangshao on 17/1/4.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJAddKeepDataViewController.h"
#import "TJChooseAddressViewController.h"
#import "TJPushImageViewController.h"
@interface TJAddKeepDataViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableArray     * imageArray;
@property (nonatomic,   weak) UITextField     * xiaoqu;
@property (nonatomic,   weak) UITextField     * styleT;
@property (nonatomic,   weak) UITextField     * titleT;
@property (nonatomic,   weak) UITextField     * jianjieT;
@property (nonatomic,   weak) UITextView     * content;
@property (nonatomic,   weak) UILabel     * placeholder;
@property (nonatomic,   weak) UILabel     * imageLabel;
@property (nonatomic,   assign) NSInteger   selectFlag;
@property (nonatomic,   weak) UIView     * bgview;

@end

@implementation TJAddKeepDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageArray = [NSMutableArray arrayWithCapacity:0];
    
    [self setTopView];
    
    [self setHeaderView];
    
    [self setTableView];
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
    label.text = @"信息发布";
    
    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        [button addTarget:self action:@selector(homeAndRefresh:)];
    }
}
- (void)homeAndRefresh:(UIButton *)button
{
    if (button.tag == 110) {
        [YHNetWork stopTheVcRequset:self];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.xiaoqu.text.length == 0) {
            SVShowError(@"请选择小区!");
            return;
        }
        if (self.titleT.text.length == 0) {
            SVShowError(@"请输入标题!");
            return;
        }
        if (self.jianjieT.text.length == 0) {
            SVShowError(@"请输入简介!");
            return;
        }
        if (self.content.text.length == 0) {
            SVShowError(@"请输入内容!");
            return;
        }
        if (self.imageArray.count == 0) {
            SVShowError(@"请上传图片!");
            return;
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
    return 349 + 7 * fifteenS.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"TJAddKeepCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJKeepBaseCell" owner:self options:nil] objectAtIndex:4];
    }
    for (int i = 0; i < 7; i ++) {
        UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
        label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
        label1.textColor = fivelightColor;
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
    for (int i = 0; i < 3; i ++) {
        UIButton * edite = (UIButton *)[cell.contentView viewWithTag:110 + i];
        if (i == 2) {
            edite.cornerRadius = 5.0;
            edite.borderColor = fiveblueColor;
            edite.borderWidth = 0.7;
        }
        [edite addTarget:self action:@selector(chooseaddKeepXiaoquAndstyle:)];
    }
    UITextField * xiaoqu = (UITextField *)[cell.contentView viewWithTag:100];
    self.xiaoqu = xiaoqu;
    UITextField * styleT = (UITextField *)[cell.contentView viewWithTag:101];
    styleT.text = self.dataDic[@"style"];
    self.styleT = styleT;
    UITextField * titleT = (UITextField *)[cell.contentView viewWithTag:102];
    self.titleT = titleT;
    UITextField * jianjieT = (UITextField *)[cell.contentView viewWithTag:103];
    self.jianjieT = jianjieT;
    UITextView * content = (UITextView *)[cell.contentView viewWithTag:104];
    content.delegate = self;
    content.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    self.content = content;
    UILabel * placeholder = (UILabel *)[cell.contentView viewWithTag:105];
    placeholder.textColor = [UIColor lightGrayColor];
    placeholder.font = fifteenFont;
    self.placeholder = placeholder;
    UILabel * image = (UILabel *)[cell.contentView viewWithTag:106];
    image.font = [UIFont systemFontOfSize:15 * ScaleModel];
    image.textColor = fiveblueColor;
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
        vc.MyBlock = ^(NSMutableDictionary * dic){
            if ([self.dataDic count] > 0) {
                [self.dataDic removeObjectForKey:@"cpcode"];
                [self.dataDic removeObjectForKey:@"cpname"];
            }
            self.xiaoqu.text = dic[@"cpname"];
            self.dataDic[@"cpcode"] = dic[@"cpcode"];
            self.dataDic[@"cpname"] = dic[@"cpname"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 111) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@"小区通知"];
        [array addObject:@"小区动态"];
        [array addObject:@"小区活动"];
        CGSize s = [@"性别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 96+(fifteenS.height - 18)*2/2 andWidth:133 andHeight:34*3 andData:array withString:self.styleT.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.dataDic removeObjectForKey:@"styleid"];
            [self.dataDic removeObjectForKey:@"style"];
            self.styleT.text = dic[@"label"];
            self.dataDic[@"styleid"] = dic[@"index"];
            self.dataDic[@"style"] = dic[@"label"];
        }];
    }
    if (button.tag == 112) {
        TJPushImageViewController * vc = [[TJPushImageViewController alloc] init];
        vc.haveImageArray = [NSMutableArray arrayWithArray:self.imageArray];
        vc.imageCount = 1;
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
- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.content.text = textView.text;
    if (self.content.text.length == 0) {
        self.placeholder.hidden = NO;
    } else {
        self.placeholder.hidden = YES;
    }
    self.bgview.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeholder.hidden = YES;
    self.bgview.borderColor = orangecolor;
}
#pragma mark - netWorking
- (void)addkeepSearch
{
    NSString * url = @"wuye/newsadd.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"newstype"] = self.dataDic[@"styleid"];
    params[@"cpcode"] = self.dataDic[@"cpcode"];
    params[@"newstitle"] = self.titleT.text;
    params[@"newsspec"] = self.jianjieT.text;
    params[@"newscontent"] = self.content.text;
    params[@"newsdate"] = [[User sharedUser] getNowTimeEnglish];
    params[@"newspic"] = self.imageArray[0];
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(@"发布成功!");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.refreshBlock) {
                    self.refreshBlock([self.dataDic[@"styleid"] integerValue]);
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
        self.dataDic[@"styleid"] = @"0";
        self.dataDic[@"style"] = @"小区通知";
    }
    return _dataDic;
}
@end
