//
//  DashLineView.h
//  tcb
//
//  Created by Jax on 15/11/17.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashLineView : UIView

@property (nonatomic, assign) CGPoint startPoint;//虚线起点

@property (nonatomic, assign) CGPoint endPoint;//虚线终点

@property (nonatomic,strong) UIColor *lineColor;//虚线颜色

@end
