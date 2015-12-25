//
//  CheckController.m
//  tcb
//
//  Created by Jax on 15/11/10.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "CheckController.h"
#import "CheckMonthController.h"
#import "CheckListController.h"
#import "TestController.h"


@interface CheckController ()

@end

@implementation CheckController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"对账收款";
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Home_messageTip"] style:UIBarButtonItemStylePlain target:self action:@selector(goToMessageController:)];
//    self.navigationItem.rightBarButtonItem = item;
    
    [self makeSlideView];
}

- (void)makeSlideView
{
    self.tabedSlideView = [DLTabedSlideView new];
    self.tabedSlideView.delegate = self;
    [self.view addSubview:self.tabedSlideView];
    [self.tabedSlideView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    self.tabedSlideView.baseViewController = self;
    self.tabedSlideView.tabItemNormalColor = [UIColor blackColor];
    //light blue
    self.tabedSlideView.tabItemSelectedColor = [UIColor colorWithRed:18/255.0 green:141/255.0 blue:1.0 alpha:1.0];
    self.tabedSlideView.tabbarTrackColor = [UIColor colorWithRed:18/255.0 green:141/255.0 blue:1.0 alpha:1.0];;
    
//    self.tabedSlideView.tabbarBackgroundImage = [UIImage imageNamed:@"tabbarBk"];
    self.tabedSlideView.tabbarBottomSpacing = 4.0;
//    self.tabedSlideView.tabbarHeight = 16;
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"月结" image:nil selectedImage:nil];
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"票结" image:nil selectedImage:nil];
    DLTabedbarItem *item3 = [DLTabedbarItem itemWithTitle:@"其他" image:nil selectedImage:nil];
    self.tabedSlideView.tabbarItems = @[item1, item2, item3];
    [self.tabedSlideView buildTabbar];
    
    self.tabedSlideView.selectedIndex = 0;
}


- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return 3;
}

- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case 0:
        {
            CheckMonthController *ctrl = [[CheckMonthController alloc] init];
            return ctrl;
        }
        case 1:
        {
            CheckListController *ctrl = [[CheckListController alloc] init];
            return ctrl;
        }
        case 2:
        {
            TestController *ctrl = [[TestController alloc] init];
            return ctrl;
//            return nil;
        }
            
        default:
            return nil;
    }
}

- (void)goToMessageController:(id)sender
{
    NSLog(@"message");
}

@end
