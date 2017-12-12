//
//  TJAddOrderViewController.m
//  baseXcode
//
//  Created by hangshao on 17/1/6.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJAddOrderViewController.h"
#import "TJChooseDetailAddressMenViewController.h"
#import "TJChooseGoodsViewController.h"
#import "TJChooseOrderpeopleViewController.h"
#import "TJOrderGoodsTableViewCell.h"
@interface TJAddOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,TJOrderGoodsDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   weak) UITextField     * address;
@property (nonatomic,   weak) UITextField     * name;
@property (nonatomic,   weak) UITextField     * phone;
@property (nonatomic,   weak) UITextField     * guwen;
@property (nonatomic,   weak) UITextView     * remark;
@property (nonatomic,   weak) UILabel     * xiaoqu;
@property (nonatomic,   weak) UILabel     * money;
@property (nonatomic,   weak) UILabel     * placeholder;
@property (nonatomic,   assign) NSInteger   selectFlag;
@property (nonatomic,   weak) UIView     * bgview;
@property (nonatomic,   assign) NSInteger  yyyyy;
@end

@implementation TJAddOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView];
    
    [self setTableView];
    
    [self setHeaderView];
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
    label.text = @"新增订单";
    
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
        if (self.address.text.length == 0) {
            SVShowError(@"请选择地址!");
            return;
        }
        if (self.name.text.length == 0) {
            SVShowError(@"请输入客户姓名!");
            return;
        }
        if (self.phone.text.length == 0) {
            SVShowError(@"请输入客户电话!");
            return;
        }
        if (self.money.text.length == 0) {
            SVShowError(@"请添加商品!");
            return;
        }
        if (self.remark.text.length == 0) {
//            SVShowError(@"请填写备注!");
//            return;
        }
        [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"信息确认后将发布，是否发布?" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self addOrderAc];
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
    return 2+self.dataArray.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 258 - 90 + 5*fifteenS.height;
    }else if (indexPath.row == self.dataArray.count + 1){
        return 283 - 4*18 + 4*fifteenS.height;
    }
    return 115 - 3*17+3*fourteenS.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString * ID = @"TJAddOrderTopCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TJManagerOrderCell" owner:self options:nil] objectAtIndex:2];
        }
        for (int i = 0; i < 5; i ++) {
            UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
            label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
            label1.textColor = fivelightColor;
        }
        for (int i = 0; i < 3; i ++) {
            UITextField * text = (UITextField *)[cell.contentView viewWithTag:100 + i];
            text.font = fifteenFont;
        }
        for (int i = 0; i < 3; i ++) {
            UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
            view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
            view.borderWidth = 1.0;
            view.cornerRadius = 5.0;
        }
        for (int i = 0; i < 4; i ++) {
            UIButton * edite = (UIButton *)[cell.contentView viewWithTag:110 + i];
            if (i == 3) {
                edite.cornerRadius = 5;
                edite.backgroundColor = orangecolor;
                edite.titleFont = 15 * ScaleModel;
            }
            [edite addTarget:self action:@selector(chooseorderXiaoquAndTime:)];
        }
        UITextField * address = (UITextField *)[cell.contentView viewWithTag:100];
        self.address = address;
        UITextField * name = (UITextField *)[cell.contentView viewWithTag:101];
        name.text = self.dataDic[@"name"];
        self.name = name;
        UITextField * phone = (UITextField *)[cell.contentView viewWithTag:102];
        phone.text = self.dataDic[@"phone"];
        phone.keyboardType = UIKeyboardTypeNumberPad;
        self.phone = phone;
        UILabel * xiaoqu = (UILabel *)[cell.contentView viewWithTag:104];
        self.xiaoqu = xiaoqu;
        UIButton * nameB = (UIButton *)[cell.contentView viewWithTag:111];
        nameB.hidden = YES;
        UIButton * phoneB = (UIButton *)[cell.contentView viewWithTag:112];
        phoneB.hidden = YES;
        if (self.selectFlag == 0) {
            
        } else {
            address.text = [NSString stringWithFormat:@"%@－%@－%@",self.dataDic[@"cpname"],self.dataDic[@"compname"],self.dataDic[@"housename"]];
            xiaoqu.text = self.dataDic[@"cpname"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == self.dataArray.count + 1){
        static NSString * ID = @"TJAddOrderBottomCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TJManagerOrderCell" owner:self options:nil] objectAtIndex:3];
        }
        for (int i = 0; i < 4; i ++) {
            UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:205 + i];
            label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
            label1.textColor = fivelightColor;
        }
        for (int i = 0; i < 2; i ++) {
            UIView * view = (UIView *)[cell.contentView viewWithTag:303 + i];
            view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
            view.borderWidth = 1.0;
            view.cornerRadius = 5.0;
            if (i == 1) {
                self.bgview = view;
            }
        }
        UIButton * edite = (UIButton *)[cell.contentView viewWithTag:114];
        [edite addTarget:self action:@selector(chooseorderXiaoquAndTime:)];
        UILabel * money = (UILabel *)[cell.contentView viewWithTag:105];
        money.font = fifteenFont;
        money.textColor = [UIColor colorWithHexString:@"fb652c"];
        if (self.dataArray.count > 0) {
            NSInteger number = 0;
            for (int i = 0; i < self.dataArray.count; i ++) {
                number = number + [self.dataArray[i][@"count"] integerValue] * [self.dataArray[i][@"price"] integerValue];
            }
            money.text = [NSString stringWithFormat:@"¥ %ld",(long)number];
        }else {
            money.text = @"";
        }
        self.money = money;
        UITextField * guwen = (UITextField *)[cell.contentView viewWithTag:103];
        guwen.text = self.dataDic[@"clerkname"];
        guwen.font = fifteenFont;
        self.guwen = guwen;
        UILabel * placeholder = (UILabel *)[cell.contentView viewWithTag:106];
        placeholder.font = fifteenFont;
        placeholder.textColor = [UIColor lightGrayColor];
        self.placeholder = placeholder;
        UITextView * remark = (UITextView *)[cell.contentView viewWithTag:107];
        remark.font = fifteenFont;
        remark.text = self.dataDic[@"remark"];
        remark.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
        remark.delegate = self;
        self.remark = remark;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        TJOrderGoodsTableViewCell * cell = [TJOrderGoodsTableViewCell cellWithTableView:tableView];
        [cell setDataWithLabel:self.dataArray[indexPath.row-1] andindex:indexPath.row-1];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return;
}

