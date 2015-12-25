//
//  OilCardDetailController.m
//  tcb
//
//  Created by Chuanxun on 15/12/15.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "OilCardDetailController.h"
#import "TestController.h"
#import "OilCardDetailItemController.h"

@interface OilCardDetailController ()

@property (copy, nonatomic) NSString *cardId;

@end

@implementation OilCardDetailController


- (instancetype)initWithCardID:(NSString *)cardId
{
    if (self = [super init]) {
        self.cardId = cardId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"加油卡";
    
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
    //little blue
    self.tabedSlideView.tabItemSelectedColor = [UIColor colorWithRed:18/255.0 green:141/255.0 blue:1.0 alpha:1.0];
    self.tabedSlideView.tabbarTrackColor = [UIColor colorWithRed:18/255.0 green:141/255.0 blue:1.0 alpha:1.0];;
    
    self.tabedSlideView.backgroundColor = [UIColor whiteColor];
    //    self.tabedSlideView.tabbarBackgroundImage = [UIImage imageNamed:@"tabbarBk"];
    self.tabedSlideView.tabbarBottomSpacing = 4.0;
//        self.tabedSlideView.tabbarHeight = 16;
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"全部" image:nil selectedImage:nil];
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"买油存入" image:nil selectedImage:nil];
    DLTabedbarItem *item3 = [DLTabedbarItem itemWithTitle:@"加油消耗" image:nil selectedImage:nil];
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
            OilCardDetailItemController *ctl = [[OilCardDetailItemController alloc] initWithCardID:self.cardId Type:OCDICT_ALL];
            return ctl;
        }
        case 1:
        {
            OilCardDetailItemController *ctl = [[OilCardDetailItemController alloc] initWithCardID:self.cardId Type:OCDICT_ADD];
            return ctl;
        }
        case 2:
        {
            OilCardDetailItemController *ctl = [[OilCardDetailItemController alloc] initWithCardID:self.cardId Type:OCDICT_DELETE];
            return ctl;
        }
            
        default:
            return nil;
    }
}


@end
