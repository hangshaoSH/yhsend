//
//  TJMemberHeyanView.m
//  baseXcode
//
//  Created by hangshao on 16/12/1.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "TJMemberHeyanView.h"
static TJMemberHeyanView * _heYanView = nil;
static myBlock _myBlock;
@interface TJMemberHeyanView ()<UITextViewDelegate>
@property (nonatomic,   weak) UIView     * midview;
@property (nonatomic,   weak) UIView     * bgView;
@property (nonatomic,   weak) UITextView     * textV;
@property (nonatomic,   weak) UIView     * colorView;
@end

@implementation TJMemberHeyanView
+(instancetype)sharedInstance
{
    if (_heYanView == nil) {
        _heYanView = [[self alloc] init];
    }
    return _heYanView;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _heYanView = [super allocWithZone:zone];
    });
    return _heYanView;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
}
- (void)setMidViewWithTitle:(NSString *)title returnString:(myBlock)myBlock;
{
    _myBlock = [myBlock copy];
    UIView * bgview = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeigth)];
    bgview.backgroundColor = [UIColor blackColor];
    bgview.alpha = 0.2;
    [[UIApplication sharedApplication].keyWindow addSubview:bgview];
    self.bgView = bgview;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardhide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [bgview addGestureRecognizer:tapGestureRecognizer];
    
    UIView * midview = [[[NSBundle mainBundle] loadNibNamed:@"TJMemberManagecell" owner:self options:nil] objectAtIndex:4];
    midview.cornerRadius = 5.0;
    midview.width = 287 * ScaleModel;
    midview.height = 216 * ScaleModel;
    midview.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:midview];
    
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardhide1)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer1.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [midview addGestureRecognizer:tapGestureRecognizer1];
    
    self.midview = midview;
    UILabel * topL = (UILabel *)[midview viewWithTag:100];
    topL.text = title;
    topL.font = seventeenFont;
    
    UITextView * text = (UITextView *)[midview viewWithTag:101];
    text.delegate = self;
    text.inputAccessoryView = [SLInputAccessoryView inputAccessoryView];
    self.textV = text;
    
    UIView * colorView = (UIView *)[midview viewWithTag:102];
    colorView.cornerRadius = 5.0;
    colorView.borderColor = [UIColor colorWithHexString:@"fb652c"];
    colorView.borderWidth = 0.7;
    self.colorView = colorView;
    
    UIButton * sure = (UIButton *)[midview viewWithTag:110];
    sure.cornerRadius = 5.0;
    sure.backgroundColor = fiveblueColor;
    sure.titleFont = 19 * ScaleModel;
    [sure addTarget:self action:@selector(sure)];
    [self.textV becomeFirstResponder];
}
- (void)sure
{
    if (self.textV.text.length == 0) {
        SVShowError(@"请填写回复!");
        return;
    }
    [self keyboardhide];
    if (_myBlock) {
        _myBlock(self.textV.text);
    }
}
-(void)keyboardhide{
    [self.bgView removeFromSuperview];
    [self.midview removeFromSuperview];
    self.bgView = nil;
    self.midview = nil;
}
- (void)keyboardhide1
{
    [self.midview endEditing:YES];
}
@end
