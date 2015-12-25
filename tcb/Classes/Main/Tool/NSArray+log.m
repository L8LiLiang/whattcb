//
//  NSArray+log.m
//  NSURLRequest
//
//  Created by 李亮 on 15/6/8.
//  Copyright (c) 2015年 李亮. All rights reserved.
//

#import "NSArray+log.h"

@implementation NSArray (log)

-(NSString *)descriptionForDebug
{
    NSMutableString *des = [[NSMutableString alloc] init];
    
    [des appendString:@"(\n\t"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [des appendFormat:@"%@,\n\t",obj];
    }];
    
    NSRange range = [des rangeOfString:@",\n\t"];
    
    if (range.location != NSNotFound) {
        [des deleteCharactersInRange:[des rangeOfString:@",\n\t" options:NSBackwardsSearch]];
    }
    [des appendString:@"\n)"];
    
    return des.copy;
}

-(NSString *)description
{
    NSMutableString *des = [[NSMutableString alloc] init];
    
    [des appendString:@"(\n\t"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [des appendFormat:@"%@,\n\t",obj];
    }];
    
    NSRange range = [des rangeOfString:@",\n\t"];
    
    if (range.location != NSNotFound) {
        
        [des deleteCharactersInRange:[des rangeOfString:@",\n\t" options:NSBackwardsSearch]];
    }
    
    [des appendString:@"\n)"];
    
    return des.copy;
}

//此方法优先
-(NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *des = [[NSMutableString alloc] init];
    
    [des appendString:@"(\n\t"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [des appendFormat:@"%@,\n\t",obj];
    }];
    
    NSRange range = [des rangeOfString:@",\n\t"];
    
    if (range.location != NSNotFound) {
        
        [des deleteCharactersInRange:[des rangeOfString:@",\n\t" options:NSBackwardsSearch]];
    }
    
    [des appendString:@"\n)"];
    
    return des.copy;
}

@end

@implementation NSDictionary (log)

-(NSString *)descriptionForDebug
{
    NSMutableString *des = [[NSMutableString alloc] init];
    
    [des appendString:@"{\n\t"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [des appendFormat:@"%@:%@,\n\t",key,obj];
    }];
    
    NSRange range = [des rangeOfString:@",\n\t"];
    
    if (range.location != NSNotFound) {
        [des deleteCharactersInRange:[des rangeOfString:@",\n\t" options:NSBackwardsSearch]];
    }
    [des appendString:@"\n}"];
    
    return des.copy;
}

-(NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *des = [[NSMutableString alloc] init];
    
    [des appendString:@"{\n\t"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [des appendFormat:@"%@:%@,\n\t",key,obj];
    }];
    
    NSRange range = [des rangeOfString:@",\n\t"];
    
    if (range.location != NSNotFound) {
        [des deleteCharactersInRange:[des rangeOfString:@",\n\t" options:NSBackwardsSearch]];
    }
    [des appendString:@"\n}"];
    
    return des.copy;
}


@end