#pragma mark - buttonAction
- (void)chooseorderXiaoquAndTime:(UIButton *)button
{
    if (button.tag == 110) {
        TJChooseDetailAddressMenViewController * vc = [[TJChooseDetailAddressMenViewController alloc] init];
        vc.MyBlock = ^(NSMutableDictionary * dic){
            self.selectFlag = 1;
            [self.dataDic removeObjectForKey:@"buildcode"];
            [self.dataDic removeObjectForKey:@"buildname"];
            [self.dataDic removeObjectForKey:@"cpcode"];
            [self.dataDic removeObjectForKey:@"cpname"];
            [self.dataDic removeObjectForKey:@"houseid"];
            [self.dataDic removeObjectForKey:@"housename"];
            [self.dataDic removeObjectForKey:@"ownername"];
            [self.dataDic removeObjectForKey:@"mobile"];
            self.dataDic[@"compcode"] = dic[@"buildcode"];
            self.dataDic[@"compname"] = dic[@"buildname"];
            self.dataDic[@"cpcode"] = dic[@"cpcode"];
            self.dataDic[@"cpname"] = dic[@"cpname"];
            self.dataDic[@"houseid"] = dic[@"houseid"];
            self.dataDic[@"housename"] = dic[@"housename"];
            NSString * url = @"house/ownerlist.jsp";
            
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            params[@"clerkid"] = userClerkid;
            params[@"houseid"] = dic[@"houseid"];
            [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
                if ([request[@"flag"] integerValue] == 0) {
                    if ([request[@"data"] count] > 0) {
                        if ([request[@"data"] isKindOfClass:[NSDictionary class]]) {
                            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:request[@"data"]];
                            self.dataDic[@"name"] = dic[@"ownername"];
                            self.dataDic[@"phone"] = dic[@"mobile"];
                        }else if([request[@"data"] isKindOfClass:[NSArray class]]){
                            NSMutableDictionary * dic  = [NSMutableDictionary dictionaryWithDictionary:request[@"data"][0]];
                            self.dataDic[@"name"] = dic[@"ownername"];
                            self.dataDic[@"phone"] = dic[@"mobile"];
                        }
                    }else {
                        self.dataDic[@"name"] = @"";
                        self.dataDic[@"phone"] = @"";
                    }
                    [self.tableView reloadData];
                }else {
                    SVShowError(request[@"err"]);
                }
            } failBlock:^(NSError *error) {
                SVShowError(@"网络错误，请重试!");
            }];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 111) {//name
//        if (self.address.text.length == 0) {
//            SVShowError(@"请选择客户地址");
//        }
    }
    if (button.tag == 112) {//phone
//        if (self.address.text.length == 0) {
//            SVShowError(@"请选择客户地址");
//        }
    }
    if (button.tag == 113) {//商品money
        if (self.address.text.length == 0) {
            SVShowError(@"请选择客户地址");
            return;
        }
        TJChooseGoodsViewController * vc = [[TJChooseGoodsViewController alloc] init];
        vc.cpcode = self.dataDic[@"cpcode"];
        vc.MyBlock = ^(NSMutableDictionary * dic){
            NSMutableDictionary * dataDic = [NSMutableDictionary dictionary];
            dataDic[@"count"] = @"1";
            dataDic[@"price"] = dic[@"tuanprice"];
            dataDic[@"billtitle"] = dic[@"billtitle"];
            dataDic[@"billid"] = dic[@"billid"];
            if (self.dataArray.count > 0) {
                for (NSMutableDictionary * didic in self.dataArray) {
                    if ([didic[@"billid"] isEqualToString:dic[@"billid"]]) {
                        SVShowError(@"您已添加该商品!");
                        return ;
                    }
                }
            }
            
            NSString * url = @"psp/orderstorenum.jsp";
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            params[@"clerkid"] = userClerkid;
            params[@"cpcode"] = self.dataDic[@"cpcode"];
            params[@"billid"] = dic[@"billid"];
            [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
                if ([request[@"flag"] integerValue] == 0) {
                    if ([request[@"data"] count] > 0) {
                        if ([request[@"data"] isKindOfClass:[NSDictionary class]]) {
                            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:request[@"data"]];
                            dataDic[@"allcount"] = dic[@"storenum"];
                        }else if([request[@"data"] isKindOfClass:[NSArray class]]){
                            NSMutableDictionary * dic  = [NSMutableDictionary dictionaryWithDictionary:request[@"data"][0]];
                            dataDic[@"allcount"] = dic[@"storenum"];
                        }
                    }else {
                        dataDic[@"allcount"] = @"0";
                    }
                    [self.dataArray addObject:dataDic];
                }else {
                    SVShowError(request[@"err"]);
                }
                [self.tableView reloadData];
            } failBlock:^(NSError *error) {
                SVShowError(@"添加失败，请重试!");
            }];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 114) {//顾问
        TJChooseOrderpeopleViewController * vc = [[TJChooseOrderpeopleViewController alloc] init];
        vc.MyBlock = ^(NSMutableDictionary * dic){
            self.dataDic[@"clerkname"] = dic[@"clerkname"];
            self.dataDic[@"clerkid"] = dic[@"clerkid"];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - delete
- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.remark.text = textView.text;
    if (self.remark.text.length == 0) {
        self.placeholder.hidden = NO;
        self.dataDic[@"remark"] = @"";
    } else {
        self.placeholder.hidden = YES;
        self.dataDic[@"remark"] = textView.text;
    }
    self.bgview.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
    [UIView animateWithDuration:0.4 animations:^{
         self.tableView.contentOffset = CGPointMake(0, self.dataArray.count*115);
    }];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.4 animations:^{
        self.tableView.contentOffset = CGPointMake(0, 150+self.dataArray.count*115);
    }];
    self.placeholder.hidden = YES;
    self.bgview.borderColor = orangecolor;
}

