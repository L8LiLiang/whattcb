//
//  OrderDetail.m
//  tcb
//
//  Created by Jax on 15/11/19.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "OrderDetail.h"

@implementation OrderDetail

+ (NSDictionary *)objectClassInArray{
    return @{@"item" : [OrderItem class]};
}

@end

@implementation OrderItem

+ (NSDictionary *)objectClassInArray{
    return @{@"NodeList" : [Nodelist class]};
}

@end

@implementation Nodelist

@end

