//
//  NSAttributedString+Emoji.h
//  tcb
//
//  Created by 李亮 on 15/11/22.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EMOJI_REGULAR_PERFIX @"EMOJE_IMAGE_"

@interface NSAttributedString (Emoji)

+ (NSAttributedString *)emojiStringWithMutableAttributedString:(NSMutableAttributedString *)emojiString;

+ (NSMutableAttributedString *)emojiStringWithString:(NSString *)emojiString;

+ (NSMutableAttributedString *)emojiStringWithString:(NSString *)emojiString withFont:(UIFont *)font andColor:(UIColor *)color;
@end
