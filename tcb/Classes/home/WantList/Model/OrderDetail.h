//
//  OrderDetail.h
//  tcb
//
//  Created by Jax on 15/11/19.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderItem, Nodelist;

@interface OrderDetail : NSObject

@property (nonatomic, strong) NSArray<OrderItem *> *item;

@end



@interface OrderItem : NSObject

@property (nonatomic, copy) NSString *TeamName;

@property (nonatomic, copy) NSString *ContainerType;

@property (nonatomic, copy) NSString *FactoryShortName;

@property (nonatomic, copy) NSString *BeginTime;

@property (nonatomic, copy) NSString *Weight;

@property (nonatomic, copy) NSString *Fee;

@property (nonatomic, copy) NSString *DispatcherMobile;

@property (nonatomic, copy) NSString *DispTime;

@property (nonatomic, assign) NSInteger BusinessType;

@property (nonatomic, strong) NSArray<Nodelist *> *NodeList;

@property (nonatomic, copy) NSString *Dispatcher;

@property (nonatomic, copy) NSString *Cubage;

@property (nonatomic, copy) NSString *Piece;

@property (nonatomic, copy) NSString *BillNo;

@property (nonatomic, copy) NSString *FollowRemark;

@property (nonatomic, copy) NSString *EndTime;

@property (nonatomic, assign) NSInteger DispatchType;

@property (nonatomic, copy) NSString *ShipVoyage;

@property (nonatomic, copy) NSString *CustomsMode;

@end

@interface Nodelist : NSObject

@property (nonatomic, copy) NSString *NodeName;

@property (nonatomic, copy) NSString *Address;

@property (nonatomic, copy) NSString *Display;

@property (nonatomic, copy) NSString *NodeType;

@end

