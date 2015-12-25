//
//  ELMonthReconciliationList.h
//  tcb
//
//  Created by Chuanxun on 15/12/3.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,CheckStatus) {
    CheckStatus_noCheck = 2,
    CheckStatus_checked = 3,
    CheckStatus_payed = 11,
    CheckStatus_finished = 13,
};

@interface ELMonthReconciliation : NSObject

@property (copy, nonatomic) NSString *CheckNo;
@property (copy, nonatomic) NSString *Name;
@property (copy, nonatomic) NSString *statementName;
@property (assign, nonatomic) NSUInteger Num;
@property (copy, nonatomic) NSString *TotalMoney;
// 1 不管  4已退返  --不管            2待对账   3已对账(未付款)   11已付款   13已完成
@property (assign, nonatomic) CheckStatus statementStatus;
@property (copy, nonatomic) NSString *Tel;

- (NSString *)checkStatusString;

@end



@interface ELMonthReconciliationList : NSObject
@property (assign, nonatomic) NSUInteger totalCount;
@property (strong, nonatomic) NSArray<ELMonthReconciliation *> *list;

@end
