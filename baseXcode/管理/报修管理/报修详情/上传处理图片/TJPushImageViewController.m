//
//  TJPushImageViewController.m
//  baseXcode
//
//  Created by hangshao on 16/12/9.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJPushImageViewController.h"
#import "TJAddImageCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>
@interface TJPushImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TJAddImageDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,   weak) UICollectionView     * collectionView;
@property (nonatomic,   strong) NSMutableArray     * dataArray;
@property (nonatomic,   strong) NSMutableArray     * pushArray;
@property (nonatomic,   strong) NSMutableDictionary     * dataDic;
@property (nonatomic,   assign) NSInteger  countIndex;
@property (nonatomic,   strong) NSMutableArray     * imageArray;//上传之后返回的
@property (nonatomic,   assign) NSInteger  deleteFlag;
@end

@implementation TJPushImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pushArray = [NSMutableArray arrayWithCapacity:0];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    if (self.haveImageArray.count > 0) {
        [self.dataArray addObjectsFromArray:self.haveImageArray];
    }
    self.imageArray = [NSMutableArray arrayWithCapacity:0];
    [self setBottomView];
    
    [self setTableView];
}
#pragma mark - setView

- (void)setBottomView
{
    UIButton * button = [[UIButton alloc] initWithFrame:Rect(0, kScreenHeigth-43*ScaleModel, kScreenWidth, 43*ScaleModel)];
    button.title = @"立即上传";
    button.tintColor = [UIColor whiteColor];
    button.backgroundColor = orangecolor;
    button.titleFont = 15 * ScaleModel;
    [button addTarget:self action:@selector(beforGoPush)];
    [self.view addSubview:button];
}
- (void)setTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView * collection = [[UICollectionView alloc] initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeigth - 64 - 43 * ScaleModel) collectionViewLayout:layout];
    collection.showsHorizontalScrollIndicator = NO;
    collection.backgroundColor = [UIColor clearColor];
    [collection registerClass:[TJAddImageCollectionViewCell class] forCellWithReuseIdentifier:@"TJAddImageCollectionCell"];
    collection.delegate = self;
    collection.dataSource = self;
    [self.view addSubview:collection];
    self.collectionView = collection;
    WeakSelf
    wself.ts_navgationBar = [TSNavigationBar navWithTitle:@"添加图片" backAction:^{
        if (self.deleteFlag == 1) {
            [[HSMidView sharedInstance] setMidViewWidth:kScreenWidth - 74 viewColor:[UIColor whiteColor] WithTitle:@"您有图片被删除，是否保存返回!" titleColor:[UIColor blackColor] AndMessage:@"" messageColor:@"" AndLeftName:@"否" leftTitleColor:[UIColor whiteColor] leftBackColor:@"d1d1d1" AndRightName:@"是" rightTitleColor:[UIColor whiteColor] rightBackColor:@"57bdb9" clickAtIndex:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    if (self.deleteBlock) {
                        self.deleteBlock(self.imageArray);
                    }
                    [YHNetWork stopTheVcRequset:wself];
                    [wself.navigationController popViewControllerAnimated:YES];
                }else {
                    [YHNetWork stopTheVcRequset:wself];
                    [wself.navigationController popViewControllerAnimated:YES];
                }
            }];
        }else {
            if (self.returnBlock) {
                self.returnBlock();
            }
            [YHNetWork stopTheVcRequset:wself];
            [wself.navigationController popViewControllerAnimated:YES];
        }
        
    }];
}
#pragma mark - collectionview delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_dataArray.count == self.imageCount) {
        return _dataArray.count;
    }
    return _dataArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TJAddImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TJAddImageCollectionCell" forIndexPath:indexPath];
    if (indexPath.row == _dataArray.count) {
        [cell setImage:[UIImage imageNamed:@""] hidden:YES];
        [cell setCancelHidden:YES];
        cell.delegate = nil;
    }else if (indexPath.row == _dataArray.count + 1){
        [cell setImage:[UIImage imageNamed:@""] hidden:YES];
        [cell setCancelHidden:YES];
        cell.delegate = nil;
    }else{
        [cell setRow:indexPath.row];
//        [cell setImage:_dataArray[indexPath.row] hidden:NO];
        [cell setImage1:_dataArray[indexPath.row] hidden:NO];
        [cell setCancelHidden:NO];
        cell.delegate = self;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(73 * ScaleModel, 73 * ScaleModel);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10*ScaleModel, 10*ScaleModel, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count == self.imageCount) {
        return;
    }
    if (indexPath.row == _dataArray.count) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册",nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }
}

