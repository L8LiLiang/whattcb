//
//  AutoSignInController.m
//  tcb
//
//  Created by Chuanxun on 15/11/17.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "AutoSignInController.h"
#import "OrderProcessFlowView.h"
#import "OrderProcessFlowNodeView.h"
#import "OrderInfoView.h"
#import "ElChangeTitlePositionButton.h"
#import "OrderProcessFlowInputBoxNoView.h"
#import "BoxNoInputController.h"
#import "TakePhotoController.h"


@interface AutoSignInController () <OrderInfoViewDelegate,OrderProcessFlowViewDelegate>

@property (strong, nonatomic) OrderProcessFlowView *flowView;
@property (strong, nonatomic) OrderProcessFlowNodeView *nodeView;
@property (strong, nonatomic) OrderInfoView *topView;

@property (strong, nonatomic) UILabel *lblPhotoNum;
@property (weak, nonatomic) UIButton *photoButton;
@property (strong, nonatomic) Order *order;

@end

@implementation AutoSignInController

-(instancetype)init
{
    if (self = [super init]) {
        
        //订单信息view
        OrderInfoView *topView = [OrderInfoView viewWithOrder:nil];
        [self.view addSubview:topView];
        topView.delegate = self;
        self.topView = topView;
        
        //监装拍照 费用录入按钮
        ElChangeTitlePositionButton *buttonPhoto = [ElChangeTitlePositionButton buttonWithType:UIButtonTypeCustom];
        NSString *tip = NSLocalizedString(@"Photos", @"监装拍照");
        buttonPhoto.titleLabel.font = FONT_MIDDLE;
        [buttonPhoto setTitle:tip forState:UIControlStateNormal];
        buttonPhoto.backgroundColor = [UIColor clearColor];
        buttonPhoto.layer.borderColor = topView.backgroundColor.CGColor;
        buttonPhoto.layer.borderWidth = 1;
        buttonPhoto.layer.cornerRadius = 5;
        [buttonPhoto setTitleColor:topView.backgroundColor forState:UIControlStateNormal];
        [self.view addSubview:buttonPhoto];
        self.photoButton = buttonPhoto;
        [buttonPhoto addTarget:self action:@selector(photoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        ElChangeTitlePositionButton *buttonCharge = [ElChangeTitlePositionButton buttonWithType:UIButtonTypeCustom];
        buttonCharge.titleLabel.font = FONT_MIDDLE;
        tip = NSLocalizedString(@"Charge", @"费用录入");
        [buttonCharge setTitle:tip forState:UIControlStateNormal];
        buttonCharge.backgroundColor = [UIColor clearColor];
        buttonCharge.layer.borderColor = topView.backgroundColor.CGColor;
        buttonCharge.layer.borderWidth = 1;
        buttonCharge.layer.cornerRadius = 5;
        [buttonCharge setTitleColor:topView.backgroundColor forState:UIControlStateNormal];
        [self.view addSubview:buttonCharge];
        [buttonCharge addTarget:self action:@selector(chargeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        int margin = 16;
        [buttonPhoto makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).offset(margin);
            make.top.equalTo(topView.bottom).offset(4);
            make.right.equalTo(buttonCharge.left).offset(-margin);
        }];
        
        [buttonCharge makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(buttonPhoto.right).offset(margin);
            make.right.equalTo(self.view.right).offset(-margin);
            make.centerY.equalTo(buttonPhoto);
            make.width.equalTo(buttonPhoto);
        }];
        
        //订单处理流程view
        Order *order = [Order new];
        order.titles = @[@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1"];
        OrderProcessFlowView *flowView = [OrderProcessFlowView flowViewWithOrder:order width:SCREEN_WIDTH delegate:self];
        [self.view addSubview:flowView];
//        flowView.frame = self.view.bounds;
        self.flowView = flowView;
        self.order = order;
        
        CGFloat height = [topView bestHeight];
        [self.topView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(20);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.equalTo(height);
        }];
        
        [self.flowView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.top.equalTo(buttonPhoto.bottom).offset(4);
        }];
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"473274895955323773";
    
    self.view.backgroundColor = self.topView.backgroundColor;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    //    self.navigationController.navigationBar.backgroundColor = self.topView.backgroundColor;
}

- (void)photoButtonClicked:(UIButton *)sender
{
    [sender setTitle:@"监装拍照 (5)" forState:UIControlStateNormal];
    
    TakePhotoController *photoController = [TakePhotoController new];
    [self.navigationController pushViewController:photoController animated:YES];
}
- (void)chargeButtonClicked:(UIButton *)sender
{
    
}

- (void)test:(UIButton *)sender
{
    [self.flowView printFrame];
}

#pragma mark - OrderInfoViewDelegate

-(void)infoViewCallButtonClicked:(OrderInfoView *)infoView
{
    NSLog(@"infoViewCallButtonClicked");
}

-(void)infoViewBackButtonClicked:(OrderInfoView *)infoView
{
    NSLog(@"infoViewBackButtonClicked");
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)infoViewChangeBox:(OrderInfoView *)infoView
{
    NSLog(@"infoViewChangeBox");
}


#pragma mark - OrderProcessFlowInputBoxNoViewDelegate

-(void)inputBoxNoView:(OrderProcessFlowInputBoxNoView *)view btnClicked:(UIButton *)button
{
    BoxNoInputController *controller = [BoxNoInputController controllerWithOrder:self.order];
    [self.navigationController pushViewController:controller animated:YES];
}



@end
