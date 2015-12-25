//
//  LoginData.h
//  tcb
//
//  Created by Jax on 15/11/23.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@class data;
@interface LoginData : NSObject


@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger ret;

@property (nonatomic, strong) data *data;


@end
@interface data : NSObject

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *nick;

@property (nonatomic, assign) NSInteger role;

@end

