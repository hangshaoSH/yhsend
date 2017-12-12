//
//  TJRepaireDetailViewController.m
//  baseXcode
//
//  Created by hangshao on 16/12/2.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJRepaireDetailViewController.h"
#import "TJRepaireDetailTopTableViewCell.h"
#import "TJRepaireDetailTopNextTableViewCell.h"
#import "TJRepaireShowPeopleTableViewCell.h"
#import "TJChooseOrderpeopleViewController.h"
#import "TJRepaireAddStepTableViewCell.h"
#import "TJRepaireStepBaseTableViewCell.h"
#import "TJPushImageViewController.h"
@interface TJRepaireDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,TJRepaireDetailNextTopDelegate,TJRepaireShowDelegate,CuiPickViewDelegate,TJRepaireAddStepDelegate,SDPhotoBrowserDelegate,TJRepaireStepBaseDelegate,TJRepaireTopDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   weak) UITextField     * jiedanhsijian;
@property (nonatomic,   weak) UITextField     * jiedanren;
@property (nonatomic,   weak) UIView     * bgview;
@property (nonatomic,   strong) CuiPickerView     * cuiPickerView;
@property (nonatomic,   strong) NSString     * acceptclerk;
@property (nonatomic,   assign) NSInteger   hiddenStepDetail;//显示步骤0  1不显示
@property (nonatomic,   assign) NSInteger   addStep;//添加步骤1  0隐藏
@property (nonatomic,   assign) NSInteger   isShouldRepaire;//是否需要维修0维修   1不维修
@property (nonatomic,   assign) NSInteger   getOrNoPayRepaire;//是否无偿维修0付钱   1无偿
@property (nonatomic,   strong) NSMutableDictionary     * repaireStepDic;//添加维修步骤的储存数据
@property (nonatomic,   assign) NSInteger  chooseTimeFlag;//0未排单  1添加步骤选择时间
@property (nonatomic,   assign) CGFloat   scrollY;
@property (nonatomic,   assign) CGFloat   orginNumber;
@property (nonatomic,   assign) NSInteger  flag;
@property (nonatomic,   assign) NSInteger  textFlag;
@property (nonatomic,   assign) NSInteger  nextFlag;
@property (nonatomic,   strong) NSMutableArray     * imageArray;//步骤添加的图片
@property (nonatomic,   strong) NSMutableArray     * imageArray1;//维修前添加的图片
@property (nonatomic,   strong) NSMutableArray     * imageArray2;//维修后添加的图片
@property (nonatomic,   strong) NSMutableDictionary     * beforeRepaireata;//维修前后 等图片数据
@property (nonatomic,   strong) NSMutableArray     * stepImageArray;//步骤显示图片
@property (nonatomic,   weak) UITextField     * notRepaireSay;//不维修说明
@property (nonatomic,   weak) UITextField     * beginTime;
@property (nonatomic,   weak) UITextField     * endTime;
@property (nonatomic,   weak) UITextField     * repairePeople;
@property (nonatomic,   weak) UITextField     * repaireResult;
@property (nonatomic,   weak) UITextField     * repaireProject;
@property (nonatomic,   weak) UITextField     * rengongfee;
@property (nonatomic,   weak) UITextField     * cailiaofee;
@property (nonatomic,   weak) UITextField     * otherfee;
@property (nonatomic,   weak) UITextField     * allfee;
@property (nonatomic,   assign) NSInteger  refreshDetail;
@end

@implementation TJRepaireDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDataSource];
    
    [self setTableView];
    
    [self loadOrderData];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AddStpeRepaireKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AddStpeRepaireKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
