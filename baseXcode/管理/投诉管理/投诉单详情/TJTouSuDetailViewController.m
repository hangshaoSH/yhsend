//
//  TJTouSuDetailViewController.m
//  baseXcode
//
//  Created by hangshao on 16/12/14.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJTouSuDetailViewController.h"
#import "TJTSTopTableViewCell.h"
#import "TJTSTopTowTableViewCell.h"
#import "TJTSBottomTableViewCell.h"
#import "TJTSTopThreeTableViewCell.h"
#import "TJChooseOrderpeopleViewController.h"
#import "TJRepaireAddStepTableViewCell.h"
#import "TJPushImageViewController.h"
#import "TJRepaireStepBaseTableViewCell.h"
#import "TJTSFinishTableViewCell.h"
#import "TJNotRepaireBottomTableViewCell.h"
#import "TJTSBottomTowTableViewCell.h"
@interface TJTouSuDetailViewController ()<UITableViewDelegate,UITableViewDataSource,TJTSTopTowDelegate,TJTSTopDelegate,SDPhotoBrowserDelegate,tjTSBottomDelegate,CuiPickViewDelegate,TJRepaireAddStepDelegate,TJRepaireStepBaseDelegate,UITextFieldDelegate,TJBottomTowDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   assign) NSInteger   topHidden;
@property (nonatomic,   assign) NSInteger   showStep;
@property (nonatomic,   strong) NSMutableArray     * imageArray;
@property (nonatomic,   strong) NSMutableDictionary     * lixiangDic;
@property (nonatomic, strong) CuiPickerView *cuiPickerView;
@property (nonatomic,   weak) UIView     * bgview;
@property (nonatomic,   assign) NSInteger   flag;
@property (nonatomic,   assign) CGFloat   scrollY;
@property (nonatomic,   assign) CGFloat   orginNumber;
@property (nonatomic,   assign) NSInteger   addTSFlag;
@property (nonatomic,   strong) NSMutableDictionary     * stepDic;
@property (nonatomic,   strong) NSMutableArray     * addImageArray;//步骤添加的图片
@property (nonatomic,   assign) NSInteger  chooseTimeFlag;//0未立项  1添加步骤选择时间
@property (nonatomic,   assign) NSInteger   textFlag;

@property (nonatomic,   strong) NSMutableDictionary     * finishDataDic;
@property (nonatomic,   strong) NSMutableDictionary     * elseDataDic;
@property (nonatomic,   weak) UITextField     * huifangName;
@property (nonatomic,   weak) UITextField     * huifangTime;
@property (nonatomic,   weak) UITextField     * peopleAppraise;
@property (nonatomic,   weak) UITextField     * peopleOpinion;
@property (nonatomic,   assign) NSInteger   dosomethingYes;//从受理进入
@end

@implementation TJTouSuDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDataSource];
    
    [self setTableView];
    
    [self loadTousuDetailData];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AddTSBottomKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AddTSBottomKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
