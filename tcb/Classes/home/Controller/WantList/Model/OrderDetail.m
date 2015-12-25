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
    return @{@"item" : [ItemDetail class]};
}
@end

@implementation ItemDetail

@end


