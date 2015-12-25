//
//  FeeConfirmModel.h
//  tcb
//
//  Created by Jax on 15/11/27.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeeConfirmData,FeeConfirmList,FeeConfirmItem;

@interface FeeConfirmModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger ret;

@property (nonatomic, strong) FeeConfirmData *data;

@end


@interface FeeConfirmData : NSObject

@property (nonatomic, strong) NSArray<FeeConfirmList *> *list;

@end

@interface FeeConfirmList : NSObject

@property (nonatomic, strong) NSArray<FeeConfirmItem *> *item;

@end



@interface FeeConfirmItem : NSObject

@property (nonatomic, copy) NSString *FeeStatus;

@property (nonatomic, copy) NSString *ContainerType;

@property (nonatomic, copy) NSString *Fee;

@property (nonatomic, copy) NSString *AppointDate;

@property (nonatomic, copy) NSString *DispatcherMobile;

@property (nonatomic, copy) NSString *Address;

@property (nonatomic, copy) NSString *TeamName;

@property (nonatomic, copy) NSString *Dispatcher;

@property (nonatomic, copy) NSString *CustomsMode;

@property (nonatomic, copy) NSString *DispCode;

@end

