//
//  WithoutCollectionCell.m
//  tcb
//
//  Created by Jax on 15/11/27.
//  Copyright © 2015年 Jax. All rights reserved.
//
#import "NSString+Extension.h"
#import "WithoutCollectionCell.h"
#import <UIImageView+WebCache.h>

#define kTopMargin 3
#define kHorizontalMargin 5

@interface WithoutCollectionCell ()

@property (nonatomic, strong) UILabel *feeName;
@property (nonatomic, strong) UILabel *money;
@property (nonatomic, strong) UIImageView *imgView;

@end


@implementation WithoutCollectionCell

/**
 *  快速创建cell的方法
 *
 *  @param tableView cell所在的tableview
 *
 *  @return ListMoreOrderCell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"WithoutCollectionCell";
    WithoutCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WithoutCollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    NSString *moneyString = feeDetailList.Money;
    self.money.text = [NSString stringWithFormat:@"%0.2f", [NSString cgFloatMoneyFromstringMoney:moneyString]];
}

- (void)setUpViews {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kTopMargin);
        make.bottom.equalTo(-kTopMargin);
        make.left.equalTo(kHorizontalMargin);
        make.width.equalTo(self.height);
    }];
    self.imgView = imageView;
    imageView.backgroundColor = kRGB(203, 203, 203);
    
    UIView *rightView = [[UIView alloc] init];
    [self.contentView addSubview:rightView];
    [rightView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kTopMargin);
        make.left.equalTo(imageView.right).offset(kHorizontalMargin);
        make.right.equalTo(self.contentView.right).offset(-kHorizontalMargin);
        make.bottom.equalTo(-kTopMargin);
    }];
    rightView.backgroundColor = [UIColor whiteColor];
    
    UILabel *feeName = [[UILabel alloc] init];
    self.feeName = feeName;
    [rightView addSubview:feeName];
    [feeName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kHorizontalMargin);
        make.top.bottom.equalTo(0);
    }];
    
    UILabel *money= [[UILabel alloc] init];
    self.money = money;
    [rightView addSubview:money];
    [money makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-kHorizontalMargin);
        make.top.bottom.equalTo(0);
    }];
    
}

@end
