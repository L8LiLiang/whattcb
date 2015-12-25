//
//  NSAttributedString+Emoji.m
//  tcb
//
//  Created by 李亮 on 15/11/22.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "NSAttributedString+Emoji.h"


@interface EmojiAttachment : NSTextAttachment

@end

@implementation EmojiAttachment

//I want my emoticon has the same size with line's height
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    return CGRectMake( 0 , -6, lineFrag.size.height*1.2, lineFrag.size.height*1.2);
//    return CGRectMake( 0 , -6, lineFrag.size.height*1.2, lineFrag.size.height*1.2);

}

@end




@implementation NSAttributedString (Emoji)

+ (NSAttributedString *)emojiStringWithMutableAttributedString:(NSMutableAttributedString *)emojiString
{
    NSString *strRegular = [NSString stringWithFormat:@"%@.*\\.png",EMOJI_REGULAR_PERFIX];
    NSRegularExpression *regularEx = [NSRegularExpression regularExpressionWithPattern:strRegular options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *string = emojiString.string;
    NSTextCheckingResult *result = [regularEx firstMatchInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    if (result != nil) {
        NSUInteger perfixLen = [EMOJI_REGULAR_PERFIX length];
        NSString *imageName = [NSString stringWithFormat:@"%@", [string substringWithRange:NSMakeRange(result.range.location + perfixLen, result.range.length - perfixLen)]];
        EmojiAttachment *attachment = [[EmojiAttachment alloc] initWithData:nil ofType:nil];
        attachment.image = [UIImage imageNamed:imageName];
        NSAttributedString *attrString = [NSAttributedString attributedStringWithAttachment:attachment];
        [emojiString replaceCharactersInRange:result.range withAttributedString:attrString];
        // 递归
        [self emojiStringWithMutableAttributedString:emojiString];
    } else {
        return emojiString;
    }
    return emojiString;
}

+ (NSMutableAttributedString *)emojiStringWithString:(NSString *)emojiString
{
    NSString *strRegular = [NSString stringWithFormat:@"%@.*\\.png",EMOJI_REGULAR_PERFIX];
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:strRegular options:0 error:NULL];
    NSArray *allResults = [regular matchesInString:emojiString options:NSMatchingReportCompletion range:NSMakeRange(0, emojiString.length)];
    
    NSMutableAttributedString *finalStr = [[NSMutableAttributedString alloc] init];
    NSRange preRange = NSMakeRange(0, 0);
    NSUInteger perfixLength = [EMOJI_REGULAR_PERFIX length];
    for (NSTextCheckingResult *result in allResults) {
        NSString *imgName = [emojiString substringWithRange:NSMakeRange(result.range.location + perfixLength, result.range.length - perfixLength)];
        UIImage *image = [UIImage imageNamed:imgName];
        
        EmojiAttachment *attachment = [[EmojiAttachment alloc] init];
        attachment.image = image;
        
        NSAttributedString *attStr = [NSAttributedString attributedStringWithAttachment:attachment];
        
        NSRange range = result.range;
        NSString *plainText = [emojiString substringWithRange:NSMakeRange(preRange.location + preRange.length, range.location - preRange.location - preRange.length)];
        NSAttributedString *tmpAttStr = [[NSAttributedString alloc] initWithString:plainText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        
        [finalStr appendAttributedString:tmpAttStr];
        [finalStr appendAttributedString:attStr];
        
        preRange = result.range;
    }
    NSString *plainText = [emojiString substringFromIndex:preRange.location + preRange.length];
    NSAttributedString *tmpAttStr = [[NSAttributedString alloc] initWithString:plainText];
    [finalStr appendAttributedString:tmpAttStr];

    return finalStr;
}

+ (NSMutableAttributedString *)emojiStringWithString:(NSString *)emojiString withFont:(UIFont *)font andColor:(UIColor *)color
{
    NSString *strRegular = [NSString stringWithFormat:@"%@.*\\.png",EMOJI_REGULAR_PERFIX];
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:strRegular options:0 error:NULL];
    NSArray *allResults = [regular matchesInString:emojiString options:NSMatchingReportCompletion range:NSMakeRange(0, emojiString.length)];
    
    NSMutableAttributedString *finalStr = [[NSMutableAttributedString alloc] init];
    NSRange preRange = NSMakeRange(0, 0);
    NSUInteger perfixLength = [EMOJI_REGULAR_PERFIX length];
    for (NSTextCheckingResult *result in allResults) {
        NSString *imgName = [emojiString substringWithRange:NSMakeRange(result.range.location + perfixLength, result.range.length - perfixLength)];
        UIImage *image = [UIImage imageNamed:imgName];
        
        EmojiAttachment *attachment = [[EmojiAttachment alloc] init];
        attachment.image = image;
        
        NSAttributedString *attStr = [NSAttributedString attributedStringWithAttachment:attachment];
        
        NSRange range = result.range;
        NSString *plainText = [emojiString substringWithRange:NSMakeRange(preRange.location + preRange.length, range.location - preRange.location - preRange.length)];
        NSAttributedString *tmpAttStr = [[NSAttributedString alloc] initWithString:plainText attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        
        [finalStr appendAttributedString:tmpAttStr];
        [finalStr appendAttributedString:attStr];
        
        preRange = result.range;
    }
    NSString *plainText = [emojiString substringFromIndex:preRange.location + preRange.length];
    NSAttributedString *tmpAttStr = [[NSAttributedString alloc] initWithString:plainText attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [finalStr appendAttributedString:tmpAttStr];
    
    return finalStr;

}
@end
