//
//  ELInProgressTask.h
//  tcb
//
//  Created by Chuanxun on 15/11/16.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ELInProgressTaskItem : NSObject

@property (copy, nonatomic) NSString *AppointDate;
@property (copy, nonatomic) NSString *ContainerType;
@property (copy, nonatomic) NSString *CustomsMode;
@property (copy, nonatomic) NSString *Address;
@property (copy, nonatomic) NSString *TeamName;
@property (copy, nonatomic) NSString *Dispatcher;
@property (copy, nonatomic) NSString *NodeStatus;
@property (copy, nonatomic) NSString *Fee;
@property (copy, nonatomic) NSString *DispatcherMobile;
@property (copy, nonatomic) NSString *DispCode;


@end


@interface ELInProgressTask : NSObject


@property (strong, nonatomic) NSArray<ELInProgressTaskItem *> *item;

@end



@interface AllProgressTask : NSObject

@property (strong, nonatomic) NSArray<ELInProgressTask *> *list;

@end