//
//  MyInfoResultModel.h
//  tcb
//
//  Created by Jax on 15/12/2.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyInfoData;
@interface MyInfoResultModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger ret;

@property (nonatomic, strong) MyInfoData *data;

@end
@interface MyInfoData : NSObject

@property (nonatomic, copy) NSString *Record;

@property (nonatomic, copy) NSString *TruckNo;

@property (nonatomic, assign) NSInteger GPSId;

@property (nonatomic, copy) NSString *HeadUrl;

@property (nonatomic, copy) NSString *UserName;

@property (nonatomic, assign) NSInteger Horsepower;

@property (nonatomic, copy) NSString *DriverBookNo;

@end

