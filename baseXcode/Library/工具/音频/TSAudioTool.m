//
//  TSAudioTool.m
//  UploadAudio
//
//  Created by Seven on 15/8/29.
//  Copyright (c) 2015年 toocms. All rights reserved.
//  处理系统相册业务

#import "TSAudioTool.h"
#import <AssetsLibrary/AssetsLibrary.h>

static ImageCompleteBlock completeBlock;
@implementation TSAudioTool

+ (void)saveVideoToPhotoAlbum:(NSString *)videoName complete:(void (^)(NSURL *assetURL, NSError *error))success
{
    
    ALAssetsLibrary * lib = [[ALAssetsLibrary alloc] init];
    [lib writeVideoAtPathToSavedPhotosAlbum:[[NSBundle mainBundle] URLForResource:videoName withExtension:nil] completionBlock:^(NSURL *assetURL, NSError *error)
    {
        if (success) {
            success(assetURL, error);
        }
    }];
    
}

+ (void)savePhotoToPhotoAlbum:(UIImage *)image complete:(ImageCompleteBlock)imageBlock
{
    completeBlock = [imageBlock copy];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (completeBlock) {
        completeBlock(image, error);
        completeBlock = nil;
    }
}
@end