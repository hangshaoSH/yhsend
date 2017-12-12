//
//  FaceViewController.m
//  baseXcode
//
//  Created by app on 2017/8/12.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "FaceViewController.h"
#import "TJChooseDetailAddressMenViewController.h"
#import "faceModel.h"
#import "faceNormalCell.h"
#import "SKMViewController.h"
@interface FaceViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic, weak) UITextField * address;
@property (nonatomic, weak) UITextField * style;
@property (nonatomic, assign) NSInteger chooseStyle;//0收欠费 1预收费
@property (nonatomic, weak) UILabel * moneyL;
@property (nonatomic, strong) NSMutableDictionary * getDataDic;//存收费style和地址
@property (nonatomic, strong) NSMutableDictionary * wyDic;//物业费用的dic
@property (nonatomic, strong) NSMutableArray * needArray;//缴费id串
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray * array1;
@property (nonatomic, strong) NSMutableArray * array2;
@property (nonatomic, strong) NSMutableArray * array3;
@end

@implementation FaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chooseStyle = 0;
    self.needArray = [NSMutableArray arrayWithCapacity:0];
    self.getDataDic = [NSMutableDictionary dictionary];
    self.wyDic = [NSMutableDictionary dictionary];
    self.getDataDic[@"style"] = @"0";
    self.getDataDic[@"houseid"] = @"";
    self.getDataDic[@"housename"] = @"";
    self.getDataDic[@"stylename"] = @"收欠费";
    [self setTableView];
    
    [self addFooterView];
}
#pragma mark - view
- (void)addFooterView
{
    UIView * topView = [[[NSBundle mainBundle] loadNibNamed:@"faceToFaceCell" owner:self options:nil] objectAtIndex:1];
    topView.origin = CGPointMake(0, kScreenHeigth - 60);
    topView.width = kScreenWidth;
    topView.height = 60;
    [self.view addSubview:topView];
    
    UILabel * label = (UILabel *)[topView viewWithTag:100];
    label.text = @"合计 : ¥";
    label.textColor = [UIColor redColor];
    UILabel * moneylabel = (UILabel *)[topView viewWithTag:101];
    moneylabel.textColor = [UIColor redColor];
    moneylabel.text = @"0.00";
    self.moneyL = moneylabel;
    UIButton * button = (UIButton *)[topView viewWithTag:110];
    button.cornerRadius = 5;
    button.backgroundColor = orangecolor;
    [button addTarget:self action:@selector(set2WD)];
}
- (void)setTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //    初始化tabelView
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeigth - 64 - 60) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"当面收款" backAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark - butonac
- (void)set2WD
{
    if ([self.moneyL.text floatValue] == 0) {
        SVShowError(@"交费金额不能为0!");
        return;
    }
    if (self.chooseStyle == 0) {
        [self getArrayWith:self.index];
    }else {
        SKMViewController * vc = [[SKMViewController alloc] init];
        if ([self.getDataDic[@"index"] integerValue] == 0) {//物业费
            vc.jumpFlag = 1;
        }
        if ([self.getDataDic[@"index"] integerValue] == 1) {//车位管理费
            vc.jumpFlag = 2;
        }
        if ([self.getDataDic[@"index"] integerValue] == 2) {//月租车位费
            vc.jumpFlag = 3;
        }
        if ([self.getDataDic[@"index"] integerValue] == 3) {//不限
            vc.jumpFlag = 4;
        }
        vc.wydic = self.wyDic[@"yumonths"][[self.dataDic[@"index"] integerValue]];
        vc.address = self.getDataDic[@"housename"];
        vc.jumpDic = self.getDataDic;
        vc.money = self.moneyL.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)getArrayWith:(NSInteger)index
{
    if (self.index == self.dataArray.count) {
        SKMViewController * vc = [[SKMViewController alloc] init];
        vc.jumpFlag = self.chooseStyle;
        vc.address = self.getDataDic[@"housename"];
        vc.jumpDic = self.getDataDic;
        vc.money = self.moneyL.text;
        vc.sendArray = self.needArray;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([self.dataArray[index][@"flag"] integerValue] == 1) {
        [self.needArray addObject:self.dataArray[index]];
    }
    self.index ++;
    [self getArrayWith:self.index];
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if ([self.getDataDic[@"houseid"] length] == 0) {
            return 1;
        }
        return 2;
    }
    if ([self.getDataDic[@"houseid"] length] == 0) {
        return 0;
    }
    if (self.chooseStyle == 1) {
        return 0;
    }
    return self.dataArray.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 111 - 36 + fifteenS.height * 2 + 10;
        }
        if ([self.getDataDic[@"houseid"] length] == 0) {
            return 0;
        }
        if (self.chooseStyle == 0) {
            return 84;
        }else {
            if ([self.getDataDic[@"index"] integerValue] == 3) {
                return 103 - 36 + fifteenS.height * 2;
            }
            return 183 - 72 + fifteenS.height * 4;
        }
    }
    if ([self.getDataDic[@"houseid"] length] == 0) {
        return 0;
    }
    if (self.chooseStyle == 1) {
        return 0;
    }
    return 37;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString * ID = @"faceToFacecell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"faceToFaceCell" owner:self options:nil] objectAtIndex:0];
            }
            for (int i = 0; i < 2; i ++) {
                UITextField * text = (UITextField *)[cell.contentView viewWithTag:100 + i];
                text.font = fifteenFont;
            }
            for (int i = 0; i < 2; i ++) {
                UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
                label1.font = fifteenFont;
            }
            for (int i = 0; i < 2; i ++) {
                UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
                view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
                view.borderWidth = 1.0;
                view.cornerRadius = 5.0;
            }
            UITextField * address = (UITextField *)[cell.contentView viewWithTag:101];
            address.text = self.getDataDic[@"housename"];
            UITextField * style = (UITextField *)[cell.contentView viewWithTag:100];
            style.text = self.getDataDic[@"stylename"];
            self.style = style;
            for (int i = 0; i < 2; i ++) {
                UIButton * edite = (UIButton *)[cell.contentView viewWithTag:110 + i];
                [edite addTarget:self action:@selector(faceToFaceChoosebutAc:)];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (self.chooseStyle == 0) {
            static NSString * ID = @"faceToFacecell2";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"faceToFaceCell" owner:self options:nil] objectAtIndex:3];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if ([self.getDataDic[@"index"] integerValue] == 3) {
            static NSString * ID = @"faceToFacecell4";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"faceToFaceCell" owner:self options:nil] objectAtIndex:5];
            }
            for (int i = 0; i < 2; i ++) {
                UITextField * text = (UITextField *)[cell.contentView viewWithTag:100 + i];
                text.font = fifteenFont;
            }
            for (int i = 0; i < 2; i ++) {
                UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
                label1.font = fifteenFont;
            }
            for (int i = 0; i < 2; i ++) {
                UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
                view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
                view.borderWidth = 1.0;
                view.cornerRadius = 5.0;
            }
            UITextField * feixiang = (UITextField *)[cell.contentView viewWithTag:100];
            feixiang.text = self.dataDic[@"feixiang"];
            UITextField * jine = (UITextField *)[cell.contentView viewWithTag:101];
            jine.delegate = self;
            jine.keyboardType = UIKeyboardTypeDecimalPad;
            jine.text = self.dataDic[@"jine"];
            [jine becomeFirstResponder];
            for (int i = 0; i < 2; i ++) {
                UIButton * edite = (UIButton *)[cell.contentView viewWithTag:112 + i];
                [edite addTarget:self action:@selector(faceToFaceChoosebutAc:)];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        static NSString * ID = @"faceToFacecell1";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"faceToFaceCell" owner:self options:nil] objectAtIndex:2];
        }
        for (int i = 0; i < 2; i ++) {
            UITextField * text = (UITextField *)[cell.contentView viewWithTag:100 + i];
            text.font = fifteenFont;
        }
        for (int i = 0; i < 4; i ++) {
            UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
            label1.font = fifteenFont;
        }
        for (int i = 0; i < 2; i ++) {
            UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
            view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
            view.borderWidth = 1.0;
            view.cornerRadius = 5.0;
        }
        UILabel * topmoney = (UILabel *)[cell.contentView viewWithTag:204];
        topmoney.text = [NSString stringWithFormat:@"¥%.2f",[self.dataDic[@"topmoney"] floatValue]];
        UILabel * bottommoney = (UILabel *)[cell.contentView viewWithTag:205];
        bottommoney.text = [NSString stringWithFormat:@"¥%.2f",[self.dataDic[@"bottommoney"] floatValue]];
        UITextField * time = (UITextField *)[cell.contentView viewWithTag:101];
        time.text = self.dataDic[@"time"];
        UITextField * feixiang = (UITextField *)[cell.contentView viewWithTag:100];
        feixiang.text = self.dataDic[@"feixiang"];
        for (int i = 0; i < 2; i ++) {
            UIButton * edite = (UIButton *)[cell.contentView viewWithTag:112 + i];
            [edite addTarget:self action:@selector(faceToFaceChoosebutAc:)];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    faceNormalCell * cell = [faceNormalCell cellWithTableView:tableView];
    [cell setCellWithDic:self.dataArray[indexPath.row]];
    cell.block = ^{
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
        if ([dic[@"flag"] integerValue] == 1) {
            dic[@"flag"] = @"0";
            self.moneyL.text = [NSString stringWithFormat:@"%.2f",[self.moneyL.text floatValue] - [dic[@"yingshou"] floatValue]];
        }else {
            dic[@"flag"] = @"1";
            self.moneyL.text = [NSString stringWithFormat:@"%.2f",[self.moneyL.text floatValue] + [dic[@"yingshou"] floatValue]];
        }
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:dic];
        [self.tableView reloadData];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - button
- (void)faceToFaceChoosebutAc:(UIButton *)button
{
    if (button.tag == 110) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@"收欠费"];
        [array addObject:@"预收费"];
        CGSize s = [@"性别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 43+(fifteenS.height - 18)*2 andWidth:133 andHeight:34*array.count andData:array withString:self.style.text clickAtIndex:^(NSMutableDictionary * dic) {
            self.chooseStyle = [dic[@"index"] integerValue];;
            self.getDataDic[@"stylename"] = dic[@"label"];
            [self.tableView reloadData];
            if ([self.getDataDic[@"houseid"] length] == 0) {
                return ;
            }
            if (self.chooseStyle == 0) {//收欠费
                self.moneyL.text = @"0.00";
                self.dataDic[@"feixiang"] = @"物业费";
                self.dataDic[@"jine"] = @"";
                self.dataDic[@"time"] = @"1个月";
                [self getqianfeiDataWith:self.getDataDic[@"houseid"]];
            }else {//预收费
                self.moneyL.text = @"0.00";
                self.dataDic[@"feixiang"] = @"物业费";
                self.dataDic[@"jine"] = @"";
                self.dataDic[@"time"] = @"1个月";
                [self loadWYDataWith];
            }
        }];
    }
    if (button.tag == 111) {
        TJChooseDetailAddressMenViewController * vc = [[TJChooseDetailAddressMenViewController alloc] init];
        vc.MyBlock= ^(NSMutableDictionary * dic){
            self.getDataDic[@"housename"] = [NSString stringWithFormat:@"%@-%@-%@",dic[@"cpname"],dic[@"buildname"],dic[@"housename"]];
            self.getDataDic[@"houseid"] = dic[@"houseid"];
            [self.tableView reloadData];
            if (self.chooseStyle == 0) {//收欠费
                self.moneyL.text = @"0.00";
                self.dataDic[@"jine"] = @"";
                self.dataDic[@"feixiang"] = @"物业费";
                self.dataDic[@"time"] = @"1个月";
                [self getqianfeiDataWith:self.getDataDic[@"houseid"]];
            }else {//预收费
                self.moneyL.text = @"0.00";
                self.dataDic[@"feixiang"] = @"物业费";
                self.dataDic[@"jine"] = @"";
                self.dataDic[@"time"] = @"1个月";
                [self loadWYDataWith];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 112) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@"物业费"];
        [array addObject:@"车位管理费"];
        [array addObject:@"月租车位费"];
        [array addObject:@"不限"];
        CGSize s = [@"性别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 111 - 36 + fifteenS.height * 2 + 55+(fifteenS.height - 18) andWidth:133 andHeight:34*array.count andData:array withString:@"1" clickAtIndex:^(NSMutableDictionary * dic) {
            self.getDataDic[@"index"] = dic[@"index"];
            self.dataDic[@"feixiang"] = dic[@"label"];
            self.moneyL.text = @"0.00";
            self.dataDic[@"jine"] = @"";
            self.dataDic[@"time"] = @"1个月";
            [self.tableView reloadData];
            if ([dic[@"index"] integerValue] == 0) {
                [self loadWYDataWith];
            }
            if ([dic[@"index"] integerValue] == 1) {
                [self loadCarDataWith];
            }
            if ([dic[@"index"] integerValue] == 2) {
                [self loadGLCarDataWith];
            }
            if ([dic[@"index"] integerValue] == 3) {
                
            }
        }];
    }
    if (button.tag == 113) {
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        if ([self.getDataDic[@"index"] integerValue] == 0) {
            for (NSMutableDictionary * dic in self.array1) {
                [array addObject:[NSString stringWithFormat:@"%@个月",dic[@"monthnum"]]];
            }
        }
        if ([self.getDataDic[@"index"] integerValue] == 1) {
            for (NSMutableDictionary * dic in self.array2) {
                [array addObject:[NSString stringWithFormat:@"%@个月",dic[@"monthnum"]]];
            }
        }
        if ([self.getDataDic[@"index"] integerValue] == 2) {
            for (NSMutableDictionary * dic in self.array3) {
                [array addObject:[NSString stringWithFormat:@"%@个月",dic[@"monthnum"]]];
            }
        }
        if ([self.getDataDic[@"index"] integerValue] == 3) {
            
        }
//        [array addObject:@"1个月"];
//        [array addObject:@"2个月"];
//        [array addObject:@"3个月"];
//        [array addObject:@"6个月"];
//        [array addObject:@"12个月"];
        CGSize s = [@"性别:" getStringRectWithfontSize:15*ScaleModel width:0];
        [[HSMidlabelView sharedInstance] setOriginX:s.width + 37 andOriginY: 64 + 111 - 36 + fifteenS.height * 2 + 93+(fifteenS.height - 18)*2 andWidth:133 andHeight:34*array.count andData:array withString:@"1" clickAtIndex:^(NSMutableDictionary * dic) {
            self.dataDic[@"time"] = dic[@"label"];
            self.dataDic[@"index"] = dic[@"index"];
            if ([self.getDataDic[@"index"] integerValue]==0) {
                self.dataDic[@"bottommoney"] = [NSString stringWithFormat:@"%.2f",[self.dataDic[@"topmoney"] floatValue] * [self.array1[[dic[@"index"] integerValue]][@"monthnum"] integerValue]];
            }
            if ([self.getDataDic[@"index"] integerValue]==1) {
                self.dataDic[@"bottommoney"] = [NSString stringWithFormat:@"%.2f",[self.dataDic[@"topmoney"] floatValue] * [self.array2[[dic[@"index"] integerValue]][@"monthnum"] integerValue]];
            }
            if ([self.getDataDic[@"index"] integerValue]==2) {
                self.dataDic[@"bottommoney"] = [NSString stringWithFormat:@"%.2f",[self.dataDic[@"topmoney"] floatValue] * [self.array3[[dic[@"index"] integerValue]][@"monthnum"] integerValue]];
            }
//            if ([dic[@"index"] integerValue] == 0) {
//                self.dataDic[@"bottommoney"] = [NSString stringWithFormat:@"%.2f",[self.dataDic[@"topmoney"] floatValue]];
//            }
//            if ([dic[@"index"] integerValue] == 1) {
//                self.dataDic[@"bottommoney"] = [NSString stringWithFormat:@"%.2f",[self.dataDic[@"topmoney"] floatValue] * 2];
//            }
//            if ([dic[@"index"] integerValue] == 2) {
//                self.dataDic[@"bottommoney"] = [NSString stringWithFormat:@"%.2f",[self.dataDic[@"topmoney"] floatValue] * 3];
//            }
//            if ([dic[@"index"] integerValue] == 3) {
//                self.dataDic[@"bottommoney"] = [NSString stringWithFormat:@"%.2f",[self.dataDic[@"topmoney"] floatValue] * 6];
//            }
//            if ([dic[@"index"] integerValue] == 4) {
//                self.dataDic[@"bottommoney"] = [NSString stringWithFormat:@"%.2f",[self.dataDic[@"topmoney"] floatValue] * 12];
//            }
            self.moneyL.text = self.dataDic[@"bottommoney"];
            [self.tableView reloadData];
        }];
    }
}
#pragma mark - networking
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 0) {
        self.dataDic[@"jine"] = textField.text;
        self.moneyL.text = [NSString stringWithFormat:@"%.1f",[textField.text floatValue]];
    }
}
- (void)getqianfeiDataWith:(NSString *)houseid
{
    [User sharedUser].urlFlag = 1;
    NSString * url = @"wuye/feeys.jsp";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"houseid"] = houseid;
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        self.moneyL.text = @"0.00";
//        [self.needArray removeAllObjects];
        [self.dataArray removeAllObjects];
        if ([request count] > 0) {
            [self.dataArray addObjectsFromArray:request];
            for (int i = 0; i < self.dataArray.count; i ++) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[i]];
                dic[@"flag"] = @"1";
                self.moneyL.text = [NSString stringWithFormat:@"%.2f",[self.moneyL.text floatValue] + [dic[@"yingshou"] floatValue]];
                [self.dataArray replaceObjectAtIndex:i withObject:dic];
            }
