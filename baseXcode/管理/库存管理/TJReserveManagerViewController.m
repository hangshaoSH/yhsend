//
//  TJReserveManagerViewController.m
//  baseXcode
//
//  Created by hangshao on 17/1/10.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "TJReserveManagerViewController.h"
#import "TJReserveThreeTableViewCell.h"
#import "TJReserveTwoTableViewCell.h"
#import "TJReserveFirstTableViewCell.h"
#import "TJReserveSearchViewController.h"
#import "TJGongHuoSearchViewController.h"
#import "TJKuCunSearchViewController.h"
#import "TJAddReserveViewController.h"
#import "AFHTTPSessionManager.h"
@interface TJReserveManagerViewController ()<UITableViewDelegate,UITableViewDataSource,TJReserveFirstDelegate,SDPhotoBrowserDelegate,UITextViewDelegate>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   assign) NSInteger   page;
@property (nonatomic,   weak) UIButton     * buttonSelect;
@property (nonatomic,   weak) UIView     * lineView;
@property (nonatomic,   assign) NSInteger  flag;
@property (nonatomic,   assign) NSInteger  index;
@property (nonatomic,   strong) NSMutableArray     * imagearray;
@property (nonatomic,   weak) UIView     * backgroundview;
@property (nonatomic,   weak) UIView     * tuihuoview;
@property (nonatomic,   weak) UILabel     * placeholder;
@property (nonatomic,   weak) UITextField     * number;
@property (nonatomic,   weak) UITextView     * content;
@end

@implementation TJReserveManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagearray = [NSMutableArray arrayWithCapacity:0];
    
    self.page = 1;
    
    self.index = 0;
    
    [self setTopView];
    
    [self setHeaderView];
    
    [self setTableView];
    
    [self setButton];
    
    [self loadReserveData:0];
}

