//
//  CircleView.m
//  tcb
//
//  Created by Jax on 15/12/14.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "CircleView.h"
//#define kCircleWidth (SCREEN_WIDTH - 150)

@implementation CircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor]
        ;    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    double kCircleWidth = (SCREEN_WIDTH - 145);
    double lineWidth = 10;
    if (iPhone4) {
        kCircleWidth = (SCREEN_WIDTH - 145);
        lineWidth = 10;
    } else if (iPhone5) {
        kCircleWidth = (SCREEN_WIDTH - 100);
        lineWidth = 20;
    } else if (iPhone6) {
        kCircleWidth = (SCREEN_WIDTH - 90);
        lineWidth = 25;
    } else if (iPhone6plus) {
        kCircleWidth = (SCREEN_WIDTH - 85);
        lineWidth = 25;
    }
    
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *aColor = kRGB(69, 128, 13);
    CGContextSetFillColorWithColor(context, aColor.CGColor);
    CGContextSetLineWidth(context, 0);
    CGContextAddArc(context, SCREEN_WIDTH * 0.5, kCircleWidth * 0.5, kCircleWidth * 0.5, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);

    UIColor *bColor = kRGB(111, 182, 43);
    CGContextSetFillColorWithColor(context, bColor.CGColor);
    CGContextAddArc(context, SCREEN_WIDTH * 0.5, kCircleWidth * 0.5, (kCircleWidth - lineWidth) * 0.5, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
    
}


@end
