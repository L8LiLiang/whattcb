//
//  UILabel+Extension.m
//  tcb
//
//  Created by Chuanxun on 15/11/19.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
//                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}

@end
