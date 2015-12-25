//
//  OrderInfoView.h
//  tcb
//
//  Created by Chuanxun on 15/11/20.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Order;
@class OrderInfoView;

@protocol OrderInfoViewDelegate <NSObject>

- (void)infoViewBackButtonClicked:(OrderInfoView *)infoView;
- (void)infoViewChangeBox:(OrderInfoView *)infoView;
- (void)infoViewCallButtonClicked:(OrderInfoView *)infoView;

@end


@interface OrderInfoView : UIView

@property (strong, nonatomic) Order *order;

@property (weak, nonatomic) id<OrderInfoViewDelegate> delegate;

+ (instancetype)viewWithOrder:(Order *)order;
- (CGFloat)bestHeight;

@end
