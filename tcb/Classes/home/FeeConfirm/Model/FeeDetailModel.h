//
//  FeeDetailModel.h
//  tcb
//
//  Created by Jax on 15/11/27.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FeeDetailData,FeeDetailList,FeeDetailTypeList;

@interface FeeDetailModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger ret;

@property (nonatomic, strong) FeeDetailData *data;

@end


@interface FeeDetailData : NSObject

@property (nonatomic, strong) NSArray<FeeDetailList *> *feeList;

@property (nonatomic, strong) NSArray<FeeDetailTypeList *> *feeTypeList;

@property (nonatomic, assign) NSInteger feeState;

@property (nonatomic, copy) NSString *otherFeeName;

@end


@interface FeeDetailList : NSObject

@property (nonatomic, copy) NSString *ImageUrl;

@property (nonatomic, copy) NSString *FeeName;

@property (nonatomic, copy) NSString *Money;

@property (nonatomic, copy) NSString *SmallImageUrl;

@property (nonatomic, copy) NSString *WriteoffMoney;

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, assign) NSInteger IsReadOnly;

@end


@interface FeeDetailTypeList : NSObject

@property (nonatomic, assign) NSInteger FeeId;

@property (nonatomic, copy) NSString *FeeName;

@end

