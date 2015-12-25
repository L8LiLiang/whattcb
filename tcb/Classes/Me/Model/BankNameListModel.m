//
//  BankNameListModel.m
//  tcb
//
//  Created by Jax on 15/12/7.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "BankNameListModel.h"

@implementation BankNameListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [BankInfo class]};
}

@end


@implementation BankInfo

@end


