//
//  CheckListCell.h
//  tcb
//
//  Created by Jax on 15/12/4.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "FeeConfirmModel.h"

@protocol CheckListCellDelegate <NSObject>

@optional
- (void)nextViewOnTap:(UITapGestureRecognizer *)tap;
- (void)feeConfirm:(UIButton *)sender;
- (void)contactFleet:(UIButton *)sender;

@end

@interface CheckListCell : UITableViewCell

@property (weak, nonatomic) id<CheckListCellDelegate> checkListCellDelegate;

//@property (nonatomic, strong) FeeConfirmModel *feeConfirmModel;
@property (nonatomic, strong) NSArray *feeConfirmItemArray;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeightWithFeeConfirmItemArray:(NSArray *)feeConfirmItemArray;


@end

