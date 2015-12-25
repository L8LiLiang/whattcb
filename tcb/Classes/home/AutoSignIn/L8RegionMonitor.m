//
//  L8RegionMonitor.m
//  L8RegionMonitor
//
//  Created by Chuanxun on 15/12/9.
//  Copyright © 2015年 Chuanxun. All rights reserved.
//

#import "L8RegionMonitor.h"
#import <UIKit/UIKit.h>


//#define RegionMonitorDebug 1



@interface L8RegionMonitor () <CLLocationManagerDelegate>


@property (strong, nonatomic) NSMutableArray *allRegions;
@property (strong, nonatomic) NSMutableArray *regionDistanceFromCurrentLocationArray;
@property (strong, nonatomic) NSMutableArray *previouslyInsideRegionIds;

@property (strong, nonatomic) dispatch_queue_t queueForProcessAllRegions;
@property (strong, nonatomic) dispatch_queue_t queueForProcessPreviouslyInsideRegionIds;

@property (assign, nonatomic) BOOL isUpdatingLocaion;

@end

@implementation L8RegionMonitor


static NSString * const L8PreviouslyInsideRegionKey = @"L8PreviouslyInsideRegionKey";


+(instancetype)sharedMonitor
{
    static L8RegionMonitor *monitor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!monitor) {
            monitor = [[L8RegionMonitor alloc] init];
        }
    });
    
    return monitor;
}

-(instancetype)init
{
    if (self = [super init]) {
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        self.isUpdatingLocaion = NO;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *previouslyInsideRegionIds = [defaults arrayForKey:L8PreviouslyInsideRegionKey];
        if (previouslyInsideRegionIds == nil) {
            self.previouslyInsideRegionIds = [NSMutableArray new];
        }else {            
            self.previouslyInsideRegionIds = [previouslyInsideRegionIds mutableCopy];
        }
        
        NSArray *regions = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePathForSavedRegions]];
        if (regions == nil) {
            self.allRegions = [NSMutableArray new];
        }else {
            self.allRegions = [NSMutableArray arrayWithArray:regions];
        }
        
        self.queueForProcessAllRegions = dispatch_queue_create("L8RegionMonitorQueueForProcessAllRegions", DISPATCH_QUEUE_CONCURRENT);
        self.queueForProcessPreviouslyInsideRegionIds = dispatch_queue_create("L8RegionMonitorQueueForProcessPreviouslyInsideRegionIds", DISPATCH_QUEUE_CONCURRENT);

    }
    
    return self;
}


-(void)startMonitor
{
    [self save];
    
    if (self.allRegions.count == 0) {
        [self.locationManager stopMonitoringSignificantLocationChanges];
        return;
    }
    
    if (![CLLocationManager locationServicesEnabled]) {
        if ([self.delegate respondsToSelector:@selector(regionMonitor:failedWithError:)]) {
            [self.delegate regionMonitor:self failedWithError:@"请先开启设备的定位功能"];
        }
        return;
    }
    
    if (![CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        if ([self.delegate respondsToSelector:@selector(regionMonitor:failedWithError:)]) {
            [self.delegate regionMonitor:self failedWithError:@"您的设备不支持区域监控"];
        }
        return;
    }
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
            return;
        }        
    }
    
    
    [self.locationManager stopUpdatingLocation];
    self.isUpdatingLocaion = YES;
    [self.locationManager startUpdatingLocation];
    [self.locationManager stopMonitoringSignificantLocationChanges];
    [self.locationManager startMonitoringSignificantLocationChanges];
}


