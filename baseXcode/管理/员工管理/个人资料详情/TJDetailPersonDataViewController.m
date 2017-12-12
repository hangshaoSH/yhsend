//
//  TJDetailPersonDataViewController.m
//  baseXcode
//
//  Created by hangshao on 16/11/28.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJDetailPersonDataViewController.h"
#import "TJPersonEditDataViewController.h"
@interface TJDetailPersonDataViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@end

@implementation TJDetailPersonDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHeaderView];
    
    [self setTopView];
    
    [self setTableView];
    
    [self loadPersonData];
}
#pragma mark - setView
- (void)setHeaderView
{
    UIView * topView = [[[NSBundle mainBundle] loadNibNamed:@"TJPersonManagerCell" owner:self options:nil] objectAtIndex:3];
    topView.origin = zeroOrigin;
    topView.width = kScreenWidth;
    topView.height = 64;
    topView.backgroundColor = TopBgColor;
    [self.view addSubview:topView];
    
    UILabel * label = (UILabel *)[topView viewWithTag:100];
    label.text = [NSString stringWithFormat:@"%@的档案",self.navTitle];
    label.font = seventeenFont;
    NSString * user = userClerkid;
    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        [button addTarget:self action:@selector(backAndEdit:)];
        if (i == 1) {
            if ([self.personID isEqualToString:user]) {
                button.hidden = NO;
                button.userInteractionEnabled = YES;
            }else {
                button.hidden = YES;
                button.userInteractionEnabled = NO;
            }
        }
    }
}
- (void)backAndEdit:(UIButton *)button
{
    if (button.tag == 110) {
        [YHNetWork stopTheVcRequset:self];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        TJPersonEditDataViewController * vc = [[TJPersonEditDataViewController alloc] init];
        vc.personOldData = self.dataDic;
        vc.navTitle = [NSString stringWithFormat:@"%@的档案",self.navTitle];
        vc.personID = self.personID;
        vc.MyBlock = ^(NSMutableDictionary * dic){
            self.dataDic = nil;
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
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
    if ([self.dataDic count] == 0) {
        return 1;
    }
    return 4;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataDic count] == 0) {
        return self.tableView.height;
    }
    if (indexPath.row == 0) {
        CGSize s = [self.dataDic[@"dutyinfo"][@"deptname"] getStringRectWithfontSize:15*ScaleModel width:120];
        return 48*ScaleModel + 40 + fifteenS.height * 5 + s.height;
    }else if (indexPath.row == 1) {
        return 161 + fifteenS.height*6;
    }else if (indexPath.row == 2) {
        return 61 + fifteenS.height * 2;
    }else {
        return 136 + fifteenS.height*5;
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
    if (indexPath.row == 0) {
        static NSString * ID = @"TJPersonDetailDataCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TJPersonManagerCell" owner:self options:nil] objectAtIndex:4];
        }
        UIView * bgview = (UIView *)[cell.contentView viewWithTag:100];
        
        UIImageView * photo = [[UIImageView alloc] initWithFrame:Rect(37.5 * ScaleModel, 16 * ScaleModel, 77.5 * ScaleModel, 97 * ScaleModel)];
        photo.borderWidth = 0.7;
        photo.borderColor = bordercolor;
        photo.image = [UIImage imageNamed:@"home_photo"];
        [bgview addSubview:photo];
        NSString * string = self.dataDic[@"baseinfo"][@"clerkname"];
        NSString * string1 = [NSString stringWithFormat:@"工号：%@",self.personID];
        CGSize s = [string getStringRectWithfontSize:19*ScaleModel width:0];
        CGSize s1 = [string1 getStringRectWithfontSize:15*ScaleModel width:0];
        UILabel * nameL = [[UILabel alloc] initWithFrame:Rect(0, 124*ScaleModel, s.width, s.height)];
        nameL.centerX = photo.centerX;
        nameL.textAlignment = NSTextAlignmentCenter;
        nameL.font = [UIFont systemFontOfSize:19 * ScaleModel];
        nameL.textColor = [UIColor blackColor];
        nameL.text = string;
        [bgview addSubview:nameL];
        
        UILabel * number = [[UILabel alloc] initWithFrame:Rect(0, 130*ScaleModel+s.height, s1.width, s1.height)];
        number.centerX = photo.centerX;
        number.textAlignment = NSTextAlignmentCenter;
        number.font = [UIFont systemFontOfSize:15 * ScaleModel];
        number.textColor = [UIColor colorWithHexString:@"575757"];
        number.text = string1;
        [bgview addSubview:number];
        
        UIView * rightview = [[[NSBundle mainBundle] loadNibNamed:@"TJPersonManagerCell" owner:self options:nil] objectAtIndex:5];
        rightview.frame = Rect(175*ScaleModel, 30*ScaleModel, kScreenWidth-175*ScaleModel, 150*ScaleModel);
        [bgview addSubview:rightview];
        for (int i = 0; i < 6; i ++) {
            UILabel * label1 = (UILabel *)[rightview viewWithTag:200 + i];
            label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
            label1.textColor = [UIColor colorWithHexString:@"727272"];
        }
        for (int i = 0; i < 6; i ++) {
            UILabel * label1 = (UILabel *)[rightview viewWithTag:100 + i];
            label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
            label1.textColor = [UIColor colorWithHexString:@"000000"];
            if (i == 0) {
                label1.text = self.dataDic[@"dutyinfo"][@"dutystastr"];
            }
            if (i == 1) {
                label1.text = self.dataDic[@"dutyinfo"][@"funcname"];
            }
            if (i == 2) {
                label1.text = self.dataDic[@"dutyinfo"][@"dutyname"];
            }
            if (i == 3) {
                label1.text = self.dataDic[@"dutyinfo"][@"dutytypename"];
            }
            if (i == 4) {
                label1.text = self.dataDic[@"dutyinfo"][@"entrydate"];
            }
            if (i == 5) {
                label1.text = self.dataDic[@"dutyinfo"][@"deptname"];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1){
        static NSString * ID = @"TJPersonDetailDataTopCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TJPersonManagerCell" owner:self options:nil] objectAtIndex:6];
        }
        for (int i = 0; i < 6; i ++) {
            UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
            label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
            label1.textColor = sevenlightColor;
        }
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic[@"baseinfo"]];
        for (int i = 0; i < 6; i ++) {
            UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:100 + i];
            label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
            label1.textColor = [UIColor colorWithHexString:@"000000"];
            if (i == 0) {
              label1.text = dic[@"cardno"];
            }
            if (i == 1) {
                label1.text = dic[@"sexy"];
            }
            if (i == 2) {
                label1.text = dic[@"birthday"];
            }
            if (i == 3) {
                label1.text = dic[@"marry"];
            }
            if (i == 4) {
                label1.text = dic[@"hukou"];
            }
            if (i == 5) {
                label1.text = self.dataDic[@"contactinfo"][@"address"];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 2){
        static NSString * ID = @"TJPersonDetailDataMidCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TJPersonManagerCell" owner:self options:nil] objectAtIndex:7];
        }
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic[@"eduinfo"]];
        for (int i = 0; i < 2; i ++) {
            UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
            label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
            label1.textColor = sevenlightColor;
        }
        for (int i = 0; i < 2; i ++) {
            UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:100 + i];
            label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
            label1.textColor = [UIColor colorWithHexString:@"000000"];
            if (i == 0) {
                label1.text = dic[@"xueli"];
            }
            if (i == 1) {
                label1.text = dic[@"xuexiao"];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        static NSString * ID = @"TJPersonDetailDataBottomCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TJPersonManagerCell" owner:self options:nil] objectAtIndex:8];
        }
         NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic[@"contactinfo"]];
        for (int i = 0; i < 5; i ++) {
            UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
            label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
            label1.textColor = sevenlightColor;
        }
        for (int i = 0; i < 5; i ++) {
            UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:100 + i];
            label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
            label1.textColor = [UIColor colorWithHexString:@"000000"];
            if (i == 0) {
                label1.text = dic[@"mobile"];
            }
            if (i == 1) {
                label1.text = dic[@"officetel"];
            }
            if (i == 2) {
                label1.text = dic[@"hometel"];
            }
            if (i == 3) {
                label1.text = dic[@"qq"];
            }
            if (i == 4) {
                label1.text = dic[@"email"];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([self.dataDic count] == 0) {
        if ([[User sharedUser].showMidLoading isEqualToString:@"点击进行刷新!"]) {
            [User sharedUser].showMidLoading = @"数据加载中...";
            [self.tableView reloadData];
            [self loadPersonData];
        }
    }
}

#pragma mark - buttonAction

#pragma mark - delete

#pragma mark - netWorking
- (void)loadPersonData
{
    NSString * url = @"hr/clerkinfo.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"queryclerkid"] = self.personID;
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"data"] count] > 0) {
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:request[@"data"]];
            [self.tableView reloadData];
        }else {
            [User sharedUser].showMidLoading = @"点击进行刷新!";
        }
    } failBlock:^(NSError *error) {
        [User sharedUser].showMidLoading = @"网络连接错误，请检查您的网络!";
        [self.tableView reloadData];
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
