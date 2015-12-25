//
//  TestController.m
//  tcb
//
//  Created by Chuanxun on 15/12/3.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "TestController.h"

@interface TestController ()

@end

@implementation TestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    double red = [self getRandomNumber:0 to:255] /  255.0;
    double green = [self getRandomNumber:0 to:255] /  255.0;
    double blue = [self getRandomNumber:0 to:255] /  255.0;
    
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

-(int)getRandomNumber:(int)from to:(int)to

{
    
    return (int)(from + (arc4random() % (to - from + 1)));
    
}
@end
