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

@interface Order : NSObject
@property (strong, nonatomic) NSArray *titles;

@end

@protocol OrderProcessFlowViewDelegate <NSObject,OrderProcessFlowInputBoxNoViewDelegate,OrderProcessFlowNodeViewDelegate>


@end


@interface OrderProcessFlowView : UIScrollView

@property (weak, nonatomic) id<OrderProcessFlowViewDelegate> flowViewDelegate;

@property (assign, nonatomic) CGFloat widthForLayoutSubViews;
@property (strong, nonatomic) Order *order;

+ (instancetype)flowViewWithOrder:(Order *)order width:(CGFloat)widthForLayoutSubViews delegate:(id<OrderProcessFlowViewDelegate>)delegate;
- (void)printFrame;

@end