#pragma mark - setView
- (void)setDataSource
{
    self.imageArray = [NSMutableArray arrayWithCapacity:0];
    self.addImageArray = [NSMutableArray arrayWithCapacity:0];
    self.lixiangDic = [NSMutableDictionary dictionary];
    self.lixiangDic[@"lixiangname"] = [User sharedUser].userInfo[@"clerkname"];
    self.lixiangDic[@"lixiangid"] = [User sharedUser].userInfo[@"clerkid"];
    self.lixiangDic[@"lixiangtime"] = [[User sharedUser] getNowTimeHaveHM];
    self.lixiangDic[@"zerenname"] = @"";
    self.lixiangDic[@"zerenid"] = @"";
    self.lixiangDic[@"content"] = @"";
    self.stepDic = [NSMutableDictionary dictionary];
    self.stepDic[@"clerkid"] = userClerkid;
    self.stepDic[@"clerkname"] = [User sharedUser].userInfo[@"clerkname"];
    self.stepDic[@"time"] = [[User sharedUser] getNowTimeHaveHM];
    self.stepDic[@"content"] = @"";
    self.stepDic[@"count"] = @"0";
    self.elseDataDic = [NSMutableDictionary dictionary];
    self.elseDataDic[@"clerkname"] =  [User sharedUser].userInfo[@"clerkname"];
    self.elseDataDic[@"clerkid"] =  [User sharedUser].userInfo[@"clerkid"];
    self.elseDataDic[@"time"] = [[User sharedUser] getNowTimeHaveHM];
    YYCache * cache = [TJCache shareCache].yyCache;
    NSData * data = (id)[cache objectForKey:@"complaintBaseData"];
    NSMutableDictionary * dic = [data toDictionary];
    self.elseDataDic[@"typename"] = dic[@"backtypelist"][0][@"typename"];
    self.elseDataDic[@"typeid"] = dic[@"backtypelist"][0][@"typeid"];
    self.finishDataDic = [NSMutableDictionary dictionary];
    self.finishDataDic[@"finishtime"] = [[User sharedUser] getNowTimeHaveHM];
    self.finishDataDic[@"finishcontent"] = @"";
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
    
    WeakSelf
    wself.ts_navgationBar = [TSNavigationBar navWithTitle:@"投诉单详情" backAction:^{
        if (self.jumpFlag == 1) {
            if (self.dosomethingYes == 1) {
                if (self.MyBlock) {
                    self.MyBlock();
                }
            }
        } else {
            if (self.MyBlock) {
                self.MyBlock();
            }
        }
        [YHNetWork stopTheVcRequset:wself];
        [wself.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.dataDic count] == 0) {
        return 1;
    }
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //0:未立项   1:已立项未完成  2:已完成未回访  3: 已完成已回访
    if ([self.dataDic count] == 0) {
        return 1;
    }
    NSInteger status = 0;
    if ([self.dataDic[@"billstaname"] isEqualToString:@"已立项未完成"]) {
        status = 1;
    }
    if ([self.dataDic[@"billstaname"] isEqualToString:@"完成未回访"]) {
        status = 2;
    }
    if ([self.dataDic[@"billstaname"] isEqualToString:@"完成已回访"]) {
       status = 3;
    }
    if (section == 0) {
        return 5;
    }else if (section == 1) {
        if (status == 0) {
            return 0;
        }
        if (self.showStep == 0) {
            return 0;
        }
        if ([self.dataDic[@"procinfo"] isKindOfClass:[NSString class]]) {
            return 0;
        }
        return [self.dataDic[@"procinfo"] count];
    } else {
        return 3;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataDic count] == 0) {
        return self.tableView.height;
    }
    NSInteger status = 0;
    if ([self.dataDic[@"billstaname"] isEqualToString:@"已立项未完成"]) {
        status = 1;
    }
    if ([self.dataDic[@"billstaname"] isEqualToString:@"完成未回访"]) {
        status = 2;
    }
    if ([self.dataDic[@"billstaname"] isEqualToString:@"完成已回访"]) {
        status = 3;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CGFloat height = 0;
            if ([self.dataDic[@"msgcontent"] length] == 0) {
                height = 18;
            }else {
              CGSize s = [self.dataDic[@"msgcontent"] getStringRectWithfontSize:15 * ScaleModel width:kScreenWidth-42];
                height = s.height;
            }
            if ([self.dataDic[@"pics"] length] == 0) {
                height = height - 63 - 8;
            }
            return 375 - 7 * 18 + 6 * fifteenS.height + height;
        } else if (indexPath.row == 1) {
            if (self.topHidden == 0) {
                return 40;
            }
            return 391 - 8 * 18 + 8*fifteenS.height;
        } else if (indexPath.row == 2) {//立项人信息
            if (status == 0) {
                return 0;
            }
            if ([self.dataDic[@"approveinfo"] isKindOfClass:[NSDictionary class]]) {
                CGSize s = [self.dataDic[@"approveinfo"][@"approveproc"] getStringRectWithfontSize:15 * ScaleModel width:kScreenWidth-42];
                if (s.height > 0) {
                    return 133 + 4*fifteenS.height+s.height;
                }
                return 133 + 5*fifteenS.height;
            }
            return 133 + 5*fifteenS.height;
        }else if (indexPath.row == 3){
            if (status == 0) {
                return 0;
            }
            return 32+fifteenS.height;//显示处理步骤或者添加
        }else {//显示添加步骤的信息
            if (status == 0) {
                return 0;
            }
            if (self.addTSFlag == 0) {
                return 0;
            }
            return 187 + 3 * fifteenS.height;
        }
    }else if (indexPath.section == 1){//步骤
        if (self.addTSFlag == 1) {
            return 0;
        }
        if (self.showStep == 0 || [self.dataDic[@"procinfo"] isKindOfClass:[NSString class]]) {
            return 0;
        }
        NSInteger height = 0;
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic[@"procinfo"][indexPath.row]];
        CGSize s = [dic[@"procspec"] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-42];
        if (s.height == 0) {
            height = fifteenS.height;
        }else {
            height = height + s.height;
        }
        if ([dic[@"procpic"] length] == 0) {
            
        } else {
            height = height + 63;
        }
        return height + 99 + 3 * fifteenS.height;
    } else {//底部
        if (indexPath.row == 0) {//收缩步骤
            if (status == 0 || [self.dataDic[@"procinfo"] isKindOfClass:[NSString class]] || self.addTSFlag == 1) {
                return 0;
            }
            if ([self.dataDic[@"procinfo"] count] == 0) {
                return 0;
            }
            return 41;
        }else if (indexPath.row == 1){
            if (status == 0) {//立项
                return 312 - 4 * 18 + 4 * fifteenS.height;
            }
            if (status == 1) {//完成结果填写
                return 208 - 36 + 2 * fifteenS.height;
            }
            CGFloat height = 0;
            if ([self.dataDic[@"finishinfo"] isKindOfClass:[NSDictionary class]]) {
                if ([self.dataDic[@"finishinfo"][@"finishproc"] length] == 0) {
                    height = 18;
                }else {
                    CGSize s = [self.dataDic[@"finishinfo"][@"finishproc"] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-42];
                    height = s.height;
                }
            } else {
               height = 18;
            }
            return 123 - 54 + fifteenS.height*2 + height;//完成的显示  wanchengjieguo
        }else {
            if (status == 0 || status == 1) {
                return 0;
            }
            if ([self.dataDic[@"isvisit"] integerValue] == 1) {
                CGSize s = [self.dataDic[@"visitinfo"][0][@"commspec"] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-42];
                if (s.height == 0) {
                    return 124 + 5*fifteenS.height;
                }
                return 124 + 4*fifteenS.height + s.height;
            }
            return 232+4*fifteenS.height;
        }
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
    NSInteger status = 0;
    if ([self.dataDic[@"billstaname"] isEqualToString:@"已立项未完成"]) {
        status = 1;
    }
    if ([self.dataDic[@"billstaname"] isEqualToString:@"完成未回访"]) {
        status = 2;
    }
    if ([self.dataDic[@"billstaname"] isEqualToString:@"完成已回访"]) {
        status = 3;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TJTSTopTableViewCell * cell = [TJTSTopTableViewCell cellWithTableView:tableView];
            [cell setCellWithDic:self.dataDic];
            [cell setDelegate:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 1) {
            TJTSTopTowTableViewCell * cell = [TJTSTopTowTableViewCell cellWithTableView:tableView];
            [cell setCellWithDic:self.dataDic andHidden:self.topHidden];
            [cell setDelegate:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 2) {
            TJTSTopThreeTableViewCell * cell = [TJTSTopThreeTableViewCell cellWithTableView:tableView];
            [cell setCellWithDic:self.dataDic];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 3) {
            static NSString * ID = @"TJTSTopFourCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"TJTouSuDetailCell" owner:self options:nil] objectAtIndex:5];
            }
            UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:100];
            label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
            label1.textColor = fivelightColor;
            UILabel * label2 = (UILabel *)[cell.contentView viewWithTag:101];
            label2.font = [UIFont systemFontOfSize:15 * ScaleModel];
            UIImageView * image = (UIImageView *)[cell.contentView viewWithTag:102];
            UIButton * addStep = (UIButton *)[cell.contentView viewWithTag:110];
            [addStep addTarget:self action:@selector(addTSStepAc)];
            if (status == 1) {//显示按钮
                image.hidden = NO;
                addStep.hidden = NO;
                label2.hidden = YES;
            } else {
                image.hidden = YES;
                addStep.hidden = YES;
                label2.hidden = NO;
                if ([self.dataDic[@"procinfo"] isKindOfClass:[NSArray class]]) {
                    label2.text = [NSString stringWithFormat:@"%d步",[self.dataDic[@"procinfo"] count]];
                }else {
                    label2.text = @"";
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            if (self.addTSFlag == 1) {
                TJRepaireAddStepTableViewCell * cell = [TJRepaireAddStepTableViewCell cellWithTableView:tableView];
                [cell setCellWithDic:self.stepDic];
                [cell setDelegate:self];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            return [UITableViewCell new];
        }
    }else if (indexPath.section == 1) {
        if (self.showStep == 0) {
            return [UITableViewCell new];
        }
        TJRepaireStepBaseTableViewCell * cell = [TJRepaireStepBaseTableViewCell cellWithTableView:tableView];
        [cell setCellWithDic:self.dataDic[@"procinfo"][indexPath.row] withTag:indexPath.row];
        [cell setDelegate:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        if (indexPath.row == 0 || [self.dataDic[@"procinfo"] isKindOfClass:[NSString class]]) {//收缩步骤
            if (status == 0) {
                return [UITableViewCell new];
            }
            static NSString * ID = @"TJTSHiddenOrShowCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"TJTouSuDetailCell" owner:self options:nil] objectAtIndex:4];
            }
            UIButton * hiddenOrShow = (UIButton *)[cell.contentView viewWithTag:110];
            [hiddenOrShow addTarget:self action:@selector(showOrhiddenTSStepDetail)];
            UIImageView * image = (UIImageView *)[cell.contentView viewWithTag:100];
            if (self.showStep == 0) {
                image.image = [UIImage imageNamed:@"manager_hidden"];
            } else {
                image.image = [UIImage imageNamed:@"manager_show"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 1){
            if (status == 0) {//立项
                TJTSBottomTableViewCell * cell = [TJTSBottomTableViewCell cellWithTableView:tableView];
                [cell setCellWithDic:self.lixiangDic];
                [cell setDelegate:self];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            if (status == 1) {//完成结果填写
                TJTSBottomTowTableViewCell * cell = [TJTSBottomTowTableViewCell cellWithTableView:tableView];
                [cell setCellWithDic:self.finishDataDic];
                [cell setDelegate:self];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            //完成显示结果
            TJTSFinishTableViewCell * cell = [TJTSFinishTableViewCell cellWithTableView:tableView];
            [cell setCellWithDic:self.dataDic];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            if ([self.dataDic[@"isvisit"] integerValue] == 1) {
                TJNotRepaireBottomTableViewCell * cell = [TJNotRepaireBottomTableViewCell cellWithTableView:tableView];
                [cell setCellWithDic:self.dataDic[@"visitinfo"][0]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            static NSString * ID = @"TJNotRepaireEditeCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepaireElseDetailCell" owner:self options:nil] objectAtIndex:2];
            }
            for (int i = 0; i < 4; i ++) {
                UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
                label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
                label1.textColor = fivelightColor;
            }
            for (int i = 0; i < 4; i ++) {
                UITextField * text = (UITextField *)[cell.contentView viewWithTag:100 + i];
                text.font = fifteenFont;
            }
            for (int i = 0; i < 4; i ++) {
                UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
                view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
                view.borderWidth = 1.0;
                view.cornerRadius = 5.0;
                if (i == 3) {
                    view.borderColor = bordercolor;
                    view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
                }
            }
            for (int i = 0; i < 3; i ++) {
                UIButton * choose = (UIButton *)[cell.contentView viewWithTag:110+i];
                [choose addTarget:self action:@selector(tsChoosePeopleAndTimeAndApprise:)];
            }
            UITextField * huifangName = (UITextField *)[cell.contentView viewWithTag:100];
            huifangName.text = self.elseDataDic[@"clerkname"];
            self.huifangName = huifangName;
            UITextField * huifangTime = (UITextField *)[cell.contentView viewWithTag:101];
            huifangTime.text = self.elseDataDic[@"time"];
            self.huifangTime = huifangTime;
            UITextField * peopleAppraise = (UITextField *)[cell.contentView viewWithTag:102];
            peopleAppraise.text = self.elseDataDic[@"typename"];
            self.peopleAppraise = peopleAppraise;
            UITextField * peopleOpinion = (UITextField *)[cell.contentView viewWithTag:103];
            peopleOpinion.text = self.elseDataDic[@"apprise"];
            peopleOpinion.delegate = self;
            peopleOpinion.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
            peopleOpinion.returnKeyType = UIReturnKeyDone;
            self.peopleOpinion = peopleOpinion;
            UIButton * sure = (UIButton *)[cell.contentView viewWithTag:113];
            sure.cornerRadius = 5.0;
            sure.backgroundColor = [UIColor colorWithHexString:@"ffb400"];
            sure.titleFont = 15 * ScaleModel;
            [sure addTarget:self action:@selector(tsBackAc)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([self.dataDic count] == 0) {
        if ([[User sharedUser].showMidLoading isEqualToString:@"点击进行刷新!"]) {
            [self loadTousuDetailData];
        }
    }
}

#pragma mark - buttonAction
- (void)tsBackAc//回访接口
{
    [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"是否提交信息，确认后将无法修改!" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSString * url = @"wuye/tousuvisitadd.jsp";
            
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            params[@"clerkid"] = userClerkid;
            params[@"billid"] = self.billid;
            params[@"visitclerk"] = self.elseDataDic[@"clerkid"];
            params[@"visittime"] = self.huifangTime.text;
            params[@"backtype"] = self.elseDataDic[@"typeid"];
            params[@"backspec"] = self.peopleOpinion.text;
            [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
                if ([request[@"flag"] integerValue] == 0) {
                    //if (self.jumpFlag == 1) {
                    //  self.rereshHui = 1;
                    //}
                    SVShowSuccess(@"已回访!");
                    self.dataDic = nil;
                    [User sharedUser].showMidLoading = @"数据刷新中...";
                    self.tableView.contentOffset = CGPointMake(0, 0);
                    [self.tableView reloadData];
                    [self loadTousuDetailData];
                    self.dosomethingYes = 1;
                }else {
                    SVShowError(request[@"err"]);
                }
            } failBlock:^(NSError *error) {
                SVShowError(@"网络错误，请重试!");
            }];
        }
    }];
}
- (void)tsChoosePeopleAndTimeAndApprise:(UIButton *)button//回访选择处理人  时间 评价
{
    if (button.tag == 110) {
        TJChooseOrderpeopleViewController * vc = [[TJChooseOrderpeopleViewController alloc] init];
        vc.MyBlock = ^(NSMutableDictionary * dic){
            [self.elseDataDic removeObjectForKey:@"clerkname"];
            [self.elseDataDic removeObjectForKey:@"clerkid"];
            self.huifangName.text = dic[@"clerkname"];
            self.elseDataDic[@"clerkname"] = dic[@"clerkname"];
            self.elseDataDic[@"clerkid"] = dic[@"clerkid"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 111) {
        self.chooseTimeFlag = 4;
        UIView * bgview = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeigth)];
        bgview.backgroundColor = [UIColor blackColor];
        bgview.alpha = 0.2;
        [[UIApplication sharedApplication].keyWindow addSubview:bgview];
        self.bgview = bgview;
        
        _cuiPickerView = [[CuiPickerView alloc]init];
        _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
        _cuiPickerView.backgroundColor = [UIColor whiteColor];
        _cuiPickerView.myTextField = self.huifangTime;
        _cuiPickerView.string = self.huifangTime.text;
        
        _cuiPickerView.delegate = self;
        _cuiPickerView.curDate=[NSDate date];
        [[UIApplication sharedApplication].keyWindow addSubview:_cuiPickerView];
        [_cuiPickerView showInView:[UIApplication sharedApplication].keyWindow];
    }
    if (button.tag == 112) {
        YYCache * cache = [TJCache shareCache].yyCache;
        NSData * data = (id)[cache objectForKey:@"complaintBaseData"];
        NSMutableDictionary * dataDic = [data toDictionary];
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < [dataDic[@"backtypelist"] count]; i ++) {
            [array addObject:dataDic[@"backtypelist"][i][@"typename"]];
        }
        CGSize originxS = [@"客户评价:" getStringRectWithfontSize:15*ScaleModel width:0];
        
        [[HSMidlabelView sharedInstance] setOriginX:originxS.width + 37 andOriginY:64 + self.tableView.contentSize.height - self.scrollY - 161 - fifteenS.height * 2 - 34 * array.count + 4 andWidth:133 andHeight:34 * array.count andData:array withString:self.peopleAppraise.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.elseDataDic removeObjectForKey:@"typeid"];
            [self.elseDataDic removeObjectForKey:@"typename"];
            self.peopleAppraise.text = dic[@"label"];
            self.elseDataDic[@"typeid"] = dataDic[@"backtypelist"][[dic[@"index"] integerValue]][@"typeid"];
            self.elseDataDic[@"typename"] = dataDic[@"backtypelist"][[dic[@"index"] integerValue]][@"typename"];
        }];
    }
}
- (void)showOrhiddenTSStepDetail
{
    [self removeTSStepData];
    if (self.showStep == 0) {
        self.showStep = 1;
    } else {
        self.showStep = 0;
    }
    [self.tableView reloadData];
}
- (void)addTSStepAc
{
    self.showStep = 0;
    [self removeTSStepData];
    if (self.addTSFlag == 0) {
        self.addTSFlag = 1;
        self.tableView.contentOffset = CGPointMake(0, self.scrollY + 187 + 3 * fifteenS.height);
    } else {
        self.addTSFlag = 0;
        self.tableView.contentOffset = CGPointMake(0, self.scrollY - 187 - 3 * fifteenS.height);
    }
    [self.tableView reloadData];
}
#pragma mark - top delete
- (void)hiddenOrShowTop
{
    if (self.topHidden == 0) {
        self.topHidden = 1;
    } else {
        self.topHidden = 0;
    }
    [self.tableView reloadData];
}
- (void)selectImageFromCollectionview:(UICollectionView *)collectionView andIndex:(NSInteger)index andImageArray:(NSMutableArray *)imageArray
{
    [self.imageArray removeAllObjects];
    [self.imageArray addObjectsFromArray:imageArray];
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = collectionView; // 原图的父控件
    browser.imageCount = [imageArray count];
    browser.currentImageIndex = (int)index;
    browser.delegate = self;
    [browser show];
}

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView * image = [UIImageView new];
    [image sd_setImageWithURL:self.imageArray[index] placeholderImage:[UIImage imageNamed:@"home_photo"]];
    return image.image;
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return self.imageArray[index];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger count = [self.imageArray count];
    
    CGFloat w = kScreenWidth - 10 - 70;
    CGFloat h = (kScreenWidth - 10 - 70) * 0.9;
    static CGFloat interval = 3;
    
    if (count == 1) {
        return CGSizeMake( w, h );
    }else if ( count == 4 ) {
        return CGSizeMake( (w-interval) / 2, (h-interval) / 2  );
    }else if ( count == 9 ) {
        return CGSizeMake( (w-interval*2) / 3, (h-interval*2) / 3  );
    }
    
    return CGSizeMake(1,1);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 3.0f;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 3.0f;
}
#pragma mark - TJRepaireAddStepCell  delegate
- (void)chooseStepPeople//选择处理人
{
    TJChooseOrderpeopleViewController * vc = [[TJChooseOrderpeopleViewController alloc] init];
    vc.MyBlock = ^(NSMutableDictionary * dic){
        [self.stepDic removeObjectForKey:@"clerkid"];
        [self.stepDic removeObjectForKey:@"clerkname"];
        self.stepDic[@"clerkname"] = dic[@"clerkname"];
        self.stepDic[@"clerkid"] = dic[@"clerkid"];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)chooseStepTime:(UITextField *)text//选择处理时间
{
    self.chooseTimeFlag = 2;
    UIView * bgview = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeigth)];
    bgview.backgroundColor = [UIColor blackColor];
    bgview.alpha = 0.2;
    [[UIApplication sharedApplication].keyWindow addSubview:bgview];
    self.bgview = bgview;
    
    _cuiPickerView = [[CuiPickerView alloc]init];
    _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
    _cuiPickerView.backgroundColor = [UIColor whiteColor];
    _cuiPickerView.myTextField = text;
    _cuiPickerView.string = text.text;
    _cuiPickerView.delegate = self;
    _cuiPickerView.curDate=[NSDate date];
    [[UIApplication sharedApplication].keyWindow addSubview:_cuiPickerView];
    [_cuiPickerView showInView:[UIApplication sharedApplication].keyWindow];
}
- (void)pushImage//上传图片
{
    TJPushImageViewController * vc = [[TJPushImageViewController alloc] init];
    vc.billid = self.billid;
    vc.imageCount = 3;
    vc.haveImageArray = [NSMutableArray arrayWithArray:self.addImageArray];
    vc.MyBlock = ^(NSMutableArray * imageArray){
        [self.addImageArray removeAllObjects];
        [self.addImageArray addObjectsFromArray:imageArray];
        [self.stepDic removeObjectForKey:@"count"];
        self.stepDic[@"count"] = @(imageArray.count);
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)submitStep//上传步骤
{
    NSString * pprocpic = [NSString string];
    if (self.addImageArray.count == 0) {
        pprocpic = @"";
    }else {
        for (int i = 0; i < self.addImageArray.count; i ++) {
            pprocpic = [NSString stringWithFormat:@"%@%@^",pprocpic,self.addImageArray[i]];
        }
        pprocpic = [pprocpic substringToIndex:pprocpic.length - 1];
    }
    NSString * url = @"wuye/tousuprocadd.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"billid"] = self.billid;
    params[@"procclerk"] = self.stepDic[@"clerkid"];
    params[@"proctime"] = self.stepDic[@"time"];
    params[@"proccontent"] = self.stepDic[@"content"];
    params[@"pprocpic"] = pprocpic;
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(@"添加成功!");
            self.addTSFlag = 0;
            [self.addImageArray removeAllObjects];//清除图片
            [self removeTSStepData];//重置步骤数据
            self.dataDic = nil;
            [User sharedUser].showMidLoading = @"数据刷新中...";
            self.tableView.contentOffset = CGPointMake(0, 0);
            [self.tableView reloadData];
            [self loadTousuDetailData];
            self.dosomethingYes = 1;
        }else {
            SVShowError(request[@"err"]);
        }
    } failBlock:^(NSError *error) {
        SVShowError(@"网络错误，请重试!");
    }];
}
- (void)textEditBegin//开始输入处理内容
{
    self.textFlag = 1;//添加步骤处理内容编辑
    self.orginNumber = self.scrollY;
    self.tableView.frame = Rect(0,208 - 36 + 2 * fifteenS.height- (self.tableView.contentSize.height - kScreenHeigth + 64)- 230, kScreenWidth, self.tableView.contentSize.height);
}
- (void)textEditEnd:(UITextField *)text//完成输入
{
    [self.stepDic removeObjectForKey:@"content"];
    self.stepDic[@"content"] = text.text;
    [self.tableView reloadData];
}
- (void)removeTSStepData
{
    [self.stepDic removeObjectForKey:@"clerkid"];
    [self.stepDic removeObjectForKey:@"clerkname"];
    [self.stepDic removeObjectForKey:@"time"];
    [self.stepDic removeObjectForKey:@"content"];
    [self.stepDic removeObjectForKey:@"count"];
    self.stepDic[@"clerkid"] = userClerkid;
    self.stepDic[@"clerkname"] = [User sharedUser].userInfo[@"clerkname"];
    self.stepDic[@"time"] = [[User sharedUser] getNowTimeHaveHM];
    self.stepDic[@"content"] = @"";
    self.stepDic[@"count"] = @"0";
}
#pragma mark - bottom delete
- (void)sureLixiang//确定立项
{
    NSString * url = @"wuye/tousuapprove.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"billid"] = self.billid;
    params[@"approveclerk"] = self.lixiangDic[@"lixiangid"];
    params[@"approvetime"] = self.lixiangDic[@"lixiangtime"];
    params[@"leaderid"] = self.lixiangDic[@"zerenid"];
    params[@"procflow"] = self.lixiangDic[@"content"];
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(@"立项成功!");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [User sharedUser].showMidLoading = @"数据加载中...";
                self.dataDic = nil;
                self.tableView.contentOffset = CGPointMake(0, 0);
                [self.tableView reloadData];
                [self loadTousuDetailData];
                self.dosomethingYes = 1;
            });
        }else {
            SVShowError(request[@"err"]);
        }
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        SVShowError(@"网络错误，请重试!");
    }];
}
- (void)chooseLIxiangPeople
{
    TJChooseOrderpeopleViewController * vc = [[TJChooseOrderpeopleViewController alloc] init];
    vc.MyBlock = ^(NSMutableDictionary * dic){
        [self.lixiangDic removeObjectForKey:@"lixiangname"];
        [self.lixiangDic removeObjectForKey:@"lixiangid"];
        self.lixiangDic[@"lixiangname"] = dic[@"clerkname"];
        self.lixiangDic[@"lixiangid"] = dic[@"clerkid"];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)chooseLixiangTime:(UITextField *)text
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
    _cuiPickerView.myTextField = text;
    _cuiPickerView.string = text.text;
    
    _cuiPickerView.delegate = self;
    _cuiPickerView.curDate=[NSDate date];
    [[UIApplication sharedApplication].keyWindow addSubview:_cuiPickerView];
    [_cuiPickerView showInView:[UIApplication sharedApplication].keyWindow];
}
- (void)chooseZerenPeople
{
    TJChooseOrderpeopleViewController * vc = [[TJChooseOrderpeopleViewController alloc] init];
    vc.MyBlock = ^(NSMutableDictionary * dic){
        [self.lixiangDic removeObjectForKey:@"zerenname"];
        [self.lixiangDic removeObjectForKey:@"zerenid"];
        self.lixiangDic[@"zerenname"] = dic[@"clerkname"];
        self.lixiangDic[@"zerenid"] = dic[@"clerkid"];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-  (void)textBeginEdit
{
    self.orginNumber = self.scrollY;
    self.tableView.frame = Rect(0,0 - (self.tableView.contentSize.height - kScreenHeigth + 64)- 230, kScreenWidth, self.tableView.contentSize.height);
}
- (void)textreturn:(NSString *)text
{
    [self.lixiangDic removeObjectForKey:@"content"];
    self.lixiangDic[@"content"] = text;
    [self.tableView reloadData];
}
- (void)didFinishPickView:(NSString *)date
{
    if (self.chooseTimeFlag == 1) {//立项时间
        self.lixiangDic[@"lixiangtime"] = date;
        if (date.length == 0) {
            self.lixiangDic[@"lixiangtime"] = [[User sharedUser] getNowTimeHaveHM];
        }
    }
    if (self.chooseTimeFlag == 2) {//处理步骤的时间
        [self.stepDic removeObjectForKey:@"time"];
        self.stepDic[@"time"] = date;
        if (date.length == 0) {
            self.stepDic[@"time"] = [[User sharedUser] getNowTimeHaveHM];
        }
    }
    if (self.chooseTimeFlag == 3) {//完成时间
        [self.finishDataDic removeObjectForKey:@"finishtime"];
        self.finishDataDic[@"finishtime"] = date;
        if (date.length == 0) {
            self.finishDataDic[@"finishtime"] = [[User sharedUser] getNowTimeHaveHM];
        }
    }
    [self.tableView reloadData];
    if (self.chooseTimeFlag == 4) {//回访时间
        self.huifangTime.text = date;
        if (date.length == 0) {
            self.huifangTime.text = [[User sharedUser] getNowTimeHaveHM];
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
#pragma mark - finishelegate
- (void)finishTextreturn:(NSString *)text
{
    [self.finishDataDic removeObjectForKey:@"finishcontent"];
    self.finishDataDic[@"finishcontent"] = text;
    [self.tableView reloadData];
}
- (void)choosefinishtime:(UITextField *)text
{
    self.chooseTimeFlag = 3;
    UIView * bgview = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeigth)];
    bgview.backgroundColor = [UIColor blackColor];
    bgview.alpha = 0.2;
    [[UIApplication sharedApplication].keyWindow addSubview:bgview];
    self.bgview = bgview;
    
    _cuiPickerView = [[CuiPickerView alloc]init];
    _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
    _cuiPickerView.backgroundColor = [UIColor whiteColor];
    _cuiPickerView.myTextField = text;
    _cuiPickerView.string = text.text;
    
    _cuiPickerView.delegate = self;
    _cuiPickerView.curDate=[NSDate date];
    [[UIApplication sharedApplication].keyWindow addSubview:_cuiPickerView];
    [_cuiPickerView showInView:[UIApplication sharedApplication].keyWindow];
}
- (void)finishTextBeginEdit
{
    self.orginNumber = self.scrollY;
    self.tableView.frame = Rect(0,0 - (self.tableView.contentSize.height - kScreenHeigth + 64)- 230, kScreenWidth, self.tableView.contentSize.height);
}
- (void)finishSure
{
    NSString * url = @"wuye/tousufinish.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"billid"] = self.billid;
    params[@"finishtime"] = self.finishDataDic[@"finishtime"];
    params[@"procresult"] = self.finishDataDic[@"finishcontent"];
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(@"处理成功!");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.addTSFlag = 0;
                [User sharedUser].showMidLoading = @"数据加载中...";
                self.dataDic = nil;
                self.tableView.contentOffset = CGPointMake(0, 0);
                [self.tableView reloadData];
                [self loadTousuDetailData];
                self.dosomethingYes = 1;
            });
        }else {
            SVShowError(request[@"err"]);
        }
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        SVShowError(@"网络错误，请重试!");
    }];
}
#pragma mark- jianpan delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.scrollY = scrollView.contentOffset.y;
}
- (void)AddTSBottomKeyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height1 = keyboardRect.size.height;
    if (self.orginNumber == 0) {
        self.orginNumber = self.tableView.contentSize.height - self.tableView.height;
    }
    self.flag = 1;
}
- (void)AddTSBottomKeyboardWillHide:(NSNotification *)aNotification
{
    self.flag = 0;
    self.tableView.frame = Rect(0, 64, kScreenWidth, kScreenHeigth - 64);
    self.tableView.contentOffset = CGPointMake(0, self.orginNumber);
    self.orginNumber = 0;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.huifangTime.text) {
        
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.huifangTime.text) {
        self.orginNumber = self.scrollY;
        self.tableView.frame = Rect(0,0 - (self.tableView.contentSize.height - kScreenHeigth + 64)- 230, kScreenWidth, self.tableView.contentSize.height);
    }
}
#pragma mark - netWorking
- (void)loadTousuDetailData
{
    NSString * url = @"wuye/tousubilldetail.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"billid"] = self.billid;
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:request[@"data"]];
        }else {
            SVShowError(request[@"err"]);
            [User sharedUser].showMidLoading = @"点击进行刷新!";
        }
        [self.tableView reloadData];
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
