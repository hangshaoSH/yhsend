//
//  TJQuicklyPostThingViewController.m
//  baseXcode
//
//  Created by hangshao on 17/1/3.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJQuicklyPostThingViewController.h"
#import "TJPushImageViewController.h"
#import "TJChooseAddressViewController.h"
@interface TJQuicklyPostThingViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableArray     * imageArray;
@property (nonatomic,   assign) NSInteger   page;
@property (nonatomic,   weak) UITextField     * xiaoqu;
@property (nonatomic,   weak) UITextView     * contentT;
@property (nonatomic,   weak) UILabel     * placeholder;
@property (nonatomic,   weak) UILabel     * showImageL;
@property (nonatomic,   weak) UIView     * bgview;
@end

@implementation TJQuicklyPostThingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageArray = [NSMutableArray arrayWithCapacity:0];
    
     self.page = 1;
    
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
    label.text = @"快速报事";

    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        [button addTarget:self action:@selector(homeAndSureBaoshi:)];
    }
}
- (void)homeAndSureBaoshi:(UIButton *)button
{
    if (button.tag == 110) {
        [YHNetWork stopTheVcRequset:self];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.xiaoqu.text.length == 0) {
            SVShowError(@"请选择小区!");
            return;
        }
        if (self.contentT.text.length == 0 && self.imageArray.count == 0) {
            SVShowError(@"请输入内容或上传图片!");
            return;
        }
        [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"信息提交后将不能修改，是否提交?" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self quickBaoshi];
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
    return 221+fifteenS.height*2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"TJQuicklyBaoshiBaseCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJQuicklyBaoshiCell" owner:self options:nil] objectAtIndex:0];
    }
    for (int i = 0; i < 2; i ++) {
        UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
        label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
        label1.textColor = fivelightColor;
    }
    for (int i = 0; i < 1; i ++) {
        UITextField * text = (UITextField *)[cell.contentView viewWithTag:101 + i];
        text.font = fifteenFont;
    }
    for (int i = 0; i < 2; i ++) {
        UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
        if (i == 1) {
            self.bgview = view;
        }
        view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
        view.borderWidth = 1.0;
        view.cornerRadius = 5.0;
    }
    UILabel * pushRepaireAfter = (UILabel *)[cell.contentView viewWithTag:100];
    pushRepaireAfter.font = [UIFont systemFontOfSize:15 * ScaleModel];
    pushRepaireAfter.textColor = fiveblueColor;
    if (self.imageArray.count > 0) {
        pushRepaireAfter.text = [NSString stringWithFormat:@"已上传%lu张",(unsigned long)self.imageArray.count];
    }else {
        pushRepaireAfter.text = @"上传图片";
    }
    UITextField * xiaoqu = (UITextField *)[cell.contentView viewWithTag:101];
    xiaoqu.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    xiaoqu.text = self.dataDic[@"cpname"];
    self.xiaoqu = xiaoqu;
    UILabel * placeholder = (UILabel *)[cell.contentView viewWithTag:102];
    placeholder.textColor = [UIColor lightGrayColor];
    placeholder.font = fifteenFont;
    self.placeholder = placeholder;
    UITextView * contentT = (UITextView *)[cell.contentView viewWithTag:103];
    contentT.font = fifteenFont;
    contentT.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    contentT.delegate = self;
    contentT.text = self.dataDic[@"content"];
    self.contentT = contentT;
    UIButton * chooseImage = (UIButton *)[cell.contentView viewWithTag:110];
    [chooseImage addTarget:self action:@selector(chooseImage)];
    chooseImage.cornerRadius = 5.0;
    chooseImage.borderColor = fiveblueColor;
    chooseImage.borderWidth = 0.7;
    
    UIButton * chooseXiaoqu = (UIButton *)[cell.contentView viewWithTag:111];
    [chooseXiaoqu addTarget:self action:@selector(chooseXiao)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return;
}

#pragma mark - buttonAction
- (void)chooseXiao
{
    TJChooseAddressViewController * vc = [[TJChooseAddressViewController alloc] init];
    vc.MyBlock = ^(NSMutableDictionary * dic){
        [self.dataDic removeObjectForKey:@"cpcode"];
        [self.dataDic removeObjectForKey:@"cpname"];
        self.xiaoqu.text = dic[@"cpname"];
        self.dataDic[@"cpcode"] = dic[@"cpcode"];
        self.dataDic[@"cpname"] = dic[@"cpname"];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)chooseImage
{
    TJPushImageViewController * vc = [[TJPushImageViewController alloc] init];
    vc.haveImageArray = [NSMutableArray arrayWithArray:self.imageArray];
    vc.imageCount = 3;
    vc.MyBlock = ^(NSMutableArray * imageArray){
        [self.imageArray removeAllObjects];
        [self.imageArray addObjectsFromArray:imageArray];
        [self.tableView reloadData];
    };
    vc.deleteBlock = ^(NSMutableArray * imageArray){
        [self.imageArray removeAllObjects];
        [self.imageArray addObjectsFromArray:imageArray];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - delete
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.dataDic removeObjectForKey:@"content"];
    self.dataDic[@"content"] = textView.text;
    if (self.contentT.text.length == 0) {
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
- (void)quickBaoshi
{
    NSString * pprocpic = [NSString string];
    if (self.imageArray.count == 0) {
        pprocpic = @"";
    }else {
        for (int i = 0; i < self.imageArray.count; i ++) {
            pprocpic = [NSString stringWithFormat:@"%@%@^",pprocpic,self.imageArray[i]];
        }
        pprocpic = [pprocpic substringToIndex:pprocpic.length - 1];
    }
    NSString * url = @"wuye/simplebx.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"cpcode"] = self.dataDic[@"cpcode"];
    params[@"content"] = self.dataDic[@"content"];
    params[@"pics"] = pprocpic;
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(@"报事成功!");
            [self.dataDic removeObjectForKey:@"cpname"];
            [self.dataDic removeObjectForKey:@"cpcode"];
            [self.dataDic removeObjectForKey:@"content"];
            self.dataDic[@"content"] = @"";
            self.dataDic[@"cpname"] = @"";
            self.dataDic[@"cpcode"] = @"";
            [self.imageArray removeAllObjects];
            [self.tableView reloadData];
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
        self.dataDic[@"cpcode"] = @"";
        self.dataDic[@"cpname"] = @"";
        self.dataDic[@"content"] = @"";
    }
    return _dataDic;
}
@end
