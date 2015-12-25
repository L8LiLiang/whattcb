//
//  GasStationInfoModel.h
//  tcb
//
//  Created by Jax on 15/12/14.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GasStationInfo;

@interface GasStationInfoModel : NSObject

@property (nonatomic, strong) NSArray<GasStationInfo *> *list;

@end

@interface GasStationInfo: NSObject

@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Addr;
@property (nonatomic, copy) NSString *Tel;
@property (nonatomic, assign) double Lng;
@property (nonatomic, assign) double Lat;
@property (nonatomic, assign) double distance;

@end