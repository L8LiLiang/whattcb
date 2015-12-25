//
//  ELInProgressTask.h
//  tcb
//
//  Created by Chuanxun on 15/11/16.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,ELEntryStatus) {
    KENTRY_STATUS_CHUQING = 0,
};

typedef NS_ENUM(NSInteger,ELTaskStatus) {
    KTASK_STATUS_YITIXIANG = 0,
    KTASK_STATUS_YIDAOCHANG = 1,
};


@interface ELInProgressTask : NSObject

@property (strong, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *boxModel;
@property (assign, nonatomic) ELEntryStatus entryStatus;
@property (assign, nonatomic) ELTaskStatus taskStatus;
@property (copy, nonatomic) NSString *from;
@property (copy, nonatomic) NSString *to;
@property (copy, nonatomic) NSString *fleetName;
@property (copy, nonatomic) NSString *contactPersonName;
@property (assign, nonatomic) CGFloat price;
@property (copy, nonatomic) NSString *telephone;
@property (assign, nonatomic) BOOL doubleBox;

- (NSString *)stringFromELEntryStatus;
- (NSString *)stringFromELTaskStatus;


@end
