//
//  OrderInfoView.h
//  tcb
//
//  Created by Chuanxun on 15/11/20.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELDispatchOrder;
@class OrderInfoView;

@protocol OrderInfoViewDelegate <NSObject>

- (void)infoViewBackButtonClicked:(OrderInfoView *)infoView;
- (void)infoViewChangeBox:(OrderInfoView *)infoView toIndex:(NSInteger)index;
- (void)infoViewCallButtonClicked:(OrderInfoView *)infoView;

@end


@interface OrderInfoView : UIView

@property (strong, nonatomic) ELDispatchOrder *order;

@property (weak, nonatomic) id<OrderInfoViewDelegate> delegate;

+ (instancetype)viewWithOrder:(ELDispatchOrder *)order selectedIndex:(NSInteger)index;
- (CGFloat)bestHeight;

@end
