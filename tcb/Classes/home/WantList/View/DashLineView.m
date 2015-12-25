//
//  DashLineView.m
//  tcb
//
//  Created by Jax on 15/11/17.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "DashLineView.h"
#import "QuartzCore/QuartzCore.h"

@implementation DashLineView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
     
    }
    return self;
}

//- (void)drawRect:(CGRect)rect
//
//{
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextBeginPath(context);
//    
//    CGContextSetLineWidth(context,0.5);   //线宽度
//    
//    CGContextSetStrokeColorWithColor(context,[[UIColor blackColor] CGColor]);
//    
//    CGFloat lengths[] = {4,2};  //先画4个点再画2个点
//    
//    CGContextSetLineDash(context,0, lengths,2); //注意2(count)的值等于lengths数组的长度
//    
//    CGContextMoveToPoint(context, 0, 1);
//    
//    CGContextAddLineToPoint(context,SCREEN_WIDTH,1);
//    
//    CGContextStrokePath(context);
//    
////    CGContextClosePath(context);
//    
//}

- (void)drawRect:(CGRect)rect

{
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    CGContextSetLineWidth(context, 0.5);//线宽度
    
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    
    CGFloat lengths[] = {4, 2}; //先画4个点再画2个点
    
    CGContextSetLineDash(context, 0, lengths, 2);//注意2(count)的值等于lengths数组的长度
    
    CGContextMoveToPoint(context, 0, 1);

    CGContextAddLineToPoint(context,SCREEN_WIDTH,1);
    
//    CGContextMoveToPoint(context, self.startPoint.x, self.startPoint.y);
//    
//    CGContextAddLineToPoint(context, self.endPoint.x, self.endPoint.y);
    
    CGContextStrokePath(context);
    
//    CGContextClosePath(context);
    
}

@end
