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


typedef NS_ENUM(NSUInteger,InputBoxNoViewStatus) {
    InputBoxNoViewStatus_NeedInput = 0,
    InputBoxNoViewStatus_DisplayNo = 1
};

@interface OrderProcessFlowInputBoxNoView : UIView

@property (weak, nonatomic) id<OrderProcessFlowInputBoxNoViewDelegate>delegate;
@property (assign, nonatomic) InputBoxNoViewStatus status;

@property (copy, nonatomic) NSString *strFenghao;
@property (copy, nonatomic) NSString *strGuihao;
@property (copy, nonatomic) NSString *strDate;

+ (instancetype)boxNoViewWithStatus:(InputBoxNoViewStatus)status;
-(instancetype)initWithStatus:(InputBoxNoViewStatus)status;
- (CGFloat)estimatedHeightWithWidth:(CGFloat)width;


@end
