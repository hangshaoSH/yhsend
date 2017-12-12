//
//  TJMemberFooterTableViewCell.h
//  baseXcode
//
//  Created by hangshao on 16/11/20.
//  Copyright © 2016年 hangshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJMemberFooterDelegate <NSObject>
- (void)chooseAddressAction;
- (void)yesOrNoShouliAc:(NSInteger)flag;

@end

@interface TJMemberFooterTableViewCell : UITableViewCell
@property (nonatomic,   assign) id<TJMemberFooterDelegate>  delegate;
@property (weak, nonatomic) IBOutlet UILabel *yezhuxinxi;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UITextField *addressT;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UIButton *shouli;
@property (weak, nonatomic) IBOutlet UIButton *bushouli;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setDataWithDic:(NSMutableDictionary *)dic dic1:(NSMutableDictionary *)dic1;
- (void)isshowHouseId:(BOOL)show;
@end