- (void)cancelDidClicked:(NSInteger)index
{
    [_dataArray removeObjectAtIndex:index];
    [self.collectionView reloadData];
    self.deleteFlag = 1;
}

#pragma mark - buttonAction
- (void)beforGoPush
{
    if (self.dataArray.count == 0) {
        SVShowError(@"请选择图片!");
        return;
    }
    for (int i = 0; i < self.dataArray.count; i ++) {
        if ([self.dataArray[i] isKindOfClass:[NSString class]]) {
            [self.imageArray addObject:self.dataArray[i]];
        } else {
            [self.pushArray addObject:self.dataArray[i]];
        }
    }
    if (self.pushArray.count == 0) {
        SVShowSuccess(@"图片编辑成功!");
        if (self.MyBlock) {
            self.MyBlock(self.imageArray);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self goPush];
    }
}
- (void)goPush//上传图片
{
    NSString * url = @"http://wy.cqtianjiao.com/guanjia/sincere/wuye/uploadPic.jsp";
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setValue:self.billid forKey:@"billid"];
    [dic setValue:[User sharedUser].userInfo[@"clerkid"] forKey:@"clerkid"];
    [dic setValue:self.pushArray[self.countIndex] forKey:@"pics"];
    [[FSSummitFile shareInstance] httpRequestWithURL:url params:dic fileKey:@"pics" fileName:@"image" fireFormat:@"png" filePath:nil];
    [[FSSummitFile shareInstance] setLoadFinsh:^(NSDictionary *resultDic) {
        int statu= [[resultDic objectForKey:@"flag"] intValue];
        if (statu == 0) {
            [self.imageArray addObject:resultDic[@"pics"]];
            self.countIndex ++;
            if (self.countIndex < self.pushArray.count) {
                [self goPush];
            }else {
                SVShowSuccess(@"上传成功");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.MyBlock) {
                        self.MyBlock(self.imageArray);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } else {
            SVShowError(@"上传失败,请稍后再试");
        }
    }];
}
#pragma mark - delete
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType;
    
    if (buttonIndex == 0) {
        //拍照
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        
        if (!isCamera) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此设备没有摄像头" delegate:self cancelButtonTitle:@"确定"  otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            NSString *errorStr = @"应用相机权限受限,请在设置中启用";
            [TSGlobalTool alertWithTitle:@"提示" message:errorStr cancelButtonTitle:@"知道了" OtherButtonsArray:nil clickAtIndex:^(NSInteger buttonIndex) {
                
            }];
            return;
        }
        sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else if (buttonIndex == 1) {
        
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    } else {
        return;
    }
    
    UIImagePickerController *pickerCtrl = [[UIImagePickerController alloc] init];
    pickerCtrl.sourceType = sourceType;
    pickerCtrl.allowsEditing = YES;
    pickerCtrl.delegate = self;
    [self presentViewController:pickerCtrl animated:YES completion:nil];
}

#pragma mark - UIImagePickerController delegate
//图片选择完成以后 执行此方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    [picker dismissModalViewControllerAnimated:YES];
    image = [self scaleImage:image toScale:0.7];
    [_dataArray addObject:image];
    [self.collectionView reloadData];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
#pragma mark - 保存图片至相册
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存照片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    NSLog(@"%@",msg);
}
#pragma mark-压缩图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
#pragma mark - netWorking


#pragma mark - 懒加载

- (NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
@end