- (void)monitorRegionsThatNear:(CLLocation *)location
{
    for (CLRegion *region in self.locationManager.monitoredRegions) {
        [self.locationManager stopMonitoringForRegion:region];
    }
    
    dispatch_async(self.queueForProcessAllRegions, ^{
        if (self.allRegions.count > 20) {
            //    if (!self.regionDistanceFromCurrentLocationArray) {
            NSMutableArray *regionDistanceFromCurrentLocationArray = [[NSMutableArray alloc] initWithCapacity:self.allRegions.count];
            
            for (CLRegion *region in self.allRegions) {
                if (region.radius < self.locationManager.maximumRegionMonitoringDistance) {
                    CLLocation *regionCenter = [[CLLocation alloc] initWithLatitude:region.center.latitude longitude:region.center.longitude];
                    
                    CLLocationDistance distance = [location distanceFromLocation:regionCenter] - region.radius;
                    [regionDistanceFromCurrentLocationArray addObject:@[region,@(fabs(distance))]];
                    if (distance <= 0) {
                        
                        dispatch_async(self.queueForProcessPreviouslyInsideRegionIds, ^{
                            if (![self.previouslyInsideRegionIds containsObject:region.identifier]) {
                                [self.previouslyInsideRegionIds addObject:region.identifier];
                                if ([self.delegate respondsToSelector:@selector(regionMonitor:enterRegion:)]) {
                                    [self.delegate regionMonitor:self enterRegion:region];
                                }
                            }
                        });
 
                    }
                }else {
                    if ([self.delegate respondsToSelector:@selector(regionMonitor:monitorFailedForRegion:withError:)]) {
                        [self.delegate regionMonitor:self monitorFailedForRegion:region withError:@"半径过大"];
                    }
                }
            }
            
            [regionDistanceFromCurrentLocationArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [[obj1 lastObject] compare:[obj2 lastObject]];
            }];
            
            self.regionDistanceFromCurrentLocationArray = regionDistanceFromCurrentLocationArray;
            //    }
            
            
            unsigned long maxMonitorCount = MIN(20, self.regionDistanceFromCurrentLocationArray.count);
            
            for (int i = 0; i < maxMonitorCount; i++) {
                CLRegion *region = [self.regionDistanceFromCurrentLocationArray[i] firstObject];
                [self.locationManager startMonitoringForRegion:region];
            }
        }else {
            for (CLRegion *region in self.allRegions) {
                [self.locationManager startMonitoringForRegion:region];
            }
        }

    });
}

-(void)clearRegionsAndStopMonitor

{
    dispatch_barrier_async(self.queueForProcessAllRegions, ^{
        [self.allRegions removeAllObjects];
    });
    dispatch_barrier_async(self.queueForProcessPreviouslyInsideRegionIds, ^{
        
        [self.previouslyInsideRegionIds removeAllObjects];
    });
    
    [self stopMonitor];

}

-(void)stopMonitor
{
    [self save];
    
    [self.locationManager stopMonitoringSignificantLocationChanges];
    for (CLRegion *region in self.locationManager.monitoredRegions) {
        [self.locationManager stopMonitoringForRegion:region];
    }
}

-(void)reloadRegionsAndRestart
{
    [self startMonitor];
}

#pragma mark -  增删regioins

- (NSString *)filePathForSavedRegions
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [path stringByAppendingPathComponent:@"l8_monitor_regions"];
}

- (void)save
{
    dispatch_barrier_async(self.queueForProcessAllRegions, ^{
        NSString *path = [self filePathForSavedRegions];
        NSData *regionData = [NSKeyedArchiver archivedDataWithRootObject:self.allRegions];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path]) {
            [fileManager createFileAtPath:path contents:regionData attributes:nil];
        }else {
            [regionData writeToFile:path atomically:YES];
        }
    });

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    dispatch_barrier_async(self.queueForProcessPreviouslyInsideRegionIds, ^{
        [defaults setObject:self.previouslyInsideRegionIds forKey:L8PreviouslyInsideRegionKey];
    });
    
}

-(void)addRegion:(CLRegion *)region
{
    dispatch_barrier_async(self.queueForProcessAllRegions, ^{
        if ([self.allRegions containsObject:region])
        {
            [self.allRegions removeObject:region];
            [self.allRegions addObject:region];
            
        }else {
            
            [self.allRegions addObject:region];
        }
    });
}


