//
//  ELMonthReconciliationList.m
//  :
//
//  Created by Chuanxun on 15/12/3.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ELMonthReconciliationList.h"


@implementation ELMonthReconciliation

// 1 不管  4已退返  --不管            2待对账   3已对账(未付款)   11已付款   13已完成

-(NSString *)checkStatusString
{
    NSString *str;
    switch (self.statementStatus) {
        case CheckStatus_noCheck:
            str = @"待对账";
            break;
        case CheckStatus_checked:
            str = @"已对账";
            break;
        case CheckStatus_payed:
            str = @"已付款";
            break;
        case CheckStatus_finished:
            str = @"已完成";
            break;
        default:
            str = @"未知";
            break;
    }
    
    return str;
}

@end


@implementation ELMonthReconciliationList


+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [ELMonthReconciliation class]};
}


@end
