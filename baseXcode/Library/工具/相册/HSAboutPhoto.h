//
//  HSAboutPhoto.h
//  baseXcode
//
//  Created by hangshao on 16/10/31.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HSGetImageBlock)(UIImage *image);
typedef void(^HSGetSaveImageBlock)(UIImage *image);
typedef void(^HSGetImagesBlock)(NSArray *images);
@interface HSAboutPhoto : NSObject

@property (nonatomic,   assign) NSInteger   maxAllow;
/**
 *  选择图片带选择器
 *
 *  @param maxCount 最多几张
 *  @param block    回调图片数组
 */
+ (void)choseImageSAlertWithMaxCount:(NSInteger)maxCount GetImagesBlock:(HSGetImagesBlock)block DissmissBlock:(void(^)())dismiss;
////选择一张图片
+ (void)setMineController:(UIViewController *) controller getImagesBlock:(HSGetImageBlock)block DissmissBlock:(void(^)())dismiss;
////选择一张图片  保存到本地
+ (void)setMineController:(UIViewController *) controller getSaveImagesBlock:(HSGetSaveImageBlock)block DissmissBlock:(void(^)())dismiss;
//获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL;
@end
