//
//  GrabOrder.m
//  tcb
//
//  Created by Jax on 15/11/20.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "GrabOrder.h"

@implementation GrabOrder


+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [GrabList class]};
}
@end
@implementation GrabList

+ (NSDictionary *)objectClassInArray{
    return @{@"items" : [GrabItem class]};
}

@end


@implementation GrabItem

@end


