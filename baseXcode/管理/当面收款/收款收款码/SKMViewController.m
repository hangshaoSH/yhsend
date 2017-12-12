//
//  SKMViewController.m
//  baseXcode
//
//  Created by app on 2017/8/13.
//  Copyright © 2017年 hangshao. All rights reserved.
//

#import "SKMViewController.h"
#import "GatherRecordViewController.h"
@interface SKMViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   weak) UITableView     * tableView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   assign) NSInteger  index;
@property (nonatomic, assign) NSInteger number;
@end

@implementation SKMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableView];
    
    [self getSKM];
}
#pragma mark - setView
- (void)setTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = BackgroundGrayColor;
    //    初始化tabelView
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeigth - 64) style:UITableViewStylePlain];
    tableView.backgroundColor = BackgroundGrayColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    WeakSelf
    wself.ts_navgationBar = [TSNavigationBar navWithTitle:@"收款码收款" backAction:^{
        [YHNetWork stopTheVcRequset:wself];
        [wself.navigationController popToRootViewControllerAnimated:YES];
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
        return 86 + 12;
    }
    return 280 + 12;
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
        static NSString * ID = @"SKMCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SKMCell" owner:self options:nil] objectAtIndex:0];
        }
        UILabel * address = (UILabel *)[cell.contentView viewWithTag:100];
        address.text = self.address;
        UILabel * money = (UILabel *)[cell.contentView viewWithTag:101];
        money.text = self.money;
        UIButton * button = (UIButton *)[cell.contentView viewWithTag:110];
        button.titleColor = [UIColor redColor];
        [button addTarget:self action:@selector(readRecord)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1){
        static NSString * ID = @"SKMCell1";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SKMCell" owner:self options:nil] objectAtIndex:1];
        }
        UIImageView * image = (UIImageView *)[cell.contentView viewWithTag:100];
        if (self.dataArray.count > 0) {
            image.image = self.dataArray[0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString * ID = @"SKMCell2";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SKMCell" owner:self options:nil] objectAtIndex:2];
    }
    UIImageView * image = (UIImageView *)[cell.contentView viewWithTag:100];
    if (self.dataArray.count > 0) {
        image.image = self.dataArray[1];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [User sharedUser].showMidLoading = @"二维码获取中......!";
    [self.tableView reloadData];
    if (self.jumpFlag == 0) {
        [self flag2];
    } else {
        [self flag1];
    }
}
#pragma mark - button
- (void)readRecord
{
    GatherRecordViewController * vc = [[GatherRecordViewController alloc] init];
    vc.jumpDic = self.jumpDic;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - netWorking
- (void)getSKM
{
    if (self.jumpFlag == 0) {
        [self flag2];
    }else {
        [self flag1];
    }
}
- (void)flag1// 预缴费
{
    NSString * shouidlist = [NSString string];
    NSString * isyu = [NSString string];
    if (self.jumpFlag == 1) {//物业
        shouidlist = [NSString stringWithFormat:@"%@|%@|%@|%@^%@",@"1",self.wydic[@"monthstart"],self.wydic[@"monthend"],self.money,self.jumpDic[@"houseid"]];
        isyu= @"1";
    }
    if (self.jumpFlag == 2) {//车位管理
        isyu= @"2";
         shouidlist = [NSString stringWithFormat:@"%@|%@|%@|%@^%@",@"2",self.wydic[@"monthstart"],self.wydic[@"monthend"],self.money,self.jumpDic[@"houseid"]];
    }
    if (self.jumpFlag == 3) {//月租车位
        isyu= @"3";
         shouidlist = [NSString stringWithFormat:@"%@|%@|%@|%@^%@",@"3",self.wydic[@"monthstart"],self.wydic[@"monthend"],self.money,self.jumpDic[@"houseid"]];
    }
    if (self.jumpFlag == 4) {//不限
        isyu= @"-1";
        shouidlist = @"-1";
    }
    NSString * url = @"wuye/feepay_scan.jsp";

    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"paymoney"] = self.money;
    params[@"isyu"] = isyu;
    params[@"shouidlist"] = shouidlist;//缴费id串
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:request];
            [self set2DWith:self.number];
        }else {
            TSLog(request[@"err"]);
            [User sharedUser].showMidLoading = @"二维码获取失败,点击重新获取!";
        }
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        [User sharedUser].showMidLoading = @"网络连接错误，请检查您的网络!";
        [self.tableView reloadData];
    }];
}
- (void)flag2//欠费
{
    NSString * shouidlist = [NSString string];
    for (int i = 0; i < self.sendArray.count; i ++) {
        NSMutableDictionary * datadic = [NSMutableDictionary dictionaryWithDictionary:self.sendArray[i]];
        shouidlist = [NSString stringWithFormat:@"%@%@|%@|%@,",shouidlist,datadic[@"shouid"],datadic[@"yingshou"],datadic[@"houseid"]];
    }
    shouidlist = [shouidlist substringToIndex:shouidlist.length - 1];
    NSString * url = @"wuye/feepay_scan.jsp";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"paymoney"] = self.money;
    params[@"isyu"] = @"0";
    params[@"froms"] = @"0";
    params[@"shouidlist"] = shouidlist;//缴费id串
    [YHNetWork invokeApi:url args:params target:self completeBlock:^(id request) {
        if ([request[@"flag"] integerValue] == 0) {
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:request];
            [self set2DWith:self.number];
        }else {
            [User sharedUser].showMidLoading = @"二维码获取失败,点击重新获取!";
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

#pragma mark -sd
- (void)set2DWith:(NSInteger)number
{
    if (self.number == 2) {
        [self.tableView reloadData];
        return;
    }
    //1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSString *urlStr = [NSString string];
    if (number == 0) {
        urlStr = self.dataDic[@"alipayurl"];
    } else {
        urlStr = self.dataDic[@"weixinurl"];
    }
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 6. 将CIImage转换成UIImage，并显示于imageView上 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
    [self.dataArray addObject:[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:150]];
    self.number ++;
    [self set2DWith:self.number];
}
/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
@end
