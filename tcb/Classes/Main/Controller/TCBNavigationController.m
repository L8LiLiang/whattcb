//
//  TCBNavigationController.m
//  tcb
//
//  Created by Jax on 15/11/9.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "TCBNavigationController.h"

#import "UIImage+JAX.h"
#import "UIBarButtonItem+Extension.h"


@interface TCBNavigationController ()

@end

@implementation TCBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    NSString *title = @"返回";
    
    //如果发现里面已经存在有且仅有一个，执行到这句代码的时候，代表即将要往navCtrl添加第2个
    if (self.childViewControllers.count == 1) {
        title = [[self.childViewControllers firstObject] title];
    }
    
    //如果当前push进来是第一个控制器的话，（代表当前childViewCtrls里面是没有东西）我们就不要设置leftitem
    if (self.childViewControllers.count) {
        //设置左边item
//        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"common_icon_back_btn_normal" target:self action:@selector(back) title:@"返回"];
        //如果当前不是第一个子控制器，那么在push出去的时候隐藏底部的tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    //这句代码的位置是一个关键
    [super pushViewController:viewController animated:animated];
    
}

- (void)back{
    [self popViewControllerAnimated:YES];
}


@end
