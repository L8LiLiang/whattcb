//
//  OrderProcessFlowNodeView.h
//  tcb
//
//  Created by Chuanxun on 15/11/17.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger,NodeType) {
    NODE_TYPE_AUTO = 0,
    NODE_TYPE_MANUAL = 1,
    NODE_TYPE_UNKNOWN = 10
};

typedef NS_ENUM(NSUInteger,NodeStatus) {
    NODE_STATUS_FINISHED = 0,
    NODE_STATUS_PROCESS = 1,
    NODE_STATUS_NEED_TO_DO = 2
};

#define K_NODEVIEW_LABEL1 @"nodeview_label1"
#define K_NODEVIEW_LABEL2 @"nodeview_label2"
#define K_NODEVIEW_ICON @"nodeview_icon"

@class OrderProcessFlowNodeView;
@protocol OrderProcessFlowNodeViewDelegate <NSObject>

- (void)flowNodeViewCall:(OrderProcessFlowNodeView *)view;
- (void)flowNodeViewSign:(OrderProcessFlowNodeView *)view success:(void(^)(void))block;

@end


@interface OrderProcessFlowNodeView : UIView

@property (weak, nonatomic) id<OrderProcessFlowNodeViewDelegate> delegate;
@property (strong, nonatomic) NSArray *contents;
@property (strong, nonatomic) NSArray *nodes;
@property (assign, nonatomic) NodeType type;
@property (assign, nonatomic) NodeStatus status;
//*  [{K_NODEVIEW_LABEL1:label1,K_NODEVIEW_LABEL2:label2,K_NODEVIEW_ICON:nil}]  */
+ (instancetype)nodeViewWithArray:(NSArray *)array type:(NodeType)type status:(NodeStatus)status nodes:(NSArray *)nodes;
- (instancetype)initWithArray:(NSArray *)array  type:(NodeType)type status:(NodeStatus)status nodes:(NSArray *)nodes;
-(CGFloat)estimatedHeightWithWidth:(CGFloat)width;

@end
