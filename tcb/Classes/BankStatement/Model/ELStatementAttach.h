//
//  ELStatementAttach.h
//  tcb
//
//  Created by Chuanxun on 15/12/7.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELStatementAttach : NSObject


@property (copy, nonatomic) NSString *FeeName;
@property (copy, nonatomic) NSString *TruckNo;
@property (copy, nonatomic) NSString *Money;
@property (copy, nonatomic) NSString *OperateTime;


@end


@interface ELStatementAttachList : NSObject

@property (copy, nonatomic) NSString *totalCost;
@property (strong, nonatomic) NSArray<ELStatementAttach *> *list;

@end