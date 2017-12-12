//
//  YHAlerView.h
//  ILiveForiOS
//
//  Created by 于小水 on 15/8/27.
//  Copyright (c) 2015年 于欢. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YHAlerDelegate <NSObject>
@optional
-(void)selectSure:(UIView *)alerView;
-(void)selectCancle:(UIView *)alerView;
@end
@interface YHAlerView : UIView
-(instancetype)initAlerTitle:(NSString *)title AndMessage:(NSString *)message AndCancleBtn:(NSString *)cancleStr AndOtherCancle:(NSString *)otherStr;
-(void)show;
@property(nonatomic,weak)id<YHAlerDelegate> delegate;
@end
