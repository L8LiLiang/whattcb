//
//  OrderProcessFlowNodeView.h
//  tcb
//
//  Created by Chuanxun on 15/11/17.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger,NodeType) {
    NODE_TYPE_COMMON = 0,
    NODE_TYPE_SHI_FENG = 1
};

#define K_NODEVIEW_LABEL1 @"nodeview_label1"
#define K_NODEVIEW_LABEL2 @"nodeview_label2"
#define K_NODEVIEW_ICON @"nodeview_icon"

@class OrderProcessFlowNodeView;
@protocol OrderProcessFlowNodeViewDelegate <NSObject>



@end


@interface OrderProcessFlowNodeView : UIView

@property (weak, nonatomic) id<OrderProcessFlowNodeViewDelegate> delegate;
@property (strong, nonatomic) NSArray *contents;
@property (assign, nonatomic) NodeType type;

//*  [{K_NODEVIEW_LABEL1:label1,K_NODEVIEW_LABEL2:label2,K_NODEVIEW_ICON:nil}]  */
+ (instancetype)nodeViewWithArray:(NSArray *)array type:(NodeType)type;

-(CGFloat)estimatedHeightWithWidth:(CGFloat)width;

@end
