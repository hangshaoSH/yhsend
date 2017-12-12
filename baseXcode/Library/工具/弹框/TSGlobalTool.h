//
//  TSGlobalTool.h
//  UploadAudio
//
//  Created by Seven on 15/8/29.
//  Copyright (c) 2015年 toocms. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^IndexBlock)(NSInteger buttonIndex);

@interface TSGlobalTool : NSObject


// 用block方式封装UIAlertView
//title             标题
//message            信息
//cancelButtonTitle 取消按钮
//otherButtons      其它按钮
//indexBlock      回调block，返回点击了第几个按钮
+(UIAlertView *)alertWithTitle:(NSString*)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
             OtherButtonsArray:(NSArray*)otherButtons
                  clickAtIndex:(IndexBlock)indexBlock;
//用block方式封装UIActionSheet
// title        标题
//cancelTitle  取消按钮
//desTitle     毁灭性按钮
//others       其它按钮
//indexBlock 回调block，返回点击了第几个按钮
+ (UIActionSheet *)actionSheetWithTitle:(NSString *)title
                      cancelButtonTitle:(NSString *)cancelTitle
                 destructiveButtonTitle:(NSString *)desTitle
                      otherButtonTitles:(NSArray *)others
                             showInView:(UIView *)view
                           clickAtIndex:(IndexBlock)indexBlock;
@end
