//
//  SystemMsgModel.h
//  tcb
//
//  Created by Jax on 15/12/11.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SystemMsgData,SystemMsg;

@interface SystemMsgModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger ret;

@property (nonatomic, strong) SystemMsgData *data;

@end


@interface SystemMsgData : NSObject

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger rnum;

@property (nonatomic, strong) NSArray<SystemMsg *> *list;

@end



@interface SystemMsg : NSObject

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, copy) NSString *Time;

@property (nonatomic, copy) NSString *Title;

@property (nonatomic, assign) NSInteger IsRead;

@property (nonatomic, copy) NSString *Company;

@end

