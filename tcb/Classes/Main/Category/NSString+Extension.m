//
//  NSString+Extension.m
//  tcb
//
//  Created by Jax on 15/11/13.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize
{
    // 传入一个字体（大小号）保存到字典
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = font;
    // maxSize定义他的最大尺寸   当实际比定义的小会返回实际的尺寸，如果实际比定义的大会返回定义的尺寸超出的会剪掉，所以一般要设一个无限大 MAXFLOAT
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttrs context:nil].size;
}

-(BOOL)isTelephoneNum
{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

+ (CGFloat)cgFloatMoneyFromstringMoney:(NSString *)stringMoney {
    NSMutableString *moneyString = [stringMoney mutableCopy];
    unichar myChar = ',';
    for (int i = 0; i < moneyString.length; i ++) {
        if ([moneyString characterAtIndex:i] == [[NSNumber numberWithChar:myChar] intValue]) {
            [moneyString deleteCharactersInRange:NSMakeRange(i, 1)];
        }
    }
    CGFloat cgFloatMoney = moneyString.floatValue;
    return cgFloatMoney;
}


@end