#pragma mark - setview
- (void)setHeaderView
{
    UIView * topView = [[[NSBundle mainBundle] loadNibNamed:@"TJManageTopCell" owner:self options:nil] objectAtIndex:0];
    topView.origin = zeroOrigin;
    topView.width = kScreenWidth;
    topView.height = 64;
    topView.backgroundColor = TopBgColor;
    [self.view addSubview:topView];
    
    UILabel * label = (UILabel *)[topView viewWithTag:100];
    label.font = seventeenFont;
    label.text = @"库存管理";
    
    for (int i = 0; i < 2; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        [button addTarget:self action:@selector(backAndSearchKreserve:)];
    }
}
- (void)backAndSearchKreserve:(UIButton *)button
{
    if (button.tag == 110) {
        [YHNetWork stopTheVcRequset:self];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.flag == 0) {
            TJGongHuoSearchViewController * vc = [[TJGongHuoSearchViewController alloc] init];
            vc.MyBlock = ^(NSMutableDictionary * dic){
                [self.dataDic removeObjectForKey:@"billid"];
                [self.dataDic removeObjectForKey:@"cpcode"];
                [self.dataDic removeObjectForKey:@"startdate"];
                [self.dataDic removeObjectForKey:@"enddate"];
                self.dataDic[@"cpcode"] = dic[@"cpcode"];
                self.dataDic[@"billid"] = dic[@"billid"];
                self.dataDic[@"startdate"] = dic[@"startdate"];
                self.dataDic[@"enddate"] = dic[@"enddate"];
                [self.dataArray removeAllObjects];
                [User sharedUser].showMidLoading = @"数据加载中...";
                [self.tableView reloadData];
                [self refreshReserveData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (self.flag == 1) {
            TJReserveSearchViewController * vc = [[TJReserveSearchViewController alloc] init];
            vc.MyBlock = ^(NSMutableDictionary * dic){
                [self.dataDic removeObjectForKey:@"billid"];
                [self.dataDic removeObjectForKey:@"cpcode"];
                [self.dataDic removeObjectForKey:@"startdate"];
                [self.dataDic removeObjectForKey:@"enddate"];
                [self.dataDic removeObjectForKey:@"storetype"];
                self.dataDic[@"cpcode"] = dic[@"cpcode"];
                self.dataDic[@"billid"] = dic[@"billid"];
                self.dataDic[@"startdate"] = dic[@"startdate"];
                self.dataDic[@"enddate"] = dic[@"enddate"];
                self.dataDic[@"storetype"] = dic[@"storetype"];
                [self.dataArray removeAllObjects];
                [User sharedUser].showMidLoading = @"数据加载中...";
                [self.tableView reloadData];
                [self refreshReserveData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (self.flag == 2) {
            TJKuCunSearchViewController * vc = [[TJKuCunSearchViewController alloc] init];
            vc.MyBlock = ^(NSMutableDictionary * dic){
                [self.dataDic removeObjectForKey:@"billid"];
                [self.dataDic removeObjectForKey:@"cpcode"];
                self.dataDic[@"cpcode"] = dic[@"cpcode"];
                self.dataDic[@"billid"] = dic[@"billid"];
                [self.dataArray removeAllObjects];
                [User sharedUser].showMidLoading = @"数据加载中...";
                [self.tableView reloadData];
                [self refreshReserveData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (void)setTopView
{
    UIView * topView = [[[NSBundle mainBundle] loadNibNamed:@"TJReserveManagerCell" owner:self options:nil] objectAtIndex:0];
    topView.width = kScreenWidth;
    topView.height = 55;
    topView.origin = sixFourOrigin;
    [self.view addSubview:topView];
    
    for (int i = 0; i < 3; i ++) {
        UIButton * button = (UIButton *)[topView viewWithTag:110 + i];
        button.titleColor = [UIColor colorWithHexString:@"010101"];
        button.titleFont = 15 * ScaleModel;
        [button addTarget:self action:@selector(reserveChooseStyle:)];
        if (i == 0) {
            button.titleColor = [UIColor colorWithHexString:@"57bdb9"];
            self.buttonSelect = button;
        }
    }
    
    UIView * lineView = [[UIView alloc] initWithFrame:Rect(0, 54, kScreenWidth/3, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"57bdb9"];
    [topView addSubview:lineView];
    self.lineView = lineView;
}
- (void)setButton
{
    UIButton * button = [[UIButton alloc] initWithFrame:Rect(0, 0, 54*ScaleModel, 54*ScaleModel)];
    button.origin = CGPointMake(kScreenWidth - 44 - 54*ScaleModel, kScreenHeigth - 58 - 54*ScaleModel);
    [button setImage:[UIImage imageNamed:@"house_add_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"house_add_select"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(addMessageAction)];
    [self.view addSubview:button];
}
- (void)addMessageAction
{
    TJAddReserveViewController * vc = [[TJAddReserveViewController alloc] init];
    vc.refreshBlock = ^(NSInteger flag){
        self.dataDic[@"cpcode"] = @"";
        self.dataDic[@"billid"] = @"";
        self.dataDic[@"startdate"] = @"";
        self.dataDic[@"enddate"] = @"";
        self.dataDic[@"storetype"] = @"";
        [self.dataArray removeAllObjects];
        [User sharedUser].showMidLoading = @"数据加载中...";
        [self.tableView reloadData];
        [self refreshReserveData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setTableView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    初始化tabelView
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+55+12*ScaleModel, kScreenWidth, kScreenHeigth - 64-55-12*ScaleModel) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshReserveData)];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreReserveData)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
- (void)refreshReserveData
{
    self.page = 1;
    [self loadReserveData:self.flag];
}
- (void)addMoreReserveData
{
    if (self.flag == 2) {
        SVShowError(@"已无更多信息!");
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    self.page++;
    [self loadReserveData:self.flag];
}
#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        return 1;
    }
    return self.dataArray.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return self.tableView.height;
    }
    if (self.flag == 0) {
        CGFloat height = 0;
        NSArray * dataarray = [self.dataArray[indexPath.row][@"sendstr"] componentsSeparatedByString:@"^"];
        CGSize s = [dataarray[1] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-30];
        if ([self.dataArray[indexPath.row][@"logpic"] length] > 0) {
            height = 77;
        }else {
            height = 0;
        }
        return 305 - 11*18 + 10 * fifteenS.height + s.height + height;
    }else if (self.flag == 1) {
        NSArray * dataarray = [self.dataArray[indexPath.row][@"logstr"] componentsSeparatedByString:@"^"];
        CGSize s = [dataarray[1] getStringRectWithfontSize:15*ScaleModel width:kScreenWidth-30];
        return 236 - 8 * 18 + 7 * fifteenS.height + s.height + 8 * ScaleModel;
    } else {
        return 108 - 54 + 3 * fifteenS.height + 8 * ScaleModel;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        TJEmptyTableViewCell * cell = [TJEmptyTableViewCell cellWithTableView:tableView];
        [cell setLabel:[User sharedUser].showMidLoading andFont:15 andColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (self.flag == 0) {
        TJReserveFirstTableViewCell * cell = [TJReserveFirstTableViewCell cellWithTableView:tableView];
        [cell setDataWithLabel:self.dataArray[indexPath.row]];
        [cell setDelegate:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (self.flag == 1) {
        TJReserveTwoTableViewCell * cell = [TJReserveTwoTableViewCell cellWithTableView:tableView];
        [cell setDataWithLabel:self.dataArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        TJReserveThreeTableViewCell * cell = [TJReserveThreeTableViewCell cellWithTableView:tableView];
        [cell setDataWithLabel:self.dataArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        if ([[User sharedUser].showMidLoading isEqualToString:@"点击进行刷新!"]) {
            [User sharedUser].showMidLoading = @"数据加载中...";
            [self.tableView reloadData];
            [self loadReserveData:self.flag];
        }
        return;
    }
}

#pragma mark - buttonAction
- (void)reserveChooseStyle:(UIButton *)button
{
    [YHNetWork stopTheVcRequset:self];
    if (self.buttonSelect.tag == button.tag) {
        return;
    }
    [self.dataDic removeObjectForKey:@"billid"];
    [self.dataDic removeObjectForKey:@"cpcode"];
    [self.dataDic removeObjectForKey:@"startdate"];
    [self.dataDic removeObjectForKey:@"enddate"];
    [self.dataDic removeObjectForKey:@"storetype"];
    self.dataDic[@"cpcode"] = @"";
    self.dataDic[@"billid"] = @"";
    self.dataDic[@"startdate"] = @"";
    self.dataDic[@"enddate"] = @"";
    self.dataDic[@"storetype"] = @"";
    self.flag = button.tag - 110;
    self.buttonSelect.titleColor = [UIColor colorWithHexString:@"010101"];
    button.titleColor = [UIColor colorWithHexString:@"57bdb9"];
    self.buttonSelect = button;
    self.lineView.origin = CGPointMake(kScreenWidth/3 * (button.tag - 110), 54);
    [self.dataArray removeAllObjects];
    [User sharedUser].showMidLoading = @"数据加载中...";
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshReserveData];
    });
}
#pragma mark - delete
- (void)sureNow:(UIButton *)button
{
    TJReserveFirstTableViewCell * cell = (TJReserveFirstTableViewCell *)[[[button superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    self.index = path.row;
    UIView * bgview = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeigth)];
    bgview.backgroundColor = [UIColor blackColor];
    bgview.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:bgview];
    self.backgroundview = bgview;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(surekeyboardhide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [bgview addGestureRecognizer:tapGestureRecognizer];
    
    UIView * midview = [[[NSBundle mainBundle] loadNibNamed:@"TJReserveManagerCell" owner:self options:nil] objectAtIndex:4];
    midview.cornerRadius = 5.0;
    midview.width = kScreenWidth-30*ScaleModel;
    midview.height = 331;
    midview.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:midview];
    
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(surekeyboardhide1)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer1.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [midview addGestureRecognizer:tapGestureRecognizer1];
    
    self.tuihuoview = midview;
    UILabel * jingbanren = (UILabel *)[midview viewWithTag:100];
    jingbanren.text = [User sharedUser].userInfo[@"clerkname"];
    UITextView * content = (UITextView *)[midview viewWithTag:102];
    content.delegate = self;
    content.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    self.content = content;
    UITextField * number = (UITextField *)[midview viewWithTag:101];
    self.number = number;
    UILabel *  placeholder  = (UILabel *)[midview viewWithTag:103];
    placeholder.textColor = [UIColor lightGrayColor];
    self.placeholder = placeholder;
    for (int i = 0; i < 2; i ++) {
        UIView * view = (UIView *)[midview viewWithTag:300 + i];
        view.borderColor = [UIColor colorWithHexString:@"f1f1f1"];
        view.borderWidth = 1.0;
        view.cornerRadius = 5.0;
    }
    for (int i = 0; i < 2; i ++) {
        UIButton * cancle = (UIButton *)[midview viewWithTag:110 + i];
        if (i == 0) {
            cancle.cornerRadius = 5.0;
            cancle.backgroundColor = [UIColor colorWithHexString:@"d1d1d1"];
        }
        if (i == 1) {
            cancle.cornerRadius = 5.0;
            cancle.backgroundColor = fiveblueColor;
        }
        [cancle addTarget:self action:@selector(surebuttonAc:)];
    }
}
- (void)surebuttonAc:(UIButton *)button
{
    if (button.tag == 110) {
        [self surekeyboardhide];
    }
    if (button.tag == 111) {
        [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"信息确认后将发布，是否发布?" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self gohuosure];
            }
        }];
    }
}
-(void)surekeyboardhide{
    [self.backgroundview removeFromSuperview];
    [self.tuihuoview removeFromSuperview];
    self.backgroundview = nil;
    self.tuihuoview = nil;
}
- (void)surekeyboardhide1
{
    [self.tuihuoview endEditing:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeholder.hidden = YES;
    self.tuihuoview.centerY = self.view.centerY - 50;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.placeholder.hidden = YES;
    } else {
        self.placeholder.hidden = NO;
    }
    self.tuihuoview.centerY = self.view.centerY;
}
#pragma mark - 查看大图
- (void)selectImageFromCollectionview:(UICollectionView *)collectionView andIndex:(NSInteger)index andImageArray:(NSMutableArray *)imageArray
{
    [self.imagearray removeAllObjects];
    [self.imagearray addObjectsFromArray:imageArray];
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
    [image sd_setImageWithURL:self.imagearray[index] placeholderImage:[UIImage imageNamed:@"home_photo"]];
    return image.image;
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return self.imagearray[index];
    
}
#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger count = [self.imagearray count];
    
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
#pragma mark - netWorking
- (void)loadReserveData:(NSInteger)flag
{
    if (flag == 0) {
        [self loadGHQR];
    }
    if (flag == 1) {
        [self loadCRKJL];
    }
    if (flag == 2) {
        [self loadKCL];
    }
}
- (void)loadGHQR//供货确认
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = [User sharedUser].userInfo[@"clerkid"];
    params[@"billid"] = self.dataDic[@"billid"];
    params[@"cpcode"] = self.dataDic[@"cpcode"];
    params[@"startdate"] = self.dataDic[@"startdate"];
    params[@"enddate"] = self.dataDic[@"enddate"];
    params[@"recnum"] = @"10";
    params[@"curpage"] = @(self.page);
    if ([self.dataDic[@"billid"] length] == 0) {
        [params removeObjectForKey:@"billid"];
    }
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://wy.cqtianjiao.com/guanjia/sincere/psp/orderconfirmlist.jsp" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * obj = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([obj containsString:@"\t"]) {
            obj = [obj stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        }
        if ([obj containsString:@"\n"]) {
            obj = [obj stringByReplacingOccurrencesOfString:@"\n" withString:@"^"];
        }
        if ([obj containsString:@"\r\n"]) {
            obj = [obj stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        }
        obj = [obj substringToIndex:[obj length] - 1];
        NSError * err;
        NSData * jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];//字符串json转字典
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([dic[@"flag"] integerValue] == 0) {
            if ([dic[@"data"] count] > 0) {
                [self.dataArray addObjectsFromArray:dic[@"data"]];
            }else {
                if (self.page > 1) {
                    SVShowError(@"已无更多数据");
                }
                [User sharedUser].showMidLoading = @"";
            }
        }else {
            [User sharedUser].showMidLoading = @"点击进行刷新!";
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.dataArray.count > 0) {
            SVShowError(@"无网络连接，请检查您的网络!");
            return ;
        }
        [User sharedUser].showMidLoading = @"无网络连接，请检查您的网络!";
        [self.tableView reloadData];
    }];

}
- (void)loadCRKJL//出入库记录
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = [User sharedUser].userInfo[@"clerkid"];
    params[@"billid"] = self.dataDic[@"billid"];
    params[@"storetype"] = self.dataDic[@"storetype"];
    params[@"cpcode"] = self.dataDic[@"cpcode"];
    params[@"startdate"] = self.dataDic[@"startdate"];
    params[@"enddate"] = self.dataDic[@"enddate"];
    params[@"recnum"] = @"10";
    params[@"curpage"] = @(self.page);
    if ([self.dataDic[@"billid"] length] == 0) {
        [params removeObjectForKey:@"billid"];
    }
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://wy.cqtianjiao.com/guanjia/sincere/psp/orderstorelist.jsp" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * obj = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([obj containsString:@"\t"]) {
            obj = [obj stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        }
        if ([obj containsString:@"\n"]) {
            obj = [obj stringByReplacingOccurrencesOfString:@"\n" withString:@"^"];
        }
        if ([obj containsString:@"\r\n"]) {
            obj = [obj stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        }
        obj = [obj substringToIndex:[obj length] - 1];
        NSError * err;
        NSData * jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];//字符串json转字典
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([dic[@"flag"] integerValue] == 0) {
            if ([dic[@"data"] count] > 0) {
                [self.dataArray addObjectsFromArray:dic[@"data"]];
            }else {
                if (self.page > 1) {
                    SVShowError(@"已无更多数据");
                }
                [User sharedUser].showMidLoading = @"";
            }
        }else {
            [User sharedUser].showMidLoading = @"点击进行刷新!";
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.dataArray.count > 0) {
            SVShowError(@"无网络连接，请检查您的网络!");
            return ;
        }
        [User sharedUser].showMidLoading = @"无网络连接，请检查您的网络!";
        [self.tableView reloadData];
    }];
}
- (void)loadKCL//库存量
{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = [User sharedUser].userInfo[@"clerkid"];
    params[@"billid"] = self.dataDic[@"billid"];
    params[@"cpcode"] = self.dataDic[@"cpcode"];
    if ([self.dataDic[@"billid"] length] == 0) {
        [params removeObjectForKey:@"billid"];
    }
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://wy.cqtianjiao.com/guanjia/sincere/psp/orderstorenum.jsp" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * obj = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([obj containsString:@"\t"]) {
            obj = [obj stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        }
        if ([obj containsString:@"\n"]) {
            obj = [obj stringByReplacingOccurrencesOfString:@"\n" withString:@"^"];
        }
        if ([obj containsString:@"\r\n"]) {
            obj = [obj stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        }
        obj = [obj substringToIndex:[obj length] - 1];
        NSError * err;
        NSData * jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];//字符串json转字典
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([dic[@"flag"] integerValue] == 0) {
            if ([dic[@"data"] count] > 0) {
                [self.dataArray addObjectsFromArray:dic[@"data"]];
            }else {
                if (self.page > 1) {
                    SVShowError(@"已无更多数据");
                }
                [User sharedUser].showMidLoading = @"";
            }
        }else {
            [User sharedUser].showMidLoading = @"点击进行刷新!";
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.dataArray.count > 0) {
            SVShowError(@"无网络连接，请检查您的网络!");
            return ;
        }
        [User sharedUser].showMidLoading = @"无网络连接，请检查您的网络!";
        [self.tableView reloadData];
    }];
}
#pragma mark - 共获确认
- (void)gohuosure
{
    NSString * url = @"psp/orderconfirm.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"clerkid"] = userClerkid;
    params[@"logid"] = self.dataArray[self.index][@"logid"];
    params[@"billcode"] = self.number.text;
    params[@"confirmclerkid"] = userClerkid;
    params[@"remark"] = self.content.text;
    [YHNetWork invokeApiAndLoadAlter:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            SVShowSuccess(@"操作成功!");
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[self.index]];
            [dic removeObjectForKey:@"procsta"];
            [dic removeObjectForKey:@"procstaname"];
            dic[@"procsta"] = @"1";
            params[@"procstaname"] = @"已确认";
            [self.dataArray replaceObjectAtIndex:self.index withObject:dic];
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
        self.dataDic[@"enddate"] = @"";
        self.dataDic[@"startdate"] = @"";
        self.dataDic[@"searchkeys"] = @"";
        self.dataDic[@"cpcode"] = @"";
    }
    return _dataDic;
}
@end
