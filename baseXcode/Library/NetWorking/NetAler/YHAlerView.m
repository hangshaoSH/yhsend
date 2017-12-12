//
//  YHAlerView.m
//  ILiveForiOS
//
//  Created by 于小水 on 15/8/27.
//  Copyright (c) 2015年 于欢. All rights reserved.
//

#import "YHAlerView.h"
#import "YHLabel.h"
@implementation YHAlerView
@synthesize delegate;
-(instancetype)initAlerTitle:(NSString *)title AndMessage:(NSString *)message AndCancleBtn:(NSString *)cancleStr AndOtherCancle:(NSString *)otherStr
{
    self = [super init];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.frame=[[[[UIApplication sharedApplication] delegate] window] bounds];
        UIView *backView=[[UIView alloc]initWithFrame:[[[[UIApplication sharedApplication] delegate] window] bounds]];
        [backView setBackgroundColor:[UIColor blackColor]];
        backView.alpha=0.6;

        [self addSubview:backView];
        UIView *alerView=[[UIView alloc]initWithFrame:Rect(0, 0, 200, 80)];
        alerView.backgroundColor=[UIColor whiteColor];

        alerView.layer.masksToBounds = YES;
        //给图层添加一个有色边框
        alerView.layer.cornerRadius =8;
        alerView.layer.borderWidth =0.5;
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:Rect(0, 10, alerView.width, 22)];
        titleLabel.font=[UIFont systemFontOfSize:15];
        titleLabel.text=title;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [alerView addSubview:titleLabel];

        UILabel *messageLabel=[[UILabel alloc]initWithFrame:Rect(10, titleLabel.endY+10, alerView.width-20, 0)];
        messageLabel.text=message;
        messageLabel.font=[UIFont systemFontOfSize:15];
        messageLabel.textAlignment=NSTextAlignmentCenter;
        [YHLabel LabelToFit:messageLabel];
        if(messageLabel.width<alerView.width-20){
            messageLabel.width=alerView.width-20;
        }
        [alerView addSubview:messageLabel];

        if(otherStr==nil){
            UIButton *cancleBtn=[[UIButton alloc]initWithFrame:Rect(alerView.w/2-30, messageLabel.endY+10, 60, 40)];
            [cancleBtn setBackgroundImage:[UIImage imageNamed:@"login_bnt_registered_n"] forState:UIControlStateNormal];
            [cancleBtn setTitle:cancleStr forState:UIControlStateNormal];
            [cancleBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
            cancleBtn.titleLabel.font=[UIFont systemFontOfSize:15];
            [alerView addSubview:cancleBtn];
            alerView.H=cancleBtn.endY+10;
        }else {
            UIButton *cancleBtn=[[UIButton alloc]initWithFrame:Rect(alerView.w/2-60-10, messageLabel.endY+10, 60, 40)];
            [cancleBtn setBackgroundImage:[UIImage imageNamed:@"取消按钮"] forState:UIControlStateNormal];
            [cancleBtn setTitle:cancleStr forState:UIControlStateNormal];
            [cancleBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
            cancleBtn.titleLabel.font=[UIFont systemFontOfSize:15];
            [alerView addSubview:cancleBtn];
            UIButton *otherBtn=[[UIButton alloc]initWithFrame:Rect(alerView.w/2+10, messageLabel.endY+10, 60, 40)];
            [otherBtn setBackgroundImage:[UIImage imageNamed:@"login_bnt_registered_n"] forState:UIControlStateNormal];
            [otherBtn setTitle:otherStr forState:UIControlStateNormal];
            [otherBtn addTarget:self action:@selector(otherBtn:) forControlEvents:UIControlEventTouchUpInside];
            otherBtn.titleLabel.font=[UIFont systemFontOfSize:15];
            [alerView addSubview:otherBtn];
            alerView.H=cancleBtn.endY+10;
        }
        [self addSubview:alerView];
        alerView.center=self.center;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {

}
-(void)cancelBtn:(UIButton *)sender{
    if ([delegate respondsToSelector:@selector(selectCancle:)]) {
        [self.delegate selectCancle:self];
    }
    [self removeFromSuperview];
}
-(void)otherBtn:(UIButton *)sender{
    if ([delegate respondsToSelector:@selector(selectSure:)]) {
        [self.delegate selectSure:self];
    }
}
-(void)show{
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
}
@end
