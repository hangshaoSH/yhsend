//
//  TJLoginView.h
//  baseXcode
//
//  Created by hangshao on 16/11/18.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJLoginDelegate <NSObject>

- (void)loginSucc;

@end

@interface TJLoginView : UIView
@property (nonatomic,   assign) id<TJLoginDelegate>  delegate;
@end
