//
//  CheckMonthDetailFooterView.h
//  tcb
//
//  Created by Chuanxun on 15/12/4.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELMonthReconciliationList.h"

@class ELMonthReconciliationDetailList;
@class CheckMonthDetailFooterView;



@protocol CheckMonthDetailFooterViewDelegate <NSObject>

- (void)allReturn:(CheckMonthDetailFooterView *)view;
- (void)allConfirm:(CheckMonthDetailFooterView *)view;
- (void)confirmAccount:(CheckMonthDetailFooterView *)view;
- (void)lookDetail:(CheckMonthDetailFooterView *)view;

@end


@interface CheckMonthDetailFooterView : UIView

@property (weak, nonatomic) id<CheckMonthDetailFooterViewDelegate>delegate;

@property (strong, nonatomic) ELMonthReconciliationDetailList *detailList;

+ (instancetype)footerViewWithStatus:(CheckStatus)status;

+ (CGFloat)bestHeight;

@end
