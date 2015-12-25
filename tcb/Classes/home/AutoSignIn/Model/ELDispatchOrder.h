//
//  ELDispatchOrder.h
//  tcb
//
//  Created by Chuanxun on 15/11/27.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ELDispatchOrderItemNode : NSObject

@property (copy, nonatomic) NSString *NodeCode;
@property (copy, nonatomic) NSString *NodeName;
@property (assign, nonatomic) BOOL IsMandatory;
@property (copy, nonatomic) NSString *Address;
@property (copy, nonatomic) NSString *Telephone;
@property (copy, nonatomic) NSString *SignTime;
@property (copy, nonatomic) NSString *Region;
@property (copy, nonatomic) NSString *Action;
@property (copy, nonatomic) NSString *Display;
@property (assign, nonatomic) NSInteger ActionType;

@end


@interface ELDispatchOrderItem : NSObject

@property (copy, nonatomic) NSString *DispCode;
@property (copy, nonatomic) NSString *ShipVoyage;
@property (copy, nonatomic) NSString *BillNo;
@property (copy, nonatomic) NSString *LineName;
@property (copy, nonatomic) NSString *CustomsMode;
@property (copy, nonatomic) NSString *AppointDate;
@property (copy, nonatomic) NSString *CutoffTime;
@property (copy, nonatomic) NSString *ContainerType;
@property (copy, nonatomic) NSString *Weight;
@property (copy, nonatomic) NSString *Piece;
@property (copy, nonatomic) NSString *Cubage;
@property (copy, nonatomic) NSString *FactoryShortName;
@property (copy, nonatomic) NSString *SealNo;
@property (copy, nonatomic) NSString *ContainerNo;
@property (copy, nonatomic) NSString *FollowRemark;
@property (strong, nonatomic) NSMutableArray *PictureUrl;
@property (strong, nonatomic) NSMutableArray *PictureSmallUrl;
@property (copy, nonatomic) NSString *RecordedFee;
@property (assign, nonatomic) NSInteger BusinessType;
@property (assign, nonatomic) NSInteger DispatchType;
@property (assign, nonatomic) NSString *BusiId;
@property (strong, nonatomic) NSArray<ELDispatchOrderItemNode *> *NodeList;

@end



@interface ELDispatchOrder : NSObject

@property (strong, nonatomic) NSArray<ELDispatchOrderItem *> *item;

@end
