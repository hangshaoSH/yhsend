//
//  TJRepaireBackViewController.m
//  baseXcode
//
//  Created by hangshao on 16/12/8.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJRepaireBackViewController.h"
#import "TJRepaireDetailTopTableViewCell.h"
#import "TJRepaireDetailTopNextTableViewCell.h"
#import "TJNotRepaireMidTableViewCell.h"
#import "TJNotRepaireBottomTableViewCell.h"
#import "TJChooseOrderpeopleViewController.h"
#import "TJRepaireStepBaseTableViewCell.h"
#import "TJRepaireStepBottomTableViewCell.h"
#import "TJRepaireDetailElseTopTableViewCell.h"
#import "TJRepaireDetailMidTableViewCell.h"
#import "TJRepaireDetailBottomTableViewCell.h"
#import "TJBeforRepaireImageTableViewCell.h"
@interface TJRepaireBackViewController ()<UITableViewDelegate,UITableViewDataSource,TJRepaireDetailNextTopDelegate,CuiPickViewDelegate,UITextFieldDelegate,SDPhotoBrowserDelegate,TJRepaireTopDelegate,TJRepaireStepBaseDelegate,TJRepaireStepBottomDelegate,TJRepaireDetailElseTopDelegate,TJRepaireDetaiMidDelegate,TJRepaireDetailBottomDelegate,TJRepaireBeforImageDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   strong) NSMutableDictionary     * elseDataDic;
@property (nonatomic,   weak) UITextField     * huifangName;
@property (nonatomic,   weak) UITextField     * huifangTime;
@property (nonatomic,   weak) UITextField     * peopleAppraise;
@property (nonatomic,   weak) UITextField     * peopleOpinion;
@property (nonatomic,   assign) CGFloat  scrollY;
@property (nonatomic,   assign) NSInteger  textFlag;
@property (nonatomic,   assign) NSInteger   flag;
@property (nonatomic, strong) CuiPickerView *cuiPickerView;
@property (nonatomic,   assign) NSInteger  touchFlag;
@property (nonatomic,   weak) UIView     * bgview;
@property (nonatomic,   assign) CGFloat   orginNumber;
@property (nonatomic,   strong) NSMutableArray     * imageArray;
@property (nonatomic,   assign) NSInteger  rereshHui;
@end

@implementation TJRepaireBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView];
    
    [self setTableView];
    
    [self loadOrderData];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notRepaireKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notRepaireKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
