//
//  SendCarList.h
//  tcb
//
//  Created by Jax on 15/11/19.
//  Copyright © 2015年 Jax. All rights reserved.
//  派车单模型

#import <Foundation/Foundation.h>

@class List,Item;
@interface SendCarList : NSObject


@property (nonatomic, assign) NSInteger grabOrderCount;

@property (nonatomic, strong) NSArray<List *> *list;


@end


@interface List : NSObject

@property (nonatomic, strong) NSArray<Item *> *item;

@end

@interface Item : NSObject

@property (nonatomic, copy) NSString *ContainerType;

@property (nonatomic, copy) NSString *Fee;

@property (nonatomic, copy) NSString *AppointDate;

@property (nonatomic, copy) NSString *TeamName;

@property (nonatomic, copy) NSString *Address;

@property (nonatomic, copy) NSString *DispatcherMobile;

@property (nonatomic, copy) NSString *Dispatcher;

@property (nonatomic, copy) NSString *NodeStatus;

@property (nonatomic, copy) NSString *CustomsMode;

@property (nonatomic, copy) NSString *DispCode;

@end

