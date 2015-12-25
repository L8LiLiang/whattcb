//
//  CheckMonthCell.h
//  tcb
//
//  Created by Chuanxun on 15/12/3.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ELMonthReconciliation;
@class CheckMonthCell;


@protocol CheckMonthCellDelegate <NSObject>

- (void) checkMonthCellDeatilButtonClicked:(CheckMonthCell *)cell;
- (void) checkMonthReturnBack:(CheckMonthCell *)cell;
- (void) checkMonthCellConfirm:(CheckMonthCell *)cell;
- (void) checkMonthCellConfirmAccount:(CheckMonthCell *)cell;
- (void) checkMonthCellTelephone:(CheckMonthCell *)cell;

@end





@interface CheckMonthCell : UITableViewCell

@property (weak, nonatomic) id<CheckMonthCellDelegate> delegate;
@property (strong, nonatomic) ELMonthReconciliation *reconciliation;
+ (CGFloat)cellHeight;

@end