#pragma mark - setView
- (void)setTopView
{
    self.elseDataDic = [NSMutableDictionary dictionary];
    self.elseDataDic[@"clerkname"] =  [User sharedUser].userInfo[@"clerkname"];
    self.elseDataDic[@"clerkid"] =  [User sharedUser].userInfo[@"clerkid"];
    self.elseDataDic[@"time"] = [[User sharedUser] getNowTimeHaveHM];
    YYCache * cache = [TJCache shareCache].yyCache;
    NSData * data = (id)[cache objectForKey:@"baoxiuBaseData"];
    NSMutableDictionary * dic = [data toDictionary];
    self.elseDataDic[@"typename"] = dic[@"backtypelist"][0][@"typename"];
    self.elseDataDic[@"typeid"] = dic[@"backtypelist"][0][@"typeid"];
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
        if (self.rereshHui == 1 && self.jumpFlag == 1) {
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
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataDic count] == 0) {//5已完成未回访  6已完成已回
        return 1;
    }
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        if ([self.dataDic[@"hiddenStep"] integerValue] == 1) {
            return 0;
        }
        return [self.dataDic[@"procinfo"] count];
    }else if (section == 2) {
        return 7;
    }else {
        return 1;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataDic count] == 0) {//5已完成未回访  6已完成已回访
        return self.tableView.height;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CGSize s = [self.dataDic[@"msgcontent"] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-42];
            NSInteger height = s.height;
            if (height == 0) {
                height = fifteenS.height;
            }
            if ([self.dataDic[@"hiddenImage"] integerValue] == 1) {
                return 121 + 4*fifteenS.height + height;
            } else {
                return 121 + 63 + 4*fifteenS.height + height;
            }
        }else if (indexPath.row == 1) {
            if ([self.dataDic[@"hiddenTop"] integerValue] == 1) {
                return 40;
            }
            return 133+fifteenS.height*4;
        }else {
            return 88+3*fifteenS.height;
        }
    }else if (indexPath.section == 1) {
        if ([self.dataDic[@"procinfo"] count] == 0) {
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
        return height + 101 + 3 * fifteenS.height;
    } else if (indexPath.section == 2) {
        NSInteger height = 0;
        if ([self.dataDic[@"wxinfo"][@"wxresult"] length] > 0) {
            CGSize s = [self.dataDic[@"wxinfo"][@"wxresult"] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-42];
            height = s.height;
        } else {
            height = fifteenS.height;
        }
        if ([self.dataDic[@"hiddenRepaireDetail"] integerValue] == 1) {
            if (indexPath.row == 0) {
                if ([self.dataDic[@"procinfo"] count] == 0) {
                    return 0;
                }
                return 41;
            }else if (indexPath.row == 1) {
                return 105 + fifteenS.height*3 + height;
            }else if (indexPath.row == 6) {
                return 41;
            } else {
                return 0;
            }
        } else {
            if (indexPath.row == 0) {
                if ([self.dataDic[@"procinfo"] count] == 0) {
                    return 0;
                }
                return 41;
            }else if (indexPath.row == 1) {
                return 105 + height + fifteenS.height*3;
            }else if (indexPath.row == 2) {//维修前图片
                if ([self.dataDic[@"wxinfo"][@"beforepics"] length] > 0) {
                    return 93 + fifteenS.height;
                }
                return 30 + fifteenS.height;
            } else if (indexPath.row == 3) {//维修后图片
                if ([self.dataDic[@"wxinfo"][@"afterpics"] length] > 0) {
                    return 125 + fifteenS.height * 3;
                }
                return 63 + fifteenS.height * 3;;
            } else if (indexPath.row == 4) {//是否收费
                if ([self.dataDic[@"wxfee"] integerValue] == 0) {
                    return 0;
                }
                return 101 + fifteenS.height * 4;
            }else if (indexPath.row == 5) {//是否评价
                if ([self.dataDic[@"wxinfo"][@"wxcommspec"] length] > 0) {
                    CGSize s = [self.dataDic[@"wxinfo"][@"wxcommspec"] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-42];
                    return 105 + s.height;
                }
                return 123;
            }else {
                return 41;//按钮
            }
        }
    }else {
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataDic count] == 0) {
        TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
        [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 0) {
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
        }else{
            TJNotRepaireMidTableViewCell * cell = [TJNotRepaireMidTableViewCell cellWithTableView:tableView];
            [cell setCellWithDic:self.dataDic];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else if (indexPath.section == 1) {
        TJRepaireStepBaseTableViewCell * cell = [TJRepaireStepBaseTableViewCell cellWithTableView:tableView];
        [cell setCellWithDic:self.dataDic[@"procinfo"][indexPath.row] withTag:indexPath.row];
        [cell setDelegate:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            static NSString * ID = @"TJRepaireHiddenOrShowCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepaireElseDetailCell" owner:self options:nil] objectAtIndex:10];
            }
            UIButton * hiddenOrShow = (UIButton *)[cell.contentView viewWithTag:110];
            [hiddenOrShow addTarget:self action:@selector(hiddenOrShowRequireDetaileStep)];
            UIImageView * image = (UIImageView *)[cell.contentView viewWithTag:100];
            if ([self.dataDic[@"hiddenStep"] integerValue] == 1) {
                image.image = [UIImage imageNamed:@"manager_hidden"];
            } else {
                image.image = [UIImage imageNamed:@"manager_show"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 1) {
            TJRepaireDetailElseTopTableViewCell * cell = [TJRepaireDetailElseTopTableViewCell cellWithTableView:tableView];
            [cell setCellWithDic:self.dataDic];
            [cell setDelegate:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 2) {
            TJBeforRepaireImageTableViewCell * cell = [TJBeforRepaireImageTableViewCell cellWithTableView:tableView];
            [cell setCellWithDic:self.dataDic];
            [cell setDelegate:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 3) {
            TJRepaireDetailMidTableViewCell * cell = [TJRepaireDetailMidTableViewCell cellWithTableView:tableView];
            [cell setCellWithDic:self.dataDic];
            [cell setDelegate:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 4) {
            TJRepaireDetailBottomTableViewCell * cell = [TJRepaireDetailBottomTableViewCell cellWithTableView:tableView];
            [cell setCellWithDic:self.dataDic[@"feeinfo"]];
            [cell setDelegate:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == 5) {
            static NSString * ID = @"TJRepaireDetailShowPeopleopinionCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepaireElseDetailCell" owner:self options:nil] objectAtIndex:12];
            }
            for (int i = 0; i < 2; i ++) {
                UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:200 + i];
                label1.font = [UIFont systemFontOfSize:15 * ScaleModel];
                label1.textColor = fivelightColor;
            }
            UILabel * style = (UILabel *)[cell.contentView viewWithTag:100];
            style.font = fifteenFont;
            style.text = self.dataDic[@"wxinfo"][@"wxcommtypename"];
            UILabel * content = (UILabel *)[cell.contentView viewWithTag:101];
            content.font = fifteenFont;
            if ([self.dataDic[@"wxinfo"][@"wxcommspec"] length] == 0) {
                content.text = @"暂无";
            }else {
                content.text = self.dataDic[@"wxinfo"][@"wxcommspec"];
            }
            UIView * bgview = (UIView *)[cell.contentView viewWithTag:300];
            bgview.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
            bgview.cornerRadius = 5.0;
            bgview.borderColor = bordercolor;
            bgview.borderWidth = 0.7;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            static NSString * ID = @"TJRepaireHiddenOrShowDetailCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepaireElseDetailCell" owner:self options:nil] objectAtIndex:13];
            }
            UIButton * hiddenOrShow = (UIButton *)[cell.contentView viewWithTag:110];
            [hiddenOrShow addTarget:self action:@selector(showOrhiddenDetail)];
            UIImageView * image = (UIImageView *)[cell.contentView viewWithTag:100];
            if ([self.dataDic[@"hiddenRepaireDetail"] integerValue] == 1) {
                image.image = [UIImage imageNamed:@"manager_hidden"];
            } else {
                image.image = [UIImage imageNamed:@"manager_show"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else {
        if ([self.dataDic[@"isvisit"] integerValue] == 1) {
            TJNotRepaireBottomTableViewCell * cell = [TJNotRepaireBottomTableViewCell cellWithTableView:tableView];
            [cell setCellWithDic:self.dataDic[@"visitinfo"][0]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
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
                [choose addTarget:self action:@selector(choosePeopleAndTimeAndApprise:)];
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
            peopleOpinion.returnKeyType = UIReturnKeyDone;
            self.peopleOpinion = peopleOpinion;
            UIButton * sure = (UIButton *)[cell.contentView viewWithTag:113];
            sure.cornerRadius = 5.0;
            sure.backgroundColor = [UIColor colorWithHexString:@"ffb400"];
            sure.titleFont = 15 * ScaleModel;
            [sure addTarget:self action:@selector(backRepaireDetailSuerAc)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([self.dataDic count] == 0) {
        [User sharedUser].showMidLoading = @"数据加载中...";
        [self.tableView reloadData];
        [self loadOrderData];
    }
}

#pragma mark - buttonAction
- (void)choosePeopleAndTimeAndApprise:(UIButton *)button
{
    if (button.tag == 110) {
        if (self.jumpFlag == 2) {
//            return;
        }
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
        NSData * data = (id)[cache objectForKey:@"baoxiuBaseData"];
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
#pragma mark - delete
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
#pragma mark - photobrowser代理方法

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
#pragma mark - CHTCollectionViewDelegateWaterfallLayout
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
- (void)hiddenOrShowRequireDetaileStep//显示步骤
{
    if ([self.dataDic[@"hiddenStep"] integerValue] == 1) {
        [self.dataDic removeObjectForKey:@"hiddenStep"];
        self.dataDic[@"hiddenStep"] = @"0";
    } else {
        [self.dataDic removeObjectForKey:@"hiddenStep"];
        self.dataDic[@"hiddenStep"] = @"1";
    }
    [self.tableView reloadData];
}
- (void)showOrhiddenDetail//显示维修详情
{
    if ([self.dataDic[@"hiddenRepaireDetail"] integerValue] == 1) {
        [self.dataDic removeObjectForKey:@"hiddenRepaireDetail"];
        self.dataDic[@"hiddenRepaireDetail"] = @"0";
    } else {
        [self.dataDic removeObjectForKey:@"hiddenRepaireDetail"];
        self.dataDic[@"hiddenRepaireDetail"] = @"1";
    }
    [self.tableView reloadData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.scrollY = scrollView.contentOffset.y;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.orginNumber = self.scrollY;
    self.textFlag = textField.tag - 100;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
- (void)notRepaireKeyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height1 = keyboardRect.size.height;
    if (self.orginNumber == 0) {
//        self.orginNumber = self.tableView.contentSize.height - self.tableView.height;
    }
    self.tableView.frame = Rect(0,78 + 43 + 12 - (self.tableView.contentSize.height - kScreenHeigth + 64)- height1, kScreenWidth, self.tableView.contentSize.height);
    self.flag = 1;
}
- (void)notRepaireKeyboardWillHide:(NSNotification *)aNotification
{
    self.flag = 0;
    self.tableView.frame = Rect(0, 64, kScreenWidth, kScreenHeigth - 64);
    self.tableView.contentOffset = CGPointMake(0, self.orginNumber);
    self.orginNumber = 0;
}
- (void)didFinishPickView:(NSString *)date
{
    self.huifangTime.text = date;
    if (date.length == 0) {
        self.huifangTime.text = [[User sharedUser] getNowTimeHaveHM];
    }
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
                self.dataDic[@"hiddenTop"] = @"1";//顶部
                self.dataDic[@"hiddenStep"] = @"1";//步骤
                self.dataDic[@"hiddenRepaireDetail"] = @"1";//维修详情
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
- (void)backRepaireDetailSuerAc//报修单回访
{
    [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"是否提交信息，确认后将无法修改!" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self huifang];
        }
    }];
}
- (void)huifang{
    NSString * url = @"wuye/mendvisitadd.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"billid"] = self.billid;
    params[@"visitclerk"] = self.elseDataDic[@"clerkid"];
    params[@"visittime"] = self.huifangTime.text;
    params[@"backtype"] = self.elseDataDic[@"typeid"];
    params[@"backspec"] = self.peopleOpinion.text;
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            if (self.jumpFlag == 1) {
                self.rereshHui = 1;
            }
            SVShowSuccess(@"已回访!");
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
#pragma mark - 懒加载
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageArray;
}
- (NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

@end
