//
//  ListNoOrderController.m
//  tcb
//
//  Created by Jax on 15/11/16.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ListNoOrderController.h"

@interface ListNoOrderController ()

@end


@implementation ListNoOrderController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我要接单";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpViews];
    
}

- (void)setUpViews {
    UIView *totalView = [[UIView alloc] init];
    [self.view addSubview:totalView];
    [totalView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.centerY.equalTo(self.view.centerY);
        make.left.right.equalTo(0);
        make.height.equalTo(200);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [totalView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"bg_mail"];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalView.top).offset(0);
        make.height.equalTo(100);
        make.width.equalTo(120);
        make.centerX.equalTo(totalView.centerX);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"没有收到任何派车单,请联系您";
    label1.textAlignment = NSTextAlignmentCenter;
    [totalView addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.bottom).offset(10);
        make.left.right.equalTo(0);
        make.height.equalTo(30);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"的车队确认派车计划";
    label2.textAlignment = NSTextAlignmentCenter;
    [totalView addSubview:label2];
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.bottom).offset(0);
        make.left.right.equalTo(0);
        make.height.equalTo(30);
    }];

}



@end
