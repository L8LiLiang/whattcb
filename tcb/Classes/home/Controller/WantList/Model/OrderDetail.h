//
//  OrderDetail.h
//  tcb
//
//  Created by Jax on 15/11/19.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ItemDetail;


@interface OrderDetail : NSObject

@property (nonatomic, strong) NSArray<ItemDetail *> *item;

@end


@interface ItemDetail : NSObject

@property (nonatomic, copy) NSString *DispatcherMobile;

@property (nonatomic, copy) NSString *ShipVoyage;

@property (nonatomic, copy) NSString *Node3;

@property (nonatomic, assign) NSInteger RecvResult;

@property (nonatomic, copy) NSString *Cubage;

@property (nonatomic, copy) NSString *Node2;

@property (nonatomic, copy) NSString *TeamCode;

@property (nonatomic, copy) NSString *FactoryShortName;

@property (nonatomic, copy) NSString *TeamName;

@property (nonatomic, copy) NSString *Node1;

@property (nonatomic, copy) NSString *DispTime;

@property (nonatomic, copy) NSString *CustomsMode;

@property (nonatomic, copy) NSString *Dispatcher;

@property (nonatomic, copy) NSString *BeginTime;

@property (nonatomic, copy) NSString *BookingNo;

@property (nonatomic, copy) NSString *PieceOrContainerType;

@property (nonatomic, copy) NSString *EndTime;

@property (nonatomic, assign) NSInteger BusinessType;

@property (nonatomic, copy) NSString *Weight;

@property (nonatomic, assign) NSInteger DispatchType;

@property (nonatomic, copy) NSString *FollowRemark;

@property (nonatomic, copy) NSString *Fee;

@end

