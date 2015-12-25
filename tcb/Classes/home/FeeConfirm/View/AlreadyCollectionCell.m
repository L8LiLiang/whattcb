//
//  AlreadyCollectionCell.m
//  tcb
//
//  Created by Jax on 15/11/27.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "NSString+Extension.h"
#import "AlreadyCollectionCell.h"
#import <UIImageView+WebCache.h>

#define kToMargin 3
#define kHorizontalMargin 5

@interface AlreadyCollectionCell ()

@property (nonatomic, strong) UILabel *feeName;
@property (nonatomic, strong) UILabel *display;
@property (nonatomic, strong) UILabel *money;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation AlreadyCollectionCell

/**
 *  快速创建cell的方法
 *
 *  @param tableView cell所在的tableview
 *
 *  @return ListMoreOrderCell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"AlreadyCollectionCell";
    AlreadyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AlreadyCollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kRGB(235, 234, 234);
        [self setUpViews];
    }
    return self;
}

- (void)setFeeDetailList:(FeeDetailList *)feeDetailList {
   
    
    _feeDetailList = feeDetailList;
    NSURL *imageUrl = [NSURL URLWithString:feeDetailList.ImageUrl];
   [self.imgView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"ic_fee_photo"]];
    self.feeName.text = feeDetailList.FeeName;
    NSString *moneyString        = feeDetailList.Money;
    NSString *writeoffMoney      = feeDetailList.WriteoffMoney;
    CGFloat moneyFloat           = [NSString cgFloatMoneyFromstringMoney:moneyString];
    CGFloat writeoffMoneyFloat   = [NSString cgFloatMoneyFromstringMoney:writeoffMoney];
    
    if (moneyFloat == writeoffMoneyFloat) {
        self.display.text = @"已收款";
        self.display.textColor = kRGB(252, 59, 8);
        NSString *moneyString = feeDetailList.Money;
        self.money.text = [NSString stringWithFormat:@"%0.2f", [NSString cgFloatMoneyFromstringMoney:moneyString]];
    } else if (moneyFloat > writeoffMoneyFloat) {
        self.display.text = @"已部分收款";
        self.display.textColor = kRGB(252, 59, 8);
        NSString *moneyString = feeDetailList.Money;
        NSString *writeoffMoneyString = feeDetailList.WriteoffMoney;
        self.money.text = [NSString stringWithFormat:@"%0.2f(已收%0.2f)", [NSString cgFloatMoneyFromstringMoney:moneyString], [NSString cgFloatMoneyFromstringMoney:writeoffMoneyString]];
    }
}

- (void)setUpViews {
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(2);
        make.left.equalTo(kHorizontalMargin);
        make.width.equalTo(40);
        make.height.equalTo(40);
    }];
    self.imgView = imageView;
    imageView.backgroundColor = kRGB(203, 203, 203);
    
    UIView *rightView = [[UIView alloc] init];
    [self.contentView addSubview:rightView];
    [rightView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView);
        make.left.equalTo(imageView.right).offset(kHorizontalMargin);
        make.right.equalTo(self.contentView.right).offset(-kHorizontalMargin);
        make.bottom.equalTo(imageView);
    }];
    rightView.backgroundColor = [UIColor whiteColor];
    
    UILabel *feeName = [[UILabel alloc] init];
    self.feeName = feeName;
    [rightView addSubview:feeName];
    [feeName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kHorizontalMargin);
        make.centerY.equalTo(rightView.centerY);
    }];
    
    UILabel *display= [[UILabel alloc] init];
    self.display = display;
    [rightView addSubview:display];
    [display makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.right.equalTo(-kHorizontalMargin);
        make.height.equalTo(40 * 0.5);
    }];
    
    UILabel *money= [[UILabel alloc] init];
    self.money = money;
    [rightView addSubview:money];
    [money makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-kHorizontalMargin);
        make.top.equalTo(display.bottom).offset(0);
        make.bottom.equalTo(rightView.bottom).offset(0);
    }];
 
}

@end
