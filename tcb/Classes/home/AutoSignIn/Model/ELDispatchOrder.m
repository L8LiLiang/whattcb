//
//  ELDispatchOrder.m
//  tcb
//
//  Created by Chuanxun on 15/11/27.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ELDispatchOrder.h"


@implementation ELDispatchOrderItemNode



@end


@implementation ELDispatchOrderItem

+ (NSDictionary *)objectClassInArray{
    return @{@"NodeList" : [ELDispatchOrderItemNode class]};
}

@end


@implementation ELDispatchOrder

+ (NSDictionary *)objectClassInArray{
    return @{@"item" : [ELDispatchOrderItem class]};
}

@end
