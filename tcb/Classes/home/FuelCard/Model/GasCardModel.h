//
//  GasCardModel.h
//  tcb
//
//  Created by Jax on 15/12/15.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GasCardData,GasCardInfo;


@interface GasCardModel : NSObject

@property (nonatomic, assign) NSInteger ret;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) GasCardData *data;

@end



@interface GasCardData : NSObject

@property (nonatomic, strong) NSArray<GasCardInfo *> *list;

@end




@interface GasCardInfo : NSObject

@property (nonatomic, copy) NSString *TeamId;

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *FuelCard;

@property (nonatomic, assign) double Balance;

@property (nonatomic, copy) NSString *Team;

@property (nonatomic, copy) NSString *InvalidMoney;

@property (nonatomic, copy) NSString *CarNo;

@property (nonatomic, copy) NSString *FuelCardNo;

@end

