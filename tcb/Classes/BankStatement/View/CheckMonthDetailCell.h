//
//  CheckMonthDetailCell.h
//  tcb
//
//  Created by Chuanxun on 15/12/4.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELMonthReconciliationDetail;
@class CheckMonthDetailCell;


@protocol CheckMonthDetailCellDelegate <NSObject>

- (void) detailCellDetailBtnClicked:(CheckMonthDetailCell*)cell;

@end




@interface CheckMonthDetailCell : UITableViewCell

@property (weak, nonatomic) id<CheckMonthDetailCellDelegate>delegate;
@property (strong, nonatomic) ELMonthReconciliationDetail *reconciliationDetail;

+ (CGFloat)cellHeight;


@end
