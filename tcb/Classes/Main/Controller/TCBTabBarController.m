//
//  TCBTabBarController.m
//  tcb
//
//  Created by Jax on 15/11/9.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "TCBTabBarController.h"

#import "TCBNavigationController.h"
#import "CheckController.h"
#import "HomeViewController.h"
#import "MeViewController.h"

#import "UIImage+JAX.h"


@interface TCBTabBarController () <UITabBarDelegate>

@property (nonatomic, strong) UIViewController *homeViewController;

@end

@implementation TCBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.tabBar.hidden = NO;
    
    
//    //初始化一个自己的tabbar
//    TCBTabBar *tabbar = [[TCBTabBar alloc] init];
//    
//    tabbar.delegate = self;
//    //通过kvc去设置只读的属性
//    [self setValue:tabbar forKeyPath:@"tabBar"];

    //  账单
    CheckController *checkController = [CheckController new];
    [self addChildViewCtrl:checkController imageName:@"tabbar_check" title:@"对账单"];
    
    HomeViewController *homeViewController = [HomeViewController new];
    self.homeViewController = homeViewController;
    [self addChildViewCtrl:homeViewController imageName:@"tabar_home2" title:@""];
    
    MeViewController *meViewController = [MeViewController new];
    [self addChildViewCtrl:meViewController imageName:@"tabbar_personal" title:@"我的"];
    
    self.selectedIndex = 1;

}

- (void)addChildViewCtrl:(UIViewController *)ctrl imageName:(NSString *)imageName title:(NSString *)title{
    
    ctrl.tabBarItem.image = [UIImage imageNamed:imageName];
    ctrl.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",imageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if ([title isEqualToString:@""]) {
        //设置图片的偏移量
        ctrl.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }
    ctrl.tabBarItem.title = title;
    //初始化一个文字属性字典
    NSMutableDictionary *dicNormal = [NSMutableDictionary dictionary];
    dicNormal[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSMutableDictionary *dicSelected = [NSMutableDictionary dictionary];
    dicSelected[NSForegroundColorAttributeName] = kDefaultBarButtonItemColor;
    [ctrl.tabBarItem setTitleTextAttributes:dicNormal forState:UIControlStateNormal];
    [ctrl.tabBarItem setTitleTextAttributes:dicSelected forState:UIControlStateSelected];
    //添加到tabbarctrl里面
    TCBNavigationController *navCtrl = [[TCBNavigationController alloc] initWithRootViewController:ctrl];
    
    [self addChildViewController:navCtrl];
    
}

@end
