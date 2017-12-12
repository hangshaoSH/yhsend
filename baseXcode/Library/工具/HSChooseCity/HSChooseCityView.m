//
//  HSChooseCityView.m
//  baseXcode
//
//  Created by hangshao on 16/11/22.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import "HSChooseCityView.h"
#import "PSCityPickerView.h"
static HSChooseCityView * _chooseCityView = nil;
static cityblock _cityblock;
@interface HSChooseCityView ()<PSCityPickerViewDelegate>
@property (strong, nonatomic) PSCityPickerView *cityPicker;
@property (nonatomic,   weak) UIView     * bgView;
@property (nonatomic,   weak) UIView     * whiteView;
@property (nonatomic,   strong) NSString     * retustr;
@end
@implementation HSChooseCityView

+(instancetype)sharedInstance
{
    if (_chooseCityView == nil) {
        _chooseCityView = [[self alloc] init];
    }
    return _chooseCityView;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _chooseCityView = [super allocWithZone:zone];
    });
    return _chooseCityView;
}
- (void)clickAtIndex:(cityblock)block
{
    _cityblock = [block copy];
    self.retustr = @"北京市－北京市－东城区";
    UIView * bgView = [[UIView alloc] initWithFrame:[([UIApplication sharedApplication].delegate) window].rootViewController.view.frame];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.2;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    self.bgView = bgView;
    
    UIView * whiteView = [[[NSBundle mainBundle] loadNibNamed:@"HSChooseCityCell" owner:self options:nil] lastObject];
    whiteView.frame = Rect(0, kScreenHeigth/2 - 32 + 64, kScreenWidth, kScreenHeigth/2 - 32);
    whiteView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:whiteView];
    self.whiteView = whiteView;
    
    UILabel * topLabel = (UILabel *)[whiteView viewWithTag:100];
    topLabel.text = @"请选择户籍地";
    topLabel.font = fifteenFont;
    topLabel.textColor = [UIColor blackColor];
    
    UIView * view = (UIView *)[whiteView viewWithTag:101];
    for (int i = 0; i < 2; i ++) {
       UIButton * button = (UIButton *)[whiteView viewWithTag:110 + i];
        [button addTarget:self action:@selector(chooseAc:)];
        button.cornerRadius = 5.0;
        if (i == 0) {
            button.backgroundColor = orangecolor;
            button.title = @"确定";
            button.titleFont = 15*ScaleModel;
        } else {
            button.backgroundColor = [UIColor colorWithHexString:@"d0d0d0"];
            button.title = @"取消";
            button.titleFont = 15*ScaleModel;
        }
    }
    
    _cityPicker = [[PSCityPickerView alloc] init];
    _cityPicker.cityPickerDelegate = self;
    _cityPicker.origin = CGPointMake(0, 0);
    _cityPicker.width = kScreenWidth;
    _cityPicker.height = whiteView.height - 143;
    [view addSubview:_cityPicker];
}
- (void)chooseAc:(UIButton *)button
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (button.tag == 110) {
        dic[@"city"] = self.retustr;
    } else {
        dic[@"city"] = @"";
    }
    if (_cityblock) {
        _cityblock(dic);
    }
    [self.bgView removeFromSuperview];
    [self.whiteView removeFromSuperview];
    [self.cityPicker removeFromSuperview];
    self.cityPicker = nil;
    self.bgView = nil;
    self.whiteView = nil;
}
- (void)cityPickerView:(PSCityPickerView *)picker
    finishPickProvince:(NSString *)province
                  city:(NSString *)city
              district:(NSString *)district
{
    self.retustr = [NSString stringWithFormat:@"%@－%@－%@",province,city,district];
}
@end
