//
//  BankAccountInfoModel.h
//  tcb
//
//  Created by Jax on 15/12/8.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AccountInfoData;

@interface BankAccountInfoModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger ret;

@property (nonatomic, strong) AccountInfoData *data;

@end


@interface AccountInfoData : NSObject

@property (nonatomic, copy) NSString *UserID;

@property (nonatomic, copy) NSString *AccountName;

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, copy) NSString *AccountProvince;

@property (nonatomic, copy) NSString *AccountCity;

@property (nonatomic, copy) NSString *AccountAddress;

@property (nonatomic, copy) NSString *AccountNum;

@property (nonatomic, copy) NSString *BankName;

@property (nonatomic, copy) NSString *BankCode;

@property (nonatomic, copy) NSString *AccountType;

@end

