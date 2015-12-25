//
//  FleetMessageModel.h
//  tcb
//
//  Created by Jax on 15/12/11.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FleetMessageList,FleetMessage;
@interface FleetMessageModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger ret;

@property (nonatomic, strong) FleetMessageList *data;

@end
@interface FleetMessageList : NSObject

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger rnum;

@property (nonatomic, strong) NSArray<FleetMessage *> *list;

@end

@interface FleetMessage : NSObject

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, copy) NSString *Time;

@property (nonatomic, copy) NSString *Title;

@property (nonatomic, assign) NSInteger IsRead;

@property (nonatomic, copy) NSString *Company;

@end

