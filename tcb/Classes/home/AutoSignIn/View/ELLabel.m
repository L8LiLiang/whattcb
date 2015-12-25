//
//  ELLabel.m
//  tcb
//
//  Created by Chuanxun on 15/11/18.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ELLabel.h"

@implementation ELLabel

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.preferredMaxLayoutWidth = self.bounds.size.width;
    
    [super layoutSubviews];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