//            [self.needArray addObjectsFromArray:self.dataArray];
            [self.tableView reloadData];
        }else {
            SVShowError(@"暂无数据");
        }
    } failBlock:^(NSError *error) {
        SVShowError(@"数据加载出错,请重新加载!");
    }];
}
//获取缴费信息
- (void)loadWYDataWith//物业费
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"houseid"] = self.getDataDic[@"houseid"];
    params[@"itemid"] = @"1";
    MBProgressHUD * hud = [MBProgressHUD showMessage:nil];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://app.cqtianjiao.com/server/sincere2/wuye/feeiteminfo.jsp" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [hud removeFromSuperview];
        NSString * obj = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSData * jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];//字符串json转字典
        NSError * err;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        if (self.array1.count > 0) {
            [self.array1 removeAllObjects];
        }
        self.wyDic = [NSMutableDictionary dictionaryWithDictionary:dic[@"data"]];
        self.array1 = [NSMutableArray arrayWithArray:dic[@"data"][@"yumonths"]];
        self.dataDic[@"topmoney"] = dic[@"data"][@"monthys"];
        self.dataDic[@"bottommoney"] = dic[@"data"][@"monthys"];
        self.moneyL.text = dic[@"data"][@"monthys"];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [hud removeFromSuperview];
        TSLog(error);
    }];
}
//获取缴费信息
- (void)loadCarDataWith//车位管理费
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"houseid"] = self.getDataDic[@"houseid"];
    params[@"itemid"] = @"2";
    MBProgressHUD * hud = [MBProgressHUD showMessage:nil];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://app.cqtianjiao.com/server/sincere2/wuye/feeiteminfo.jsp"   parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [hud removeFromSuperview];
        NSString * obj = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSData * jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];//字符串json转字典
        NSError * err;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        if (self.array2.count > 0) {
            [self.array2 removeAllObjects];
        }
        self.wyDic = [NSMutableDictionary dictionaryWithDictionary:dic[@"data"]];
        self.array2 = [NSMutableArray arrayWithArray:dic[@"data"][@"yumonths"]];
        self.dataDic[@"topmoney"] = dic[@"data"][@"monthys"];
        self.dataDic[@"bottommoney"] = dic[@"data"][@"monthys"];
        self.moneyL.text = dic[@"data"][@"monthys"];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [hud removeFromSuperview];
        TSLog(error);
    }];
}
- (void)loadGLCarDataWith//月租车位费
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"houseid"] = self.getDataDic[@"houseid"];
    params[@"itemid"] = @"3";
    MBProgressHUD * hud = [MBProgressHUD showMessage:nil];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://app.cqtianjiao.com/server/sincere2/wuye/feeiteminfo.jsp"   parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [hud removeFromSuperview];
        NSString * obj = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSData * jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];//字符串json转字典
        NSError * err;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        if (self.array3.count > 0) {
            [self.array3 removeAllObjects];
        }
        self.wyDic = [NSMutableDictionary dictionaryWithDictionary:dic[@"data"]];
        self.array3 = [NSMutableArray arrayWithArray:dic[@"data"][@"yumonths"]];
        self.dataDic[@"topmoney"] = dic[@"data"][@"monthys"];
        self.dataDic[@"bottommoney"] = dic[@"data"][@"monthys"];
        self.moneyL.text = dic[@"data"][@"monthys"];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [hud removeFromSuperview];
        TSLog(error);
    }];
}
#pragma mark - lazy
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
        _dataDic[@"time"] = @"1个月";
        _dataDic[@"feixiang"] = @"物业费";
        _dataDic[@"bottommoney"] = @"0.00";
        _dataDic[@"topmoney"] = @"0.00";
        _dataDic[@"index"] = @"0";
        _dataDic[@"jine"] = @"";
    }
    return _dataDic;
}
@end