#pragma mark -- cell delete
- (void)deleteGoods:(NSInteger)index
{
    [self.dataArray removeObjectAtIndex:index];
    [self.tableView reloadData];
}
- (void)textBeginchange:(UITextField *)text andIndex:(NSInteger)index andFlag:(NSInteger)flag
{
    self.yyyyy = self.tableView.contentOffset.y;
    self.tableView.contentOffset = CGPointMake(0, 258+index*115 + 250 - kScreenHeigth + 64 + 200);
}
- (void)textendchange:(UITextField *)text andIndex:(NSInteger)index andFlag:(NSInteger)flag
{
    [self.view endEditing:YES];
    self.tableView.contentOffset = CGPointMake(0, self.yyyyy);
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (flag == 0) {//编辑价格
        dic[@"price"] = text.text;
        dic[@"count"] = self.dataArray[index][@"count"];
    }else {
        dic[@"count"] = text.text;
        dic[@"price"] = self.dataArray[index][@"price"];
    }
    dic[@"billid"] = self.dataArray[index][@"billid"];
    dic[@"allcount"] = self.dataArray[index][@"allcount"];
    dic[@"billtitle"] = self.dataArray[index][@"billtitle"];
    [self.dataArray replaceObjectAtIndex:index withObject:dic];
    [self.tableView reloadData];
}
#pragma mark - netWorking
- (void)addOrderAc
{
    NSString * orderliststr = [NSString string];
    for (int i = 0; i < self.dataArray.count; i ++) {
        orderliststr = [NSString stringWithFormat:@"%@%@|%@|%@|%.2f,",orderliststr,self.dataArray[i][@"billid"],self.dataArray[i][@"count"],self.dataArray[i][@"price"],[self.dataArray[i][@"price"] floatValue] * [self.dataArray[i][@"count"] integerValue]];
    }
    orderliststr = [orderliststr substringToIndex:[orderliststr length] - 1];
    NSString * url = @"psp/ordernew.jsp";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"cpcode"] = self.dataDic[@"cpcode"];
    params[@"saleid"] = self.dataDic[@"clerkid"];
    params[@"guestid"] = self.dataDic[@"houseid"];
    params[@"orderdate"] = [[User sharedUser] getNowTimeEnglish];;
    params[@"orderliststr"] = orderliststr;
    params[@"remark"] = self.dataDic[@"remark"];
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(@"添加成功!");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.refreshBlock) {
                    self.refreshBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            });
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
        self.dataDic[@"name"] = @"";
        self.dataDic[@"phone"] = @"";
        self.dataDic[@"tuanprice"] = @"";
        self.dataDic[@"clerkname"] = [User sharedUser].userInfo[@"clerkname"];
        self.dataDic[@"clerkid"] = userClerkid;
        self.dataDic[@"remark"] = @"";
    }
    return _dataDic;
}
@end
