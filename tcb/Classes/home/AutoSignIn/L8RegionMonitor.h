//
//  L8RegionMonitor.h
//  L8RegionMonitor
//
//  Created by Chuanxun on 15/12/9.
//  Copyright © 2015年 Chuanxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class L8RegionMonitor;


@protocol L8RegionMonitorDelegate <NSObject>

- (void)regionMonitor:(L8RegionMonitor *)regionMonitor enterRegion:(CLRegion *)region;
- (void)regionMonitor:(L8RegionMonitor *)regionMonitor exitRegion:(CLRegion *)region;
- (void)regionMonitor:(L8RegionMonitor *)regionMonitor failedWithError:(NSString *)errorMsg;
- (void)regionMonitor:(L8RegionMonitor *)regionMonitor monitorFailedForRegion:(CLRegion *)region withError:(NSString *)errorMsg;

@end



@protocol L8RegionMonitorDataSource <NSObject>

- (NSArray *)allRegions:(L8RegionMonitor *)regionMonitor;

@end


@interface L8RegionMonitor : NSObject
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) id<L8RegionMonitorDelegate> delegate;

+ (instancetype)sharedMonitor;

//开始监控
- (void)startMonitor;

//停止监控所有regions，不清除regions，下次调用sharedMonitor会继续添加保存到磁盘的regioins
-(void)stopMonitor;

//清除所有regions（包括内存和磁盘中的）并且停止监控
-(void)clearRegionsAndStopMonitor;

//当增 删region之后，需要调用此方法，重新开始监控
- (void)reloadRegionsAndRestart;

//增 删region
- (void)addRegions:(NSArray *)regions;
- (void)removeRegions:(NSArray *)regions;
- (void)addRegion:(CLRegion *)region;
- (void)removeRegion:(CLRegion *)region;
- (void)removeRegionUseIdentifier:(NSString *)identifier;

@end
