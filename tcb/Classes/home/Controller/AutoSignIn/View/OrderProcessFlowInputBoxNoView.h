//
//  OrderProcessFlowInputBoxNoView.h
//  tcb
//
//  Created by Chuanxun on 15/11/20.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderProcessFlowInputBoxNoView;

@protocol OrderProcessFlowInputBoxNoViewDelegate <NSObject>

- (void)inputBoxNoView:(OrderProcessFlowInputBoxNoView *)view btnClicked:(UIButton *)button;

@end

@interface OrderProcessFlowInputBoxNoView : UIView

@property (weak, nonatomic) id<OrderProcessFlowInputBoxNoViewDelegate>delegate;

+ (instancetype)boxNoView;

- (CGFloat)estimatedHeightWithWidth:(CGFloat)width;


@end
