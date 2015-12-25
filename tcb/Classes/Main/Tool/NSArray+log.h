//
//  NSArray+log.h
//  NSURLRequest
//
//  Created by 李亮 on 15/6/8.
//  Copyright (c) 2015年 李亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (log)

-(NSString *)descriptionForDebug;

@end

@interface NSDictionary (log)

-(NSString *)descriptionForDebug;

@end