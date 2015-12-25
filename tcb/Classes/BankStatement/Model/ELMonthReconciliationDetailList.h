//
//  ELMonthReconciliationDetailList.h
//  tcb
//
//  Created by Chuanxun on 15/12/4.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELMonthReconciliationDetail : NSObject

@property (copy, nonatomic) NSString *DispCode;
@property (copy, nonatomic) NSString *BusiId;
@property (copy, nonatomic) NSString *AppointDate;
@property (copy, nonatomic) NSString *ContainerNo;
@property (copy, nonatomic) NSString *DispatchType;
@property (copy, nonatomic) NSString *Address;
@property (copy, nonatomic) NSString *FromName;
@property (copy, nonatomic) NSString *Cost;

@end


@interface ELMonthReconciliationDetailList : NSObject

@property (copy, nonatomic) NSString *totalCount;
@property (copy, nonatomic) NSString *checkNo;
@property (copy, nonatomic) NSString *statementName;
@property (copy, nonatomic) NSString *totalCost;
@property (copy, nonatomic) NSString *writeOffTotalCost;
@property (copy, nonatomic) NSString *cost;
@property (copy, nonatomic) NSArray<ELMonthReconciliationDetail *> *list;

@end