-(void)removeRegion:(CLRegion *)region
{
    dispatch_barrier_async(self.queueForProcessAllRegions, ^{
        if ([self.allRegions containsObject:region]) {
            
            [self.allRegions removeObject:region];
            [self.locationManager stopMonitoringForRegion:region];
            if (self.allRegions.count == 0) {
                [self stopMonitor];
            }
        }
    });
}

-(void)removeRegionUseIdentifier:(NSString *)identifier
{
    dispatch_barrier_async(self.queueForProcessAllRegions, ^{
        for (CLRegion *region in self.allRegions) {
            if ([region.identifier isEqualToString:identifier]) {
                [self.allRegions removeObject:region];
                [self.locationManager stopMonitoringForRegion:region];
                return;
            }
        }
    });
}

-(void)addRegions:(NSArray *)regions
{
    dispatch_barrier_async(self.queueForProcessAllRegions, ^{
        for (CLRegion *region in regions) {
            if ([self.allRegions containsObject:region])
            {
                [self.allRegions removeObject:region];
                [self.allRegions addObject:region];
                
            }else {
                
                [self.allRegions addObject:region];
            }
        }
    });
}


-(void)removeRegions:(NSArray *)regions
{

    dispatch_barrier_async(self.queueForProcessAllRegions, ^{
        for (CLRegion *region in regions) {
            [self.locationManager stopMonitoringForRegion:region];
        }
        [self.allRegions removeObjectsInArray:regions];
        if (self.allRegions.count == 0) {
            [self stopMonitor];
        }
    });
}



#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [self startMonitor];
    }else if(status == kCLAuthorizationStatusRestricted) {
        if ([self.delegate respondsToSelector:@selector(regionMonitor:failedWithError:)]) {
            [self.delegate regionMonitor:self failedWithError:@"您的设备不支持定位功能"];
        }
    }else if(status == kCLAuthorizationStatusDenied) {
        if ([self.delegate respondsToSelector:@selector(regionMonitor:failedWithError:)]) {
            [self.delegate regionMonitor:self failedWithError:@"您的设备不支持定位功能"];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
//    //1.创建本地通知
//    UILocalNotification *local = [[UILocalNotification alloc]init];
//    
//    local.alertBody = @"didUpdateLocations";
//    
//    local.soundName = @"UILocalNotificationDefaultSoundName";
//    
//    local.alertLaunchImage = @"ic_sound";
//    
//    local.hasAction = YES;
//    
//    local.alertAction = @"显示tongzhi";
//    
//    local.userInfo = @{@"name" : @"李亮" , @"QQ":@"222",@"info":@"信息!"};
//
//    [[UIApplication sharedApplication]presentLocalNotificationNow:local];
    

    CLLocation *location = locations.firstObject;
    TCBLog(@"updateLocation:%f,%f",location.coordinate.latitude,location.coordinate.longitude);
    if (self.isUpdatingLocaion) {
        [self.locationManager stopUpdatingLocation];
        self.isUpdatingLocaion = NO;
    }
    
    [self monitorRegionsThatNear:locations.firstObject];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    dispatch_barrier_async(self.queueForProcessPreviouslyInsideRegionIds, ^{

        if (![self.previouslyInsideRegionIds containsObject:region.identifier]) {
                [self.previouslyInsideRegionIds addObject:region.identifier];
            
            if ([self.delegate respondsToSelector:@selector(regionMonitor:enterRegion:)]) {
                [self.delegate regionMonitor:self enterRegion:region];
            }
        }
    });

}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    dispatch_barrier_async(self.queueForProcessPreviouslyInsideRegionIds, ^{

        if ([self.previouslyInsideRegionIds containsObject:region.identifier]) {
                [self.previouslyInsideRegionIds removeObject:region.identifier];
        }
        
        if ([self.delegate respondsToSelector:@selector(regionMonitor:exitRegion:)]) {
            [self.delegate regionMonitor:self exitRegion:region];
        }
    });

}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(regionMonitor:monitorFailedForRegion:withError:)]) {
        [self.delegate regionMonitor:self monitorFailedForRegion:region withError:[NSString stringWithFormat:@"%@",error]];
    }
}

@end
