//
//  ListSingleOrderControllerViewController.h
//  tcb
//
//  Created by Jax on 15/11/13.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetail.h"

@interface ListSingleOrderController : UIViewController

/**
 *  派单详情模型
 */
@property (nonatomic, strong) OrderDetail *orderDetail;

@end
