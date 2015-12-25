//
//  FeeDetailModel.m
//  tcb
//
//  Created by Jax on 15/11/27.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "FeeDetailModel.h"

@implementation FeeDetailModel

@end

@implementation FeeDetailData

+ (NSDictionary *)objectClassInArray{
    return @{@"feeList" : [FeeDetailList class], @"feeTypeList" : [FeeDetailTypeList class]};
}

@end


@implementation FeeDetailList

@end


@implementation FeeDetailTypeList

@end


