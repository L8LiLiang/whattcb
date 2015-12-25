//
//  ELAutoSigninDispatch.m
//  tcb
//
//  Created by Chuanxun on 15/12/10.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ELAutoSigninDispatch.h"


@implementation ELAutoSigninDispatchNode



@end



@implementation ELAutoSigninDispatch

+ (NSDictionary *)objectClassInArray{
    return @{@"NodeList" : [ELAutoSigninDispatchNode class]};
}

@end



@implementation ELAutoSigninDispatchList

-(instancetype)initWithArray:(NSArray *)array
{
    if (self = [super init]) {
        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:array.count];
        for (NSDictionary *dict in array) {
            ELAutoSigninDispatch *dispatch = [ELAutoSigninDispatch mj_objectWithKeyValues:dict];
            [tmpArray addObject:dispatch];
        }
        self.dispatchList = tmpArray.mutableCopy;
    }

    
    return self;
}

-(NSMutableArray<ELAutoSigninDispatch *> *)dispatchList
{
    if (!_dispatchList) {
        _dispatchList = [NSMutableArray new];
    }
    return _dispatchList;
}

@end


