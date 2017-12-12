//
//  TJHomeTopView.h
//  baseXcode
//
//  Created by hangshao on 16/11/18.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJHomeTopDelegate <NSObject>

- (void)changePerson;

@end

@interface TJHomeTopView : UIView
@property (nonatomic,   assign) id<TJHomeTopDelegate>  delegate;
@property (weak, nonatomic) IBOutlet UILabel *nowDayShow;
@property (weak, nonatomic) IBOutlet UILabel *xingqi;
@property (weak, nonatomic) IBOutlet UIButton *rightBut;


@end
