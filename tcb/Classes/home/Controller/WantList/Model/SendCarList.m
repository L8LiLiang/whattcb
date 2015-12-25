//
//  SendCarList.m
//  tcb
//
//  Created by Jax on 15/11/19.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "SendCarList.h"

@implementation SendCarList


+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [List class]};
}
@end


@implementation List

+ (NSDictionary *)objectClassInArray{
    return @{@"item" : [Item class]};
}

@end


@implementation Item

@end