#pragma mark - setView
- (void)setDataSource
{
    self.repaireStepDic = [NSMutableDictionary dictionary];
    self.repaireStepDic[@"clerkid"] = userClerkid;
    self.repaireStepDic[@"clerkname"] = [User sharedUser].userInfo[@"clerkname"];
    self.repaireStepDic[@"time"] = [[User sharedUser] getNowTimeHaveHM];
    self.repaireStepDic[@"content"] = @"";
    self.repaireStepDic[@"count"] = @"0";
    
    self.beforeRepaireata = [NSMutableDictionary dictionary];
    YYCache * cache = [TJCache shareCache].yyCache;
    NSData * data = (id)[cache objectForKey:@"baoxiuBaseData"];
    NSMutableDictionary * dic = [data toDictionary];
    self.beforeRepaireata[@"mendproid"] = dic[@"mendprolist"][0][@"mendproid"];
    self.beforeRepaireata[@"mendproname"] = dic[@"mendprolist"][0][@"mendproname"];
    self.beforeRepaireata[@"clerkid"] = userClerkid;
    self.beforeRepaireata[@"clerkname"] = [User sharedUser].userInfo[@"clerkname"];
    self.beforeRepaireata[@"wxbegin"] = @"";
    self.beforeRepaireata[@"wxend"] = @"";
    self.beforeRepaireata[@"wxmins"] = @"";
    self.beforeRepaireata[@"wxcontent"] = @"";
    self.beforeRepaireata[@"beforepics"] = @"";
    self.beforeRepaireata[@"afterpics"] = @"";
    self.beforeRepaireata[@"wxfee"] = @"";
    self.beforeRepaireata[@"rengongfee"] = @"";
    self.beforeRepaireata[@"cailiaofee"] = @"";
    self.beforeRepaireata[@"otherfee"] = @"";
    
    
    self.hiddenStepDetail = 1;
    self.imageArray = [NSMutableArray arrayWithCapacity:0];
    self.imageArray1 = [NSMutableArray arrayWithCapacity:0];
    self.imageArray2 = [NSMutableArray arrayWithCapacity:0];
    self.stepImageArray = [NSMutableArray arrayWithCapacity:0];
    self.addStep = 0;
    self.isShouldRepaire = 0;
    self.getOrNoPayRepaire = 1;
    self.acceptclerk = [NSString string];
    if (self.jumpFlag==2) {
        self.acceptclerk = userClerkid;
    }
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
    wself.ts_navgationBar = [TSNavigationBar navWithTitle:@"报修单详情" backAction:^{
        [YHNetWork stopTheVcRequset:wself];
        if (self.jumpFlag == 1 && self.refreshDetail == 1) {
            if (self.MyBlock) {
                self.MyBlock();
            }
        }
        if (self.jumpFlag == 0) {
            if (self.MyBlock) {
                self.MyBlock();
            }
        }
        [wself.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger status = [self.dataDic[@"billsta"] integerValue];
    if (status == 0) {
        return 1;
    }
    if ([self.dataDic count] == 0) {
        return 1;
    }
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataDic count] == 0) {//0未派单  1已派单  2待修中  3进行中  5已完成未回访  6已完成已回访  9不维修
        return 1;
    }
    if (section == 0) {
        return 3;
    } else if (section == 1) {//步骤
        if (self.addStep == 1) {
            return 1;
        }
        if (self.hiddenStepDetail == 1) {
            return 0;
        }
        return [self.dataDic[@"procinfo"] count];
    } else {
        return 4;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataDic count] == 0) {//0未派单   || 1已派单  2待修中  3进行中   ||   5已完成未回访  6已完成已回访  9不维修
        return self.tableView.height;
    }
    NSInteger status = [self.dataDic[@"billsta"] integerValue];
    if (indexPath.section==0) {
        if (indexPath.row == 0) {
            CGSize s = [self.dataDic[@"msgcontent"] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-42];
            if ([self.dataDic[@"hiddenImage"] integerValue] == 1) {
                return 121 + 4*fifteenS.height + s.height;
            } else {
                return 121 + 63 + 4*fifteenS.height + s.height;
            }
        }else if (indexPath.row == 1) {
            if ([self.dataDic[@"hiddenTop"] integerValue] == 1) {
                return 40;
            }
            return 133+fifteenS.height*4;
        }else {
            if (status == 0) {
                return 178-36+2*fifteenS.height;
            }
            if (status == 1 || status == 2 || status == 3) {
                return 142 - 36+2*fifteenS.height;
            }
            return 0;
        }
    }else if (indexPath.section == 1) {//处理步骤  无步骤 隐藏
        if (self.addStep == 1) {//显示添加步骤
            return 187 + 3 * fifteenS.height;
        }
        if (self.hiddenStepDetail == 0) {//显示步骤
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
        }
        return 0;
    }else {
        if (indexPath.row == 0) {//伸缩步骤按钮
            if (self.addStep == 1) {
                return 0;
            }
            if ([self.dataDic[@"procinfo"] count] == 0) {
                return 0;
            }
            return 41;
        }else if (indexPath.row == 1) {//不需要维修按钮
            if (self.isShouldRepaire == 0) {
                return 415;
            }
            return 42;
        }else if (indexPath.row == 2) {//人工费用显示
            if (self.getOrNoPayRepaire == 1 || self.isShouldRepaire == 1) {
                return 0;
            }
            return 216;
        } else {//确定按钮
            if (self.isShouldRepaire == 0) {
                return 67;
            }
            return 150;
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
    NSInteger status = [self.dataDic[@"billsta"] integerValue];
    if (indexPath.section ==0 ) {
        if (indexPath.row == 0) {
            TJRepaireDetailTopTableViewCell * cell = [TJRepaireDetailTopTableViewCell cellWithTableView:tableView];
            [cell setCellWithDic:self.dataDic];
            [cell setDelegate:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 1) {
            TJRepaireDetailTopNextTableViewCell * cell = [TJRepaireDetailTopNextTableViewCell cellWithTableView:tableView];
            [cell setCellWithDic:self.dataDic];
            [cell setDelegate:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            if (status == 0) {
                static NSString * ID = @"TJRepireDetailJieDanPeopleCell";
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepireDetailCell" owner:self options:nil] objectAtIndex:2];
                }
                for (int i = 0; i < 2; i ++) {
                    UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
                    label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
                    label1.textColor = fivelightColor;
                }
                for (int i = 0; i < 2; i ++) {
                    UITextField * text = (UITextField *)[cell.contentView viewWithTag:100 + i];
                    text.font = fifteenFont;
                }
                for (int i = 0; i < 2; i ++) {
                    UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
                    view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
                    view.borderWidth = 1.0;
                    view.cornerRadius = 5.0;
                }
                for (int i = 0; i < 2; i ++) {
                    UIButton * choose = (UIButton *)[cell.contentView viewWithTag:110+i];
                    [choose addTarget:self action:@selector(choosePeopleAndTime:)];
                }
                UITextField * jieadnren = (UITextField *)[cell.contentView viewWithTag:100];
                if (self.jumpFlag == 2) {
//                    jieadnren.text = [User sharedUser].userInfo[@"clerkname"];
                }
                self.jiedanren = jieadnren;
                UITextField * jiedanhsijian = (UITextField *)[cell.contentView viewWithTag:101];
                self.jiedanhsijian = jiedanhsijian;
                UIButton * sure = (UIButton *)[cell.contentView viewWithTag:112];
                sure.cornerRadius = 5.0;
                sure.backgroundColor = [UIColor colorWithHexString:@"ffb400"];
                sure.titleFont = 15 * ScaleModel;
                [sure addTarget:self action:@selector(repaireDetailSuerAc)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            if (status == 1 || status == 2 || status == 3) {
                TJRepaireShowPeopleTableViewCell * cell = [TJRepaireShowPeopleTableViewCell cellWithTableView:tableView];
                [cell setCellWithDic:self.dataDic[@"acceptinfo"]];
                [cell setDelegate:self];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            return [UITableViewCell new];
        }
    }else if ( indexPath.section == 1) {
        if (self.addStep == 1) {
            TJRepaireAddStepTableViewCell * cell = [TJRepaireAddStepTableViewCell cellWithTableView:tableView];
            [cell setCellWithDic:self.repaireStepDic];
            [cell setDelegate:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            if (self.hiddenStepDetail == 1) {
                return [UITableViewCell new];
            }
            TJRepaireStepBaseTableViewCell * cell = [TJRepaireStepBaseTableViewCell cellWithTableView:tableView];
            [cell setCellWithDic:self.dataDic[@"procinfo"][indexPath.row] withTag:indexPath.row];
            [cell setDelegate:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else {
        if (indexPath.row == 0) {
            static NSString * ID = @"TJRepaireHiddenOrShowDetailCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepaireElseDetailCell" owner:self options:nil] objectAtIndex:13];
            }
            UIButton * hiddenOrShow = (UIButton *)[cell.contentView viewWithTag:110];
            [hiddenOrShow addTarget:self action:@selector(showOrhiddenStepDetail)];
            UIImageView * image = (UIImageView *)[cell.contentView viewWithTag:100];
            if (self.hiddenStepDetail == 1) {
                image.image = [UIImage imageNamed:@"manager_hidden"];
            } else {
                image.image = [UIImage imageNamed:@"manager_show"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 1) {
            static NSString * ID = @"TJRepireRepaireBeforAndLongCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepireDetailCell" owner:self options:nil] objectAtIndex:6];
            }
            for (int i = 0; i < 7; i ++) {
                UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
                label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
                label1.textColor = fivelightColor;
            }
            for (int i = 0; i < 5; i ++) {
                UITextField * text = (UITextField *)[cell.contentView viewWithTag:100 + i];
                text.font = fifteenFont;
            }
            for (int i = 0; i < 5; i ++) {
                UIView * view = (UIView *)[cell.contentView viewWithTag:300 + i];
                view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
                view.borderWidth = 1.0;
                view.cornerRadius = 5.0;
                if (i == 2) {
                    view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
                    view.borderColor = bordercolor;
                }
            }
            UIView * bgview = (UIView *)[cell.contentView viewWithTag:555];
            UILabel * pushRepaireBefor = (UILabel *)[cell.contentView viewWithTag:98];
            pushRepaireBefor.font = [UIFont systemFontOfSize:15 * ScaleModel];
            if (self.imageArray1.count > 0) {
                pushRepaireBefor.text = [NSString stringWithFormat:@"已上传%lu张",(unsigned long)self.imageArray1.count];
            }else {
                pushRepaireBefor.text = @"上传维修前图片";
            }
            pushRepaireBefor.textColor = fiveblueColor;
            UILabel * pushRepaireAfter = (UILabel *)[cell.contentView viewWithTag:99];
            pushRepaireAfter.font = [UIFont systemFontOfSize:15 * ScaleModel];
            pushRepaireAfter.textColor = fiveblueColor;
            if (self.imageArray2.count > 0) {
                pushRepaireAfter.text = [NSString stringWithFormat:@"已上传%lu张",(unsigned long)self.imageArray2.count];
            }else {
                pushRepaireAfter.text = @"上传维修后图片";
            }
            UISwitch * topSwitch = (UISwitch *)[cell.contentView viewWithTag:110];
            [topSwitch addTarget:self action:@selector(topSwitchAction:) forControlEvents:UIControlEventValueChanged];
            if (self.isShouldRepaire == 0) {
                topSwitch.on = NO;
                bgview.hidden = NO;
            } else {
                topSwitch.on = YES;
                bgview.hidden = YES;
            }
            UISwitch * bottomSwitch = (UISwitch *)[cell.contentView viewWithTag:117];
            [bottomSwitch addTarget:self action:@selector(bottomSwitchAction:) forControlEvents:UIControlEventValueChanged];
            if (self.getOrNoPayRepaire == 1) {
                bottomSwitch.on = YES;
            } else {
                bottomSwitch.on = NO;
            }
            for (int i = 0; i < 6; i ++) {
                UIButton * choose = (UIButton *)[cell.contentView viewWithTag:111+i];
                [choose addTarget:self action:@selector(repaireDetailAllButton:)];
                if (i == 0 || i == 1) {
                    choose.cornerRadius = 5.0;
                    choose.borderColor = fiveblueColor;
                    choose.borderWidth = 0.7;
                }
            }
            UITextField * repairePeople = (UITextField *)[cell.contentView viewWithTag:700];
            self.repairePeople = repairePeople;
            UITextField * repaireProject = (UITextField *)[cell.contentView viewWithTag:701];
            self.repaireProject = repaireProject;
            UITextField * repaireResult = (UITextField *)[cell.contentView viewWithTag:702];
            repaireResult.delegate = self;
            repaireResult.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
            repaireResult.returnKeyType = UIReturnKeyDone;
            self.repaireResult = repaireResult;
            UITextField * beginTime = (UITextField *)[cell.contentView viewWithTag:703];
            self.beginTime = beginTime;
            UITextField * endTime = (UITextField *)[cell.contentView viewWithTag:704];
            self.endTime = endTime;
            repairePeople.text = self.beforeRepaireata[@"clerkname"];
            repaireProject.text = self.beforeRepaireata[@"mendproname"];
            if ([self.beforeRepaireata[@"wxcontent"] length] > 0) {
                repaireResult.text = self.beforeRepaireata[@"wxcontent"];
            }
            if ([self.beforeRepaireata[@"wxend"] length] > 0) {
                endTime.text = self.beforeRepaireata[@"wxend"];
            }
            if ([self.beforeRepaireata[@"wxbegin"] length] > 0) {
                beginTime.text = self.beforeRepaireata[@"wxbegin"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 2) {
            static NSString * ID = @"TJRepireDetailSomePayCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepireDetailCell" owner:self options:nil] objectAtIndex:7];
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
            }
            UITextField * rengongfee = (UITextField *)[cell.contentView viewWithTag:705];
            rengongfee.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
            self.rengongfee = rengongfee;
            UITextField * cailiaofee = (UITextField *)[cell.contentView viewWithTag:706];
            cailiaofee.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
            self.cailiaofee = cailiaofee;
            UITextField * otherfee = (UITextField *)[cell.contentView viewWithTag:707];
            otherfee.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
            self.otherfee = otherfee;
            UITextField * allfee = (UITextField *)[cell.contentView viewWithTag:708];
            self.allfee = allfee;
            rengongfee.delegate = self;
            rengongfee.returnKeyType = UIReturnKeyNext;
            cailiaofee.delegate = self;
            cailiaofee.returnKeyType = UIReturnKeyNext;
            otherfee.delegate = self;
            otherfee.returnKeyType = UIReturnKeyDone;
            allfee.delegate = self;
            allfee.userInteractionEnabled = NO;
            if ([self.beforeRepaireata[@"rengongfee"] length] > 0) {
                 rengongfee.text = self.beforeRepaireata[@"rengongfee"];
            }
            if ([self.beforeRepaireata[@"cailiaofee"] length] > 0) {
                cailiaofee.text = self.beforeRepaireata[@"cailiaofee"];
            }
            if ([self.beforeRepaireata[@"otherfee"] length] > 0) {
                otherfee.text = self.beforeRepaireata[@"otherfee"];
            }
            allfee.text = [NSString stringWithFormat:@"%.2f",[self.beforeRepaireata[@"rengongfee"] floatValue] + [self.beforeRepaireata[@"cailiaofee"] floatValue] + [self.beforeRepaireata[@"otherfee"] floatValue]];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            static NSString * ID = @"TJRepireDetailSureBottomCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepireDetailCell" owner:self options:nil] objectAtIndex:8];
            }
            UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:100];
            label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
            label1.textColor = fivelightColor;
            UITextField * text = (UITextField *)[cell.contentView viewWithTag:50];
            text.delegate = self;
            text.font = fifteenFont;
            text.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
            self.notRepaireSay = text;
            UIView * view = (UIView *)[cell.contentView viewWithTag:201];
            view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
            view.borderColor = bordercolor;
            view.borderWidth = 1.0;
            view.cornerRadius = 5.0;
            UIButton * sureBut = (UIButton *)[cell.contentView viewWithTag:110];
            sureBut.titleFont = 15 * ScaleModel;
            sureBut.cornerRadius = 5.0;
            sureBut.backgroundColor = orangecolor;
            [sureBut addTarget:self action:@selector(sureSendData)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([self.dataDic count] == 0) {
        if ([[User sharedUser].showMidLoading isEqualToString:@"点击进行刷新!"]) {
            [User sharedUser].showMidLoading = @"数据加载中...";
            [self.tableView reloadData];
            [self loadOrderData];
        }
    }
}

#pragma mark - buttonAction
- (void)sureSendData//提交单子
{
    if (self.isShouldRepaire == 1) {
        if (self.notRepaireSay.text.length == 0) {
            SVShowError(@"请填写不维修说明!");
            return;
        }
    }
    if (self.isShouldRepaire == 0) {
        if (self.repaireResult.text.length == 0) {
            SVShowError(@"请输入维修结果!");
            return;
        }
        if (self.beginTime.text.length==0) {
            SVShowError(@"请选择维修开始时间!");
            return;
        }
        if (self.endTime.text.length==0) {
            SVShowError(@"请选择维修开始时间!");
            return;
        }
    }
    [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"是否提交信息，确认后将无法修改!" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self suerSend];
        }
    }];
}
- (void)suerSend
{
    if (self.isShouldRepaire == 1) {//不维修
        NSString * url = @"wuye/mendbillsta.jsp";
        
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"clerkid"] = userClerkid;
        params[@"billid"] = self.billid;
        params[@"billsta"] = @"9";
        params[@"replycontent"] = self.notRepaireSay.text;
        [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
            if ([request[@"flag"] integerValue] == 0) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                dic[@"flag"] = @"1";
                dic[@"billid"] = self.billid;
                SVShowSuccess(@"处理成功!");
                [self.navigationController popViewControllerAnimated:NO];
                if (self.jumpFlag == 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notRepaire" object:nil userInfo:dic];
                }else if (self.jumpFlag == 2){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"projectnotRepaire" object:nil userInfo:dic];
                }else if (self.jumpFlag == 3){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"homenotRepaire" object:nil userInfo:dic];
                }else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notElseRepaire" object:nil userInfo:dic];
                }
            }else {
                SVShowSuccess(request[@"err"]);
            }
        } failBlock:^(NSError *error) {
            SVShowError(@"网络错误，请重试!");
        }];
    }else {
        NSString * wxfee = [NSString string];
        NSString * rengongfee = [NSString string];
        NSString * cailiaofee = [NSString string];
        NSString * otherfee = [NSString string];
        if (self.getOrNoPayRepaire == 0) {
            otherfee = self.beforeRepaireata[@"otherfee"];
            cailiaofee = self.beforeRepaireata[@"cailiaofee"];
            rengongfee = self.beforeRepaireata[@"rengongfee"];
            wxfee = @"1";
        } else {
            wxfee = @"0";
            otherfee = @"";
            cailiaofee = @"";
            rengongfee = @"";
        }
        NSString * url = @"wuye/mendwxadd.jsp";
        
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"clerkid"] = userClerkid;
        params[@"billid"] = self.billid;
        params[@"wxclerk"] = self.beforeRepaireata[@"clerkid"];
        params[@"wxproject"] = self.beforeRepaireata[@"mendproid"];
        params[@"wxbegin"] = self.beforeRepaireata[@"wxbegin"];
        params[@"wxend"] = self.beforeRepaireata[@"wxend"];
        params[@"wxmins"] = self.beforeRepaireata[@"wxmins"];
        params[@"wxcontent"] = self.beforeRepaireata[@"wxcontent"];
        params[@"beforepics"] = self.beforeRepaireata[@"beforepics"];
        params[@"afterpics"] = self.beforeRepaireata[@"afterpics"];
        params[@"wxfee"] = wxfee;
        params[@"rengongfee"] = rengongfee;
        params[@"cailiaofee"] = cailiaofee;
        params[@"otherfee"] = otherfee;
        [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
            if ([request[@"flag"] integerValue] == 0) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                dic[@"flag"] = @"2";
                dic[@"billid"] = self.billid;
                self.addStep = 0;
                SVShowSuccess(@"处理成功!");
                if (self.jumpBlock) {
                    self.jumpBlock(dic);//维修之后
                }
                [self.navigationController popViewControllerAnimated:NO];
                if (self.jumpFlag == 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"repaireSucc" object:nil userInfo:dic];
                }else if (self.jumpFlag == 2){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"projectrepaireSucc" object:nil userInfo:dic];
                }else if (self.jumpFlag == 3){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"homerepaireSucc" object:nil userInfo:dic];
                }else {
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"repaireElseSucc" object:nil userInfo:dic];
                }
            }else {
                SVShowSuccess(request[@"err"]);
            }
        } failBlock:^(NSError *error) {
            SVShowError(@"网络错误，请重试!");
        }];
    }
}
- (void)repaireDetailAllButton:(UIButton *)button//上传维修图片等
{
    if (button.tag == 111) {
        TJPushImageViewController * vc = [[TJPushImageViewController alloc] init];
        vc.imageCount = 3;
        vc.haveImageArray = [NSMutableArray arrayWithArray:self.imageArray1];
        vc.MyBlock = ^(NSMutableArray * imageArray) {
            [self.imageArray1 removeAllObjects];
            [self.imageArray1 addObjectsFromArray:imageArray];
            NSString * pprocpic = [NSString string];
            for (int i = 0; i < self.imageArray1.count; i ++) {
                pprocpic = [NSString stringWithFormat:@"%@%@^",pprocpic,self.imageArray1[i]];
            }
            pprocpic = [pprocpic substringToIndex:pprocpic.length - 1];
            [self.beforeRepaireata removeObjectForKey:@"beforepics"];
            self.beforeRepaireata[@"beforepics"] = pprocpic;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 112) {
        TJPushImageViewController * vc = [[TJPushImageViewController alloc] init];
        vc.imageCount = 3;
        vc.haveImageArray = [NSMutableArray arrayWithArray:self.imageArray2];
        vc.MyBlock = ^(NSMutableArray * imageArray) {
            [self.imageArray2 removeAllObjects];
            [self.imageArray2 addObjectsFromArray:imageArray];
            NSString * pprocpic = [NSString string];
            for (int i = 0; i < self.imageArray2.count; i ++) {
                pprocpic = [NSString stringWithFormat:@"%@%@^",pprocpic,self.imageArray2[i]];
            }
            pprocpic = [pprocpic substringToIndex:pprocpic.length - 1];
            [self.beforeRepaireata removeObjectForKey:@"afterpics"];
            self.beforeRepaireata[@"afterpics"] = pprocpic;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 113) {
        if (self.jumpFlag == 2) {
//            return;
        }
        TJChooseOrderpeopleViewController * vc = [[TJChooseOrderpeopleViewController alloc] init];
        vc.MyBlock= ^(NSMutableDictionary * dic){
            [self.beforeRepaireata removeObjectForKey:@"clerkid"];
            [self.beforeRepaireata removeObjectForKey:@"clerkname"];
            self.beforeRepaireata[@"clerkname"] = dic[@"clerkname"];
            self.beforeRepaireata[@"clerkid"] = dic[@"clerkid"];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 114) {//维修项目
        YYCache * cache = [TJCache shareCache].yyCache;
        NSData * data = (id)[cache objectForKey:@"baoxiuBaseData"];
        NSMutableDictionary * dataDic = [data toDictionary];
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < [dataDic[@"mendprolist"] count]; i ++) {
            [array addObject:dataDic[@"mendprolist"][i][@"mendproname"]];
        }
        CGSize originxS = [@"客户评价:" getStringRectWithfontSize:15*ScaleModel width:0];
        NSInteger y = 0;
        if (self.getOrNoPayRepaire == 0) {
            y = 64 + self.tableView.contentSize.height - self.scrollY - 228 - 7.3 * fifteenS.height - 34 * 6 - 144;
        }else {
            y = 64 + self.tableView.contentSize.height - self.scrollY - 228 - 3.3 * fifteenS.height - 34 * 6;
        }
        [[HSMidlabelView sharedInstance] setOriginX:originxS.width + 37 andOriginY:y  andWidth:180 andHeight:34 * 5 andData:array withString:self.repaireProject.text clickAtIndex:^(NSMutableDictionary * dic) {
            [self.beforeRepaireata removeObjectForKey:@"mendproid"];
            [self.beforeRepaireata removeObjectForKey:@"mendproname"];
            self.repaireProject.text = dic[@"label"];
            self.beforeRepaireata[@"mendproid"] = dataDic[@"mendprolist"][[dic[@"index"] integerValue]][@"mendproid"];
            self.beforeRepaireata[@"mendproname"] = dataDic[@"mendprolist"][[dic[@"index"] integerValue]][@"mendproname"];
        }];
    }
    if (button.tag == 115) {//开始时间
        self.chooseTimeFlag = 2;
        UIView * bgview = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeigth)];
        bgview.backgroundColor = [UIColor blackColor];
        bgview.alpha = 0.2;
        [[UIApplication sharedApplication].keyWindow addSubview:bgview];
        self.bgview = bgview;
        
        _cuiPickerView = [[CuiPickerView alloc]init];
        _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
        _cuiPickerView.backgroundColor = [UIColor whiteColor];
        _cuiPickerView.myTextField = self.beginTime;
        _cuiPickerView.string = [[User sharedUser] getNowTimeHaveHM];
        _cuiPickerView.delegate = self;
        _cuiPickerView.curDate=[NSDate date];
        [[UIApplication sharedApplication].keyWindow addSubview:_cuiPickerView];
        [_cuiPickerView showInView:[UIApplication sharedApplication].keyWindow];
    }
    if (button.tag == 116) {//结束时间
        self.chooseTimeFlag = 3;
        UIView * bgview = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeigth)];
        bgview.backgroundColor = [UIColor blackColor];
        bgview.alpha = 0.2;
        [[UIApplication sharedApplication].keyWindow addSubview:bgview];
        self.bgview = bgview;
        
        _cuiPickerView = [[CuiPickerView alloc]init];
        _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
        _cuiPickerView.backgroundColor = [UIColor whiteColor];
        _cuiPickerView.myTextField = self.endTime;
        _cuiPickerView.string = [[User sharedUser] getNowTimeHaveHM];
        _cuiPickerView.delegate = self;
        _cuiPickerView.curDate=[NSDate date];
        [[UIApplication sharedApplication].keyWindow addSubview:_cuiPickerView];
        [_cuiPickerView showInView:[UIApplication sharedApplication].keyWindow];
    }
}
- (void)topSwitchAction:(UISwitch *)button
{
    if (self.isShouldRepaire == 1) {
        self.isShouldRepaire = 0;
    } else {
        self.isShouldRepaire = 1;
    }
     [self.tableView reloadData];
}
- (void)bottomSwitchAction:(UISwitch *)button
{
    if (self.getOrNoPayRepaire == 1) {
        self.getOrNoPayRepaire = 0;
    } else {
        self.getOrNoPayRepaire = 1;
    }
    [self.tableView reloadData];
}
- (void)showOrhiddenStepDetail//是否显示步骤
{
    if (self.hiddenStepDetail == 0) {
        self.hiddenStepDetail = 1;
    } else {
        self.hiddenStepDetail = 0;
    }
    [self.tableView reloadData];
}
- (void)choosePeopleAndTime:(UIButton *)button//选择接单人和时间
{
    if (button.tag == 110) {
        if (self.jumpFlag == 2) {
//            return;
        }
        TJChooseOrderpeopleViewController * vc = [[TJChooseOrderpeopleViewController alloc] init];
        vc.MyBlock = ^(NSMutableDictionary * dic){
            self.jiedanren.text = dic[@"clerkname"];
            self.acceptclerk = dic[@"clerkid"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        self.chooseTimeFlag = 0;
        UIView * bgview = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeigth)];
        bgview.backgroundColor = [UIColor blackColor];
        bgview.alpha = 0.2;
        [[UIApplication sharedApplication].keyWindow addSubview:bgview];
        self.bgview = bgview;
        
        _cuiPickerView = [[CuiPickerView alloc]init];
        _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
        _cuiPickerView.backgroundColor = [UIColor whiteColor];
        _cuiPickerView.myTextField = self.jiedanhsijian;
        _cuiPickerView.string = [[User sharedUser] getNowTimeHaveHM];
        _cuiPickerView.delegate = self;
        _cuiPickerView.curDate=[NSDate date];
        [[UIApplication sharedApplication].keyWindow addSubview:_cuiPickerView];
        [_cuiPickerView showInView:[UIApplication sharedApplication].keyWindow];
    }
}
- (void)repaireDetailSuerAc//确认接单
{
    if (self.jiedanren.text.length == 0) {
        SVShowError(@"请选择接单人!");
        return;
    }
    if (self.jiedanren.text.length == 0) {
        SVShowError(@"请选择接单时间!");
        return;
    }
    [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"是否接单" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSString * url = @"wuye/mendaccept.jsp";
            
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            params[@"clerkid"] = userClerkid;
            params[@"billid"] = self.billid;
            params[@"accsta"] = @"1";
            params[@"acceptclerk"] = self.acceptclerk;
            params[@"accepttime"] = [[User sharedUser] getNowTimeHaveHM];
            params[@"yufinishtime"] = self.jiedanhsijian.text;
            [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
                if ([request[@"flag"] integerValue] == 0) {
                    if (self.jumpFlag == 1) {
                        self.refreshDetail = 1;
                    }
                    SVShowSuccess(@"接单成功!");
                    if (self.jumpFlag == 2) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if (self.MyBlock) {
                                self.MyBlock();
                            }
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                        return ;
                    }
                    [User sharedUser].showMidLoading = @"数据刷新中...";
                    self.dataDic = nil;
                    [self.tableView reloadData];
                    [self loadOrderData];
                }else {
                  SVShowError(request[@"err"]);
                }
            } failBlock:^(NSError *error) {
                SVShowError(@"网络错误，请重试!");
            }];
        }
    }];
}
#pragma mark - delete
 -(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.scrollY = scrollView.contentOffset.y;
}
- (void)hiddenAction//显示头部详情与否
{
    if ([self.dataDic[@"hiddenTop"] integerValue] == 1) {
        [self.dataDic removeObjectForKey:@"hiddenTop"];
        self.dataDic[@"hiddenTop"] = @"0";
    } else {
        [self.dataDic removeObjectForKey:@"hiddenTop"];
        self.dataDic[@"hiddenTop"] = @"1";
    }
    [self.tableView reloadData];
}
- (void)addStepAction{//添加步骤
    [self removeRepaireData];
    if (self.addStep == 0) {
        self.addStep = 1;
    } else {
        self.addStep = 0;
    }
    self.hiddenStepDetail = 1;
    [self.tableView reloadData];
}
- (void)removeRepaireData
{
    [self.repaireStepDic removeObjectForKey:@"clerkid"];
    [self.repaireStepDic removeObjectForKey:@"clerkname"];
    [self.repaireStepDic removeObjectForKey:@"content"];
    [self.repaireStepDic removeObjectForKey:@"time"];
    self.repaireStepDic[@"clerkid"] = userClerkid;
    self.repaireStepDic[@"clerkname"] = [User sharedUser].userInfo[@"clerkname"];
    self.repaireStepDic[@"time"] = [[User sharedUser] getNowTimeHaveHM];
    self.repaireStepDic[@"content"] = @"";
    self.repaireStepDic[@"count"] = @"0";
    [self.imageArray removeAllObjects];
}
#pragma mark - TJRepaireAddStepCell  delegate
- (void)chooseStepPeople//选择处理人
{
    if (self.jumpFlag == 2) {
//        return;
    }
    TJChooseOrderpeopleViewController * vc = [[TJChooseOrderpeopleViewController alloc] init];
    vc.MyBlock = ^(NSMutableDictionary * dic){
        [self.repaireStepDic removeObjectForKey:@"clerkid"];
        [self.repaireStepDic removeObjectForKey:@"clerkname"];
        self.repaireStepDic[@"clerkname"] = dic[@"clerkname"];
        self.repaireStepDic[@"clerkid"] = dic[@"clerkid"];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)chooseStepTime:(UITextField *)text//选择处理时间
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
- (void)pushImage//上传图片
{
    TJPushImageViewController * vc = [[TJPushImageViewController alloc] init];
    vc.billid = self.billid;
    vc.imageCount = 3;
    vc.haveImageArray = [NSMutableArray arrayWithArray:self.imageArray];
    vc.MyBlock = ^(NSMutableArray * imageArray){
        [self.imageArray removeAllObjects];
        [self.imageArray addObjectsFromArray:imageArray];
        [self.repaireStepDic removeObjectForKey:@"count"];
        self.repaireStepDic[@"count"] = @(imageArray.count);
        self.dataDic = nil;
        [User sharedUser].showMidLoading = @"数据刷新中...";
        [self.tableView reloadData];
        [self loadOrderData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)submitStep//上传步骤
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
    NSString * url = @"wuye/mendprocadd.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"billid"] = self.billid;
    params[@"procclerk"] = self.repaireStepDic[@"clerkid"];
    params[@"proctime"] = self.repaireStepDic[@"time"];
    params[@"proccontent"] = self.repaireStepDic[@"content"];
    params[@"pprocpic"] = pprocpic;
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(@"添加成功!");
            self.addStep = 0;
            [self.imageArray removeAllObjects];
            [self removeRepaireData];//重置步骤数据
            self.dataDic = nil;
            [User sharedUser].showMidLoading = @"数据刷新中...";
            [self.tableView reloadData];
            [self loadOrderData];
        }else {
            SVShowError(request[@"err"]);
        }
    } failBlock:^(NSError *error) {
        SVShowError(@"网络错误，请重试!");
    }];
}
- (void)textEditBegin//开始输入处理内容
{
    self.orginNumber = self.scrollY;
    self.textFlag = 1;//添加步骤处理内容编辑
}
- (void)textEditEnd:(UITextField *)text//完成输入
{
    [self.repaireStepDic removeObjectForKey:@"content"];
    self.repaireStepDic[@"content"] = text.text;
    [self.tableView reloadData];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 702) {
        [self.beforeRepaireata removeObjectForKey:@"wxcontent"];
        self.beforeRepaireata[@"wxcontent"] = textField.text;
    }
    if (textField.tag == 705) {
        [self.beforeRepaireata removeObjectForKey:@"rengongfee"];
        self.beforeRepaireata[@"rengongfee"] = textField.text;
    }
    if (textField.tag == 706) {
        [self.beforeRepaireata removeObjectForKey:@"cailiaofee"];
        self.beforeRepaireata[@"cailiaofee"] = textField.text;
    }
    if (textField.tag == 707) {
        [self.beforeRepaireata removeObjectForKey:@"otherfee"];
        self.beforeRepaireata[@"otherfee"] = textField.text;
    }
    if (self.nextFlag == 1) {
        self.nextFlag = 0;
    } else {
        [self.tableView reloadData];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.orginNumber = self.scrollY;
    self.textFlag = textField.tag;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.nextFlag = 1;
    if (textField.returnKeyType==UIReturnKeyNext) {
        switch (textField.tag) {
            case 705:
                [self.cailiaofee becomeFirstResponder];
                break;
            case 706:
                [self.otherfee becomeFirstResponder];
                break;
            default:
                break;
        }
    }else {
        self.flag = 0;
        [self.view endEditing:YES];
        [self.tableView reloadData];
    }
    return YES;
}
- (void)AddStpeRepaireKeyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height1 = keyboardRect.size.height;
    if (self.orginNumber == 0) {
//        self.orginNumber = self.tableView.contentSize.height - self.tableView.height;
    }
    if (self.textFlag == 1) {
        NSInteger status = [self.dataDic[@"billsta"] integerValue];
        NSInteger heitht = 0;
        CGSize s = [self.dataDic[@"msgcontent"] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-42];
        if ([self.dataDic[@"hiddenImage"] integerValue] == 1) {
            heitht = heitht + 121 + 4*fifteenS.height + s.height;
        } else {
            heitht = heitht + 121 + 63 + 4*fifteenS.height + s.height;
        }
        if ([self.dataDic[@"hiddenTop"] integerValue] == 1) {
            heitht = heitht + 40;
        }else {
            heitht = heitht + 40;
        }
        
        if (status == 0) {
             heitht = heitht + 178-36+2*fifteenS.height;
        }else if (status == 1 || status == 2 || status == 3) {
             heitht = heitht + 142 - 36+2*fifteenS.height;
        }else {
             heitht = heitht + 0;
        }
        
        self.tableView.frame = Rect(0,(kScreenHeigth - 64 - height1 - 125 - fifteenS.height * 3) - (self.tableView.contentSize.height - kScreenHeigth + 64 - heitht)- height1, kScreenWidth, self.tableView.contentSize.height);
    }
    if (self.textFlag== 50) {
        self.tableView.frame = Rect(0,95 + fifteenS.height - (self.tableView.contentSize.height - kScreenHeigth + 64)- height1, kScreenWidth, self.tableView.contentSize.height);
    }
    if (self.textFlag == 702) {//维修结果
        if (self.getOrNoPayRepaire == 0) {
            self.tableView.frame = Rect(0,196 + fifteenS.height * 4 - (self.tableView.contentSize.height - 144 - 4 * fifteenS.height - kScreenHeigth + 64)- height1, kScreenWidth, self.tableView.contentSize.height);
            return;
        }
        self.tableView.frame = Rect(0,196 + fifteenS.height * 4 - (self.tableView.contentSize.height - kScreenHeigth + 64)- height1, kScreenWidth, self.tableView.contentSize.height);
    }
    if (self.textFlag > 704) {
        self.tableView.frame = Rect(0,233 + 4 * fifteenS.height - 48 * (self.textFlag - 705) - (self.tableView.contentSize.height - kScreenHeigth + 64)- height1, kScreenWidth, self.tableView.contentSize.height);
    }
    self.flag = 1;
}
- (void)AddStpeRepaireKeyboardWillHide:(NSNotification *)aNotification
{
    self.flag = 0;
//    if (self.textFlag == 1 || self.textFlag == 50) {
//        self.tableView.frame = Rect(0, 64, kScreenWidth, kScreenHeigth - 64);
//        return;
//    }
    self.tableView.frame = Rect(0, 64, kScreenWidth, kScreenHeigth - 64);
    self.tableView.contentOffset = CGPointMake(0, self.orginNumber);
    self.orginNumber = 0;
}
#pragma mark - TJRepaireStepBaseDelegate 显示图片
- (void)selectImageFromCollectionview:(UICollectionView *)collectionView andIndex:(NSInteger)index andImageArray:(NSMutableArray *)imageArray
{
    [self.stepImageArray removeAllObjects];
    [self.stepImageArray addObjectsFromArray:imageArray];
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = collectionView; // 原图的父控件
    browser.imageCount = [imageArray count];
    browser.currentImageIndex = (int)index;
    browser.delegate = self;
    [browser show];
}
#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView * image = [UIImageView new];
    [image sd_setImageWithURL:self.stepImageArray[index] placeholderImage:[UIImage imageNamed:@"home_photo"]];
    return image.image;
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return self.stepImageArray[index];
    
}
#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger count = [self.stepImageArray count];
    
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
- (void)didFinishPickView:(NSString *)date
{
    if (self.chooseTimeFlag == 0) {
        self.jiedanhsijian.text = date;
        if (date.length == 0) {
            self.jiedanhsijian.text = [[User sharedUser] getNowTimeHaveHM];
        }
    }
    if (self.chooseTimeFlag == 1) {
        [self.repaireStepDic removeObjectForKey:@"time"];
        self.repaireStepDic[@"time"] = date;
        if (date.length == 0) {
            self.repaireStepDic[@"time"] = [[User sharedUser] getNowTimeHaveHM];
        }
    }
    if (self.chooseTimeFlag == 2) {
        [self.beforeRepaireata removeObjectForKey:@"wxbegin"];
        self.beforeRepaireata[@"wxbegin"] = date;
        if (date.length == 0) {
            self.beforeRepaireata[@"wxbegin"] = [[User sharedUser] getNowTimeHaveHM];
        }
    }
    if (self.chooseTimeFlag == 3) {
        [self.beforeRepaireata removeObjectForKey:@"wxend"];
        self.beforeRepaireata[@"wxend"] = date;
        if (date.length == 0) {
            self.beforeRepaireata[@"wxend"] = [[User sharedUser] getNowTimeHaveHM];
        }
    }
    [self.tableView reloadData];
    [self.bgview removeFromSuperview];
    self.bgview = nil;
}
- (void)hiddenPickerView
{
    [self.bgview removeFromSuperview];
    self.bgview = nil;
}
#pragma mark - netWorking
- (void)loadOrderData
{
    NSString * url = @"wuye/mendbilldetail.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"billid"] = self.billid;
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            if ([request[@"data"] count] > 0) {
                self.dataDic = [NSMutableDictionary dictionaryWithDictionary:request[@"data"]];
                self.dataDic[@"hiddenTop"] = @"1";
                if ([self.dataDic[@"pics"] length] > 0) {
                    self.dataDic[@"hiddenImage"] = @"0";
                } else {
                    self.dataDic[@"hiddenImage"] = @"1";
                }
            }else {
                SVShowError(request[@"data"]);
            }
        }else {
            [User sharedUser].showMidLoading = @"点击进行刷新!";
        }
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        [User sharedUser].showMidLoading = @"网络连接错误，请检查您的网络或点击刷新!";
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
