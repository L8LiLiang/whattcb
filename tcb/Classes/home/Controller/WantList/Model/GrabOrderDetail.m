//
//  GrabOrderDetail.m
//  tcb
//
//  Created by Jax on 15/11/20.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "GrabOrderDetail.h"

@implementation GrabOrderDetail


+ (NSDictionary *)objectClassInArray{
    return @{@"items" : [GrabOrderItem class]};
}
@end

@implementation GrabOrderItem

@end


