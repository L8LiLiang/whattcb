//
//  FeeConfirmModel.m
//  tcb
//
//  Created by Jax on 15/11/27.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "FeeConfirmModel.h"

@implementation FeeConfirmModel


@end

@implementation FeeConfirmData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [FeeConfirmList class]};
}

@end


@implementation FeeConfirmList

+ (NSDictionary *)objectClassInArray{
    return @{@"item" : [FeeConfirmItem class]};
}

@end


@implementation FeeConfirmItem

@end


