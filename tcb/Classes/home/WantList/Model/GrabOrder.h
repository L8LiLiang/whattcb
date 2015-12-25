//
//  GrabOrder.h
//  tcb
//
//  Created by Jax on 15/11/20.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GrabList,GrabItem;

@interface GrabOrder : NSObject

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray<GrabList *> *list;

@end


@interface GrabList : NSObject

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, strong) NSArray<GrabItem *> *items;

@end


@interface GrabItem : NSObject

@property (nonatomic, assign) NSInteger DispatchType;

@property (nonatomic, copy) NSString *ContainerType;

@property (nonatomic, assign) NSInteger TotalCosts;

@property (nonatomic, copy) NSString *GrabCode;

@property (nonatomic, copy) NSString *LineName;

@property (nonatomic, copy) NSString *DispatchId;

@property (nonatomic, copy) NSString *MemberId;

@property (nonatomic, copy) NSString *Address;

@property (nonatomic, copy) NSString *AppointDate;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *FollowRemark;

@property (nonatomic, assign) NSInteger GrabStatus;

@end

