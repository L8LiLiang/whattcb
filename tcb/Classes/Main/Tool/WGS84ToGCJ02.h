//
//  WGS84ToGCJ02.h
//  tcb
//
//  Created by Jax on 15/12/16.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface WGS84ToGCJ02 : MKAnnotationView

//  判断是否已经超出中国范围
+ (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
//  转GCJ-02
+ (CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

@end
