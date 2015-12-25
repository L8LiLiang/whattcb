//
//  ELInProgressTask.m
//  tcb
//
//  Created by Chuanxun on 15/11/16.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ELInProgressTask.h"


@implementation ELInProgressTaskItem

@end



@implementation ELInProgressTask

+ (NSDictionary *)objectClassInArray{
    return @{@"item" : [ELInProgressTaskItem class]};
}

@end


@implementation AllProgressTask

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [ELInProgressTask class]};
}

@end