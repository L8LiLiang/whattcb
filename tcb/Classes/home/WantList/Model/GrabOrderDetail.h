//
//  GrabOrderDetail.h
//  tcb
//
//  Created by Jax on 15/11/20.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GrabOrderItem;
@interface GrabOrderDetail : NSObject

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, assign) NSInteger grabPrice;

@property (nonatomic, strong) NSString *grabCode;

@property (nonatomic, strong) NSArray<GrabOrderItem *> *items;

@end


@interface GrabOrderItem : NSObject

@property (nonatomic, copy) NSString *TruckTelephone;

@property (nonatomic, copy) NSString *ContainerType;

@property (nonatomic, copy) NSString *ContainerNumber;

@property (nonatomic, copy) NSString *Voyage;

@property (nonatomic, assign) NSInteger GrabStatus;

@property (nonatomic, copy) NSString *FactoryAddress;

@property (nonatomic, copy) NSString *AppointDate;

@property (nonatomic, copy) NSString *Size;

@property (nonatomic, copy) NSString *GrabDatetime;

@property (nonatomic, assign) NSInteger ServiceType;

@property (nonatomic, copy) NSString *VesselName;

@property (nonatomic, copy) NSString *DeliveryYard;

@property (nonatomic, copy) NSString *Piece;

@property (nonatomic, copy) NSString *FollowRemark;

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *GrabNo;

@property (nonatomic, copy) NSString *ShipCompany;

@property (nonatomic, copy) NSString *ReturnYard;

@property (nonatomic, assign) NSInteger DriverNum;

@property (nonatomic, copy) NSString *ETC;

@property (nonatomic, assign) NSInteger DispatchType;

@property (nonatomic, copy) NSString *Weight;

@property (nonatomic, copy) NSString *LineName;

@property (nonatomic, copy) NSString *NameOfPoduct;

@property (nonatomic, copy) NSString *BLNo;

@property (nonatomic, copy) NSString *Address;

@property (nonatomic, copy) NSString *GetConPlace;

@property (nonatomic, copy) NSString *ReturnConPlace;

@end

