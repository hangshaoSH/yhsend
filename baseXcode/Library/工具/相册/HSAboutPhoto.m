//
//  HSAboutPhoto.m
//  baseXcode
//
//  Created by hangshao on 16/10/31.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "HSAboutPhoto.h"
#import "HUImagePickerViewController.h"
@interface HSAboutPhoto ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,HUImagePickerViewControllerDelegate>

@property (nonatomic,   copy) HSGetImageBlock  block;
@property (nonatomic,   copy) HSGetImagesBlock  elseBlock;
@property (nonatomic,   copy) HSGetSaveImageBlock  saveBlock;
@property (nonatomic,   assign)  NSInteger   flag;
@end

@implementation HSAboutPhoto

+ (instancetype)shareInstance{
    static HSAboutPhoto * shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[HSAboutPhoto alloc]init];
    });
    return shareInstance;
}

#pragma mark ---  多张图片
+ (void)choseImageSAlertWithMaxCount:(NSInteger)maxCount GetImagesBlock:(HSGetImagesBlock)block DissmissBlock:(void (^)())dismiss
{
    [HSAboutPhoto shareInstance].flag = 3;
    [HSAboutPhoto shareInstance].elseBlock = block;
    [HSAboutPhoto shareInstance].maxAllow = maxCount;
    [FounctionChose showWithDataList:@[@"相册",@"拍照",@"取消"] choseBlock:^(NSString *buttonTitle, NSInteger index) {
        switch (index) {
            case 0:
                [[HSAboutPhoto shareInstance] choseImagesWithType:0];
                break;
            case 1:
                [[HSAboutPhoto shareInstance] choseImagesWithType:1];
                break;
            default:
                break;
        }
        if (dismiss) {
            dismiss();
        }
    }];
}
- (void)choseImagesWithType:(NSInteger)type{
    if (type==0) {//相册
        HUImagePickerViewController *picker = [[HUImagePickerViewController alloc]init];
        picker.maxAllowedCount = self.maxAllow>0?self.maxAllow:9;
        picker.delegate = self;
        picker.originalImageAllowed = YES;
        [[[(AppDelegate *)([UIApplication sharedApplication].delegate) window] rootViewController]presentViewController:picker animated:YES completion:^{
            
        }];
    }else{//相机
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此设备没有摄像头" delegate:self cancelButtonTitle:@"确定"  otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate= self;
        [[[(AppDelegate *)([UIApplication sharedApplication].delegate) window] rootViewController]presentViewController:picker animated:YES completion:^{
            
        }];
    }
}

#pragma mark 获取到图片
- (void)imagePickerController:(HUImagePickerViewController *)picker didFinishPickingImagesWithInfo:(NSDictionary *)info{
    if ([HSAboutPhoto shareInstance].flag == 3) {
        if (self.elseBlock) {
            self.elseBlock(info[@"kHUImagePickerOriginalImage"]);
        }
    }
}


#pragma mark ---  单张图片

+ (void)setMineController:(UIViewController *) controller getImagesBlock:(HSGetImageBlock)block DissmissBlock:(void(^)())dismiss
{
    [HSAboutPhoto shareInstance].flag = 2;
    [HSAboutPhoto shareInstance].block = block;
    [FounctionChose showWithDataList:@[@"相册",@"拍照",@"取消"] choseBlock:^(NSString *buttonTitle, NSInteger index) {
        switch (index) {
            case 0:
                [[HSAboutPhoto shareInstance] choseImagesWithOneType:0 controller:controller];
                break;
            case 1:
                [[HSAboutPhoto shareInstance] choseImagesWithOneType:1 controller:controller];
                break;
            default:
                break;
        }
        if (dismiss) {
            dismiss();
        }
    }];
}
+ (void)setMineController:(UIViewController *) controller getSaveImagesBlock:(HSGetSaveImageBlock)block DissmissBlock:(void (^)())dismiss
{
    [HSAboutPhoto shareInstance].flag = 1;
    [HSAboutPhoto shareInstance].saveBlock = block;
    [FounctionChose showWithDataList:@[@"相册",@"拍照",@"取消"] choseBlock:^(NSString *buttonTitle, NSInteger index) {
        switch (index) {
            case 0:
                [[HSAboutPhoto shareInstance] choseImagesWithOneType:0 controller:controller];
                break;
            case 1:
                [[HSAboutPhoto shareInstance] choseImagesWithOneType:1 controller:controller];
                break;
            default:
                break;
        }
        if (dismiss) {
            dismiss();
        }
    }];
}
- (void)choseImagesWithOneType:(NSInteger)type controller:(UIViewController *)controller{
    UIImagePickerControllerSourceType sourceType;
    if (type==0) {//相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else{//相机
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此设备没有摄像头" delegate:self cancelButtonTitle:@"确定"  otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    UIImagePickerController *pickerCtrl = [[UIImagePickerController alloc] init];
    pickerCtrl.sourceType = sourceType;
    pickerCtrl.allowsEditing = YES;
    pickerCtrl.delegate = self;
    [controller presentViewController:pickerCtrl animated:YES completion:^{
        
    }];
}
#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self scaleImage:image toScale:0.7];
    if([HSAboutPhoto shareInstance].flag == 1){
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    } else if ([HSAboutPhoto shareInstance].flag == 2) {
        if(self.block){
            self.block(image);
        }
    } else {
        if (self.elseBlock) {
            self.elseBlock(@[[UIImage imageWithData:[ (UIImage *)info[@"UIImagePickerControllerOriginalImage"] compressToSize:1024]]]);
        }
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    TSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 保存图片至相册
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存照片失败" ;
    }else{
        msg = @"保存图片成功" ;
        if(self.saveBlock){
            self.saveBlock(image);
        };
    }
    TSLog(msg);
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
// 根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;                  // url不正确返回CGSizeZero
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self getGIFImageSizeWithRequest:request];
    }
    else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
            size = image.size;
        }
    }
    return size;
}
//  获取PNG图片的大小
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取gif图片的大小
+(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取jpg图片的大小
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}
@end
