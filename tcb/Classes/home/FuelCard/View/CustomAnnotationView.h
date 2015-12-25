//
//  CustomAnnotationView.h
//  tcb
//
//  Created by Jax on 15/12/16.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "GasStationAnnotation.h"

@interface CustomAnnotationView : MKAnnotationView

@property (nonatomic, strong) GasStationAnnotation *customAnnotation;

@end
