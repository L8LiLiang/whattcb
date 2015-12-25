//
//  FleetMsgDetailModel.h
//  tcb
//
//  Created by Jax on 15/12/11.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FleetMsgDetail;

@interface FleetMsgDetailModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger ret;

@property (nonatomic, strong) FleetMsgDetail *data;

@end


@interface FleetMsgDetail : NSObject

@property (nonatomic, copy) NSString *Time;

@property (nonatomic, copy) NSString *Title;

@property (nonatomic, copy) NSString *Content;

@property (nonatomic, assign) NSInteger Id;

@end

