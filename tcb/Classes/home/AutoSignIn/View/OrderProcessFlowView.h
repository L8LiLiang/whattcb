//
//  OrderProcessFlowView.h
//  tcb
//
//  Created by Chuanxun on 15/11/17.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderProcessFlowInputBoxNoView.h"
#import "OrderProcessFlowNodeView.h"


@class ELDispatchOrderItem;
@protocol OrderProcessFlowViewDelegate <NSObject,OrderProcessFlowInputBoxNoViewDelegate,OrderProcessFlowNodeViewDelegate>


@end


@interface OrderProcessFlowView : UIScrollView

@property (weak, nonatomic) id<OrderProcessFlowViewDelegate> flowViewDelegate;

@property (assign, nonatomic) CGFloat widthForLayoutSubViews;
@property (strong, nonatomic) ELDispatchOrderItem *orderItem;

- (instancetype)initWithOrderItem:(ELDispatchOrderItem *)orderItem width:(CGFloat)widthForLayoutSubViews delegate:(id<OrderProcessFlowViewDelegate>)delegate;
+ (instancetype)flowViewWithOrderItem:(ELDispatchOrderItem *)orderItem width:(CGFloat)widthForLayoutSubViews delegate:(id<OrderProcessFlowViewDelegate>)delegate;
- (void)printFrame;

@end
