//
//  ElChangeTitlePositionButton.m
//  tcb
//
//  Created by Chuanxun on 15/11/20.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ElChangeTitlePositionButton.h"


@implementation ElChangeTitlePositionButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    NSString *title = [self titleForState:UIControlStateNormal];
    NSRange range = [title rangeOfString:@"("];
    NSString *subTitle;
    if (range.location != NSNotFound) {
        subTitle = [title substringFromIndex:range.location];
    }
    
    if (!subTitle || subTitle.length <= 0) {
        return [super titleRectForContentRect:contentRect];
    }
    
    CGRect rect = [super titleRectForContentRect:contentRect];
    CGRect titleRect = [subTitle boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil];
    CGFloat xOffset = titleRect.size.width / 2.0;
    rect.origin.x = rect.origin.x + xOffset;
    
    CGFloat maxX = CGRectGetMaxX(contentRect) - self.titleEdgeInsets.right;
    if (CGRectGetMaxX(rect) > maxX) {
        rect.origin.x -= CGRectGetMaxX(rect) - maxX;
    }
    
    return rect;
}

@end
