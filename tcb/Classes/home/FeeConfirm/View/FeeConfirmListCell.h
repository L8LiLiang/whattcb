//
//  FeeConfirmListCell.h
//  tcb
//
//  Created by Jax on 15/11/27.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeeConfirmListCell.h"
#import "FeeConfirmModel.h"

@protocol FeeConfirmListCellDelegate <NSObject>

@optional
- (void)nextViewOnTap:(UITapGestureRecognizer *)tap;
- (void)feeConfirm:(UIButton *)sender;

@end

@interface FeeConfirmListCell : UITableViewCell

@property (weak, nonatomic) id<FeeConfirmListCellDelegate> feeConfirmListCellDelegate;

//@property (nonatomic, strong) FeeConfirmModel *feeConfirmModel;
@property (nonatomic, strong) NSArray *feeConfirmItemArray;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeightWithFeeConfirmItemArray:(NSArray *)feeConfirmItemArray;


@end

