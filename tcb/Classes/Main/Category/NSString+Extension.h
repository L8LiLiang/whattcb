//
//  NSString+Extension.h
//  tcb
//
//  Created by Jax on 15/11/13.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize;

- (BOOL)isTelephoneNum;

/* 2,000.00 -> 2000.00 */
+ (CGFloat)cgFloatMoneyFromstringMoney:(NSString *)stringMoney;

@end
