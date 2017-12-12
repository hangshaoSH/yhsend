//
//  TJRepaireComplaintDetailViewController.m
//  baseXcode
//
//  Created by hangshao on 16/12/13.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJRepaireComplaintDetailViewController.h"
#import "TJComplaintDetailTopTableViewCell.h"
#import "TJComplaintDetailBottomTableViewCell.h"
#import "TJComplaintDetailMidTableViewCell.h"
#import "TJNotShouLiHuiFuTableViewCell.h"
#import "TJMemberHeyanView.h"
#import "TJAddRepaireViewController.h"
#import "TJRepaireBackViewController.h"
#import "TJRepaireDetailElseViewController.h"
#import "TJRepaireDetailViewController.h"
@interface TJRepaireComplaintDetailViewController ()<UITableViewDelegate,UITableViewDataSource,TJComplaintBottomDelegate,TJComplaintTopDelegate,SDPhotoBrowserDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   strong) NSMutableArray     * imageArray;
@property (nonatomic,   assign) NSInteger  refresh;
@end

@implementation TJRepaireComplaintDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageArray = [NSMutableArray arrayWithCapacity:0];
    
    [self setTableView];
    
    [self loadComplaintDetail];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpElseWithBillid1:) name:@"notElseRepaire" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpElseWithBillid2:) name:@"repaireElseSucc" object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notElseRepaire" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"repaireElseSucc" object:nil];
}
- (void)jumpElseWithBillid1:(NSNotification *)userinfo
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:userinfo.userInfo];
    TJRepaireDetailElseViewController * vc = [[TJRepaireDetailElseViewController alloc] init];
    vc.billid = dic[@"billid"];
    vc.jumpFlag = 1;
    vc.MyBlock = ^(){
        [self refreshComplaintData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)jumpElseWithBillid2:(NSNotification *)userinfo
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:userinfo.userInfo];
    TJRepaireBackViewController * vc = [[TJRepaireBackViewController alloc] init];
    vc.billid = dic[@"billid"];
    vc.jumpFlag = 1;
    vc.MyBlock = ^(){
        [self refreshComplaintData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - setView

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
    wself.ts_navgationBar = [TSNavigationBar navWithTitle:@"报修受理详情" backAction:^{
        [YHNetWork stopTheVcRequset:wself];
        if (self.refresh == 1) {
            if (self.MyBlock) {
                self.MyBlock();
            }
        }
        if (self.MyBlock) {
            self.MyBlock();
        }
        [wself.navigationController popViewControllerAnimated:YES];
    }];
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
    return 3;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataDic count] == 0) {
        return self.tableView.height;
    }
    if (indexPath.row == 0) {
        CGSize s = [self.dataDic[@"msgcontent"] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-42];
        if ([self.dataDic[@"pics"] length] > 0) {
            return 235 + fifteenS.height * 5 + s.height;//有图
        }
        return 172 + fifteenS.height * 5 + s.height;//有图
    }else if (indexPath.row == 1) {
        return 96+fifteenS.height * 4 + 8 * ScaleModel;
    } else{
        if ([self.dataDic[@"isaccept"] integerValue] == 1) {
             return 114+2*fifteenS.height;
        }
        if ([self.dataDic[@"isaccept"] integerValue] == 2) {
            CGSize s = [self.dataDic[@"backreply"] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-42];
            return 50+fifteenS.height + s.height;
        }
        return 80;
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
        TJComplaintDetailTopTableViewCell * cell = [TJComplaintDetailTopTableViewCell cellWithTableView:tableView];
        [cell setCellWithDic:self.dataDic];
        [cell setDelegate:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == 1) {
        TJComplaintDetailMidTableViewCell * cell = [TJComplaintDetailMidTableViewCell cellWithTableView:tableView];
        [cell setCellWithDic:self.dataDic];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        if ([self.dataDic[@"isaccept"] integerValue] == 1) {
            TJComplaintDetailBottomTableViewCell * cell = [TJComplaintDetailBottomTableViewCell cellWithTableView:tableView];
            [cell setCellWithDic:self.dataDic];
            [cell setDelegate:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if ([self.dataDic[@"isaccept"] integerValue] == 2){
            TJNotShouLiHuiFuTableViewCell * cell = [TJNotShouLiHuiFuTableViewCell cellWithTableView:tableView];
            [cell setCellWithDic:self.dataDic];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            static NSString * ID = @"TJComplaintGetOrNoCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"TJRepaireManagerCell" owner:self options:nil] objectAtIndex:4];
            }
            for (int i = 0; i < 2; i ++) {
                UIButton * button = (UIButton *)[cell.contentView viewWithTag:110 + i];
                button.titleFont = 15 * ScaleModel;
                button.cornerRadius = 5.0;
                if (i == 0) {
                    button.backgroundColor = orangecolor;
                } else {
                    button.backgroundColor = [UIColor colorWithHexString:@"b5b5b5"];
                }
                [button addTarget:self action:@selector(shouliOrBushouliAc:)];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if ([self.dataDic count] == 0) {
        return;
    }
}

#pragma mark - buttonAction
- (void)refreshComplaintData
{
    self.dataDic = nil;
    [User sharedUser].showMidLoading = @"数据刷新中...";
    [self.tableView reloadData];
    [self loadComplaintDetail];
    self.refresh = 1;
}
- (void)shouliOrBushouliAc:(UIButton *)button
{
    if (button.tag == 110) {
        TJAddRepaireViewController * vc = [[TJAddRepaireViewController alloc] init];
        vc.jumpFlag = 1;
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
        dic[@"orderid"] = self.orderid;
        vc.jumpDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        vc.MyBlock = ^(){
            [self  refreshComplaintData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [[TJMemberHeyanView sharedInstance] setMidViewWithTitle:@"不受理回复" returnString:^(NSString *text) {
            [self notShouli:text];
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
- (void)jumpDetail
{
    NSInteger status = [self.dataDic[@"billinfo"][@"billsta"] integerValue];
    NSString * billid = self.dataDic[@"billinfo"][@"billid"];
    if (status == 0 || status == 1 || status == 2 || status == 3) {
        TJRepaireDetailViewController * vc = [[TJRepaireDetailViewController alloc] init];
        vc.billid = billid;
        vc.jumpFlag = 1;
        vc.MyBlock = ^(){
            [self  refreshComplaintData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (status == 5 || status == 6) {
        TJRepaireBackViewController * vc = [[TJRepaireBackViewController alloc] init];
        vc.billid = billid;
        vc.jumpFlag = 1;
        vc.MyBlock = ^(){
            [self  refreshComplaintData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (status == 9) {
        TJRepaireDetailElseViewController * vc = [[TJRepaireDetailElseViewController alloc] init];
        vc.billid = billid;
        vc.jumpFlag = 1;
        vc.MyBlock = ^(){
            [self  refreshComplaintData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - netWorking
- (void)loadComplaintDetail
{
    YYCache * cache = [TJCache shareCache].yyCache;
    NSData * data = (id)[cache objectForKey:@"baoxiuBaseData"];
    NSMutableDictionary * dic = [data toDictionary];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    if ([dic count] > 0) {
        [array addObjectsFromArray:dic[@"calltypelist"]];
    }
    
    NSString * url = @"wuye/mendrequestdetail.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"orderid"] = self.orderid;
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:request[@"data"]];
            for (int i = 0; i < array.count; i ++) {
                if ([self.dataDic[@"calltype"] integerValue] == [array[i][@"typeid"] integerValue]) {
                    self.dataDic[@"typename"] = array[i][@"typename"];
                }
            }
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
- (void)notShouli:(NSString *)text
{
    NSString * url = @"wuye/mendreply.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"memberid"] = self.dataDic[@"memberid"];
    params[@"orderid"] = self.orderid;
    params[@"replycontent"] = text;
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(@"处理成功!");
            if (self.MyBlock) {
                self.MyBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            SVShowError(request[@"err"]);
        }

    } failBlock:^(NSError *error) {
        SVShowError(@"网络错误，请重试!");
    }];
}
- (void)shouliOrder
{
    NSString * url = @"wuye/mendbilladd.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"cpcode"] = self.dataDic[@"cpcode"];
    params[@"memberid"] = self.dataDic[@"memberid"];
    params[@"orderid"] = self.orderid;
    params[@"houseid"] = self.dataDic[@"houseid"];
    params[@"ordertype"] = self.dataDic[@"ordertypeid"];
    params[@"modid"] = self.dataDic[@"modid"];
    params[@"mendcontent"] = self.dataDic[@"msgcontent"];
    params[@"callname"] = self.dataDic[@"callname"];
    params[@"calltel"] = self.dataDic[@"calltel"];
    params[@"calltime"] = self.dataDic[@"calltime"];
    params[@"calltype"] = self.dataDic[@"calltype"];
    params[@"isaccept"] = self.dataDic[@"isaccept"];
    params[@"acceptclerk"] = self.dataDic[@"acceptclerk"];
    params[@"accepttime"] = self.dataDic[@"accepttime"];
    params[@"yufinishtime"] = self.dataDic[@""];
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            
        }else {
            SVShowError(request[@"err"]);
        }
        [self.tableView reloadData];
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
- (NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
@end
