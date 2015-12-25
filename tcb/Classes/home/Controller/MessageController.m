//
//  MessageController.m
//  tcb
//
//  Created by Jax on 15/12/11.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "MessageController.h"

#import "CheckController.h"
#import "CheckMonthController.h"
#import "CheckListController.h"
#import "TestController.h"

#import "FleetMessageController.h"
#import "SystemMessageController.h"

@interface MessageController ()

@end

@implementation MessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"消息";
    
    [self makeSlideView];
}

- (void)makeSlideView
{
    self.tabedSlideView = [DLTabedSlideView new];
    self.tabedSlideView.delegate = self;
    [self.view addSubview:self.tabedSlideView];
    [self.tabedSlideView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(76, 0, 0, 0));
    }];
    self.tabedSlideView.baseViewController = self;
    self.tabedSlideView.tabItemNormalColor = [UIColor blackColor];
    self.tabedSlideView.tabItemSelectedColor = [UIColor colorWithRed:18/255.0 green:141/255.0 blue:1.0 alpha:1.0];
 
    self.tabedSlideView.tabbarBottomSpacing = 8.0;
//    self.tabedSlideView.tabbarHeight = 16;
    self.tabedSlideView.tabbarTrackColor = [UIColor colorWithRed:18/255.0 green:141/255.0 blue:1.0 alpha:1.0];
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"车队通知" image:nil selectedImage:nil];
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"系统通知" image:nil selectedImage:nil];
    self.tabedSlideView.tabbarItems = @[item1, item2];
    [self.tabedSlideView buildTabbar];
    
    self.tabedSlideView.selectedIndex = 0;
}

- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return 2;
}

- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case 0:
        {
            FleetMessageController *ctrl = [[FleetMessageController alloc] init];
            return ctrl;
        }
        case 1:
        {
            SystemMessageController *ctrl = [[SystemMessageController alloc] init];
            return ctrl;
        }
        default:
            return nil;
    }
}


@end
