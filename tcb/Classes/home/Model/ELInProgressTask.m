//
//  ELInProgressTask.m
//  tcb
//
//  Created by Chuanxun on 15/11/16.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ELInProgressTask.h"

@implementation ELInProgressTask

-(NSString *)stringFromELEntryStatus
{
    NSString *str;
    switch (self.entryStatus) {
        case KENTRY_STATUS_CHUQING:
            str = NSLocalizedString(@"ChuQing", @"出清");
            break;
            
        default:
            break;
    }
    return str;
}

-(NSString *)stringFromELTaskStatus
{
    NSString *str;
    switch (self.taskStatus) {
        case KTASK_STATUS_YIDAOCHANG:
            str = NSLocalizedString(@"YiDaoChang", @"已到仓");
            break;
        case KTASK_STATUS_YITIXIANG:
            str = NSLocalizedString(@"YiTiXiang", @"已提箱");
        default:
            break;
    }
    return str;
}

@end
