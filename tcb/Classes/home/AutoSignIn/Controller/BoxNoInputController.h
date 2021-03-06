//
//  BoxNoInputController.h
//  tcb
//
//  Created by Chuanxun on 15/11/23.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELDispatchOrderItem;
@interface BoxNoInputController : UIViewController

@property (strong, nonatomic) ELDispatchOrderItem *orderItem;

+ (instancetype)controllerWithOrder:(ELDispatchOrderItem *)order;

@end
