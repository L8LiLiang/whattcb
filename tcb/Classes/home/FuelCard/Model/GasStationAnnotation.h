//
//  GasStationAnnotation.h
//  tcb
//
//  Created by Jax on 15/12/14.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@interface GasStationAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, assign) NSInteger tag;

@end
