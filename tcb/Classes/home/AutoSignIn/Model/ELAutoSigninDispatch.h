//
//  ELAutoSigninDispatch.h
//  tcb
//
//  Created by Chuanxun on 15/12/10.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ELAutoSigninDispatchNode : NSObject

@property (copy, nonatomic) NSString *NodeCode;
@property (assign, nonatomic) BOOL IsMandatory;
@property (copy, nonatomic) NSString *SignTime;
@property (copy, nonatomic) NSString *Region;
@property (copy, nonatomic) NSString *Action;
@property (assign, nonatomic) NSInteger ActionType;
@end


@interface ELAutoSigninDispatch : NSObject

@property (copy, nonatomic) NSString *DispCode;
@property (strong, nonatomic) NSArray<ELAutoSigninDispatchNode *> *NodeList;
@end


@interface ELAutoSigninDispatchList : NSObject

@property (strong, nonatomic) NSMutableArray<ELAutoSigninDispatch *> *dispatchList;

- (instancetype)initWithArray:(NSArray *)array;

@end