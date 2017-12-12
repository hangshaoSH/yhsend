//
//  HJScrollImage.h
//  HJScrollImage
//
//  Created by hoojack on 15/8/8.
//  Copyright (c) 2015年 hoojack. All rights reserved.
//

#import "HJScrollItemData.h"
#import <UIKit/UIKit.h>

@interface HJScrollImage : UIView

@property (nonatomic, strong) NSArray* datas;
@property (nonatomic, weak) UIPageControl* pageControl;

- (void)stop;

@end
