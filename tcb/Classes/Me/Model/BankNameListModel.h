//
//  BankNameListModel.h
//  tcb
//
//  Created by Jax on 15/12/7.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BankInfo;


@interface BankNameListModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger ret;

@property (nonatomic, strong) NSArray<BankInfo *> *data;

@end


@interface BankInfo : NSObject

@property (nonatomic, copy) NSString *BankName;

@property (nonatomic, copy) NSString *BankCode;

@end

