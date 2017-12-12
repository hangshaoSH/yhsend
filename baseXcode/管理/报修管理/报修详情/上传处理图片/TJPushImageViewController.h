//
//  TJPushImageViewController.h
//  baseXcode
//
//  Created by hangshao on 16/12/9.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "BaseViewController.h"

@interface TJPushImageViewController : BaseViewController
@property (nonatomic,   copy) NSString     * billid;
@property (nonatomic,   assign) NSInteger   imageCount;
@property (nonatomic,   strong) NSMutableArray     * haveImageArray;
@property (nonatomic, copy) void(^returnBlock)();
@property (nonatomic, copy) void(^MyBlock)(NSMutableArray * imageArray);
@property (nonatomic, copy) void(^deleteBlock)(NSMutableArray * imageArray);
@end
