//
//  RobListOrderController.m
//  tcb
//
//  Created by Jax on 15/11/17.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "RobListOrderController.h"
#import "GrabOrderDetail.h"
#import "DashLineView.h"
#import "UIImage+JAX.h"

#define kWhiteCircleImgeWidth 24
#define kMargin 5

@interface RobListOrderController ()

@property (nonatomic, strong)  GrabOrderDetail *grabOrderDetail;
@property (nonatomic, strong)  GrabOrderItem *grabFirstItem;
@property (nonatomic, assign)  NSInteger itemDetailArrayCount;

@property (nonatomic, strong)  UIScrollView *scrollerView;
@property (nonatomic, strong)  UIView *totalView;
@property (nonatomic, strong)  UIView *firstOrderView;
@property (nonatomic, strong)  UIView *secondOrderView;

@property (nonatomic, strong)  UIButton *subtract50;
@property (nonatomic, strong)  UIButton *subtract100;

@end

@implementation RobListOrderController

#pragma mark - 懒加载

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抢单";
    self.navigationController.navigationBar.backgroundColor = kRGB(249, 252, 255);
    self.view.backgroundColor = kRGB(255, 255, 255);
    
    GrabOrderDetail *grabOrderDetail = [[GrabOrderDetail alloc] init];
    NSArray *itemDetailArray = grabOrderDetail.items;
    NSInteger itemDetailArrayCount = itemDetailArray.count;
    itemDetailArrayCount = 2;
    self.itemDetailArrayCount = itemDetailArrayCount;
    
    GrabOrderItem *grabFirstItem = itemDetailArray[0];
    self.grabFirstItem = grabFirstItem;
    
    UIScrollView *scrollerView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollerView];
    scrollerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, 667);
    self.scrollerView = scrollerView;
    
    UIView *totalView = [[UIView alloc] init];
    self.totalView = totalView;
    [self.scrollerView addSubview:totalView];
    totalView.frame = CGRectMake(5, 0, SCREEN_WIDTH - 10, 800);
    
    
    [self setupFirstOrderView:(GrabOrderItem *)grabFirstItem];
    if (itemDetailArrayCount == 2) {
        GrabOrderItem *grabSecondItem = itemDetailArray[1];
        [self setupSecondOrderView:(GrabOrderItem *)grabSecondItem];
    }
    [self setupBottomView];
    
}

- (void)setupFirstOrderView:(GrabOrderItem *)grabFirstItem {
    UIView *firstOrderView = [[UIView alloc] init];
    [self.totalView addSubview:firstOrderView];
    
    [firstOrderView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(self.totalView.left).offset(0);
        make.right.equalTo(self.totalView.right).offset(0);
        make.height.equalTo(230);
    }];
    firstOrderView.backgroundColor = kRGB(18, 141, 254);
    self.firstOrderView = firstOrderView;
    
    UIImageView *whiteCircleImg = [[UIImageView alloc] init];
    [firstOrderView addSubview:whiteCircleImg];
    [whiteCircleImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(5);
        make.height.width.equalTo(kWhiteCircleImgeWidth);
    }];
    whiteCircleImg.image = [UIImage imageNamed:@"ic_white_circle"];
    
    UILabel *ID = [self labelWithTitle:grabFirstItem.ID];
    [firstOrderView addSubview:ID];
    [ID makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteCircleImg);
        make.left.equalTo(whiteCircleImg.right).offset(kMargin);
        make.right.equalTo(firstOrderView.right).offset(-80);
    }];
    ID.text = @"20000000-8000000000000000000000000000000000000";
    ID.numberOfLines = 0;
    
    UILabel *containerType = [self labelWithTitle:grabFirstItem.ContainerType];
    [firstOrderView addSubview:containerType];
    [containerType makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ID.bottom).offset(kMargin);
        make.leading.equalTo(ID);
    }];
    containerType.text = @"100GP";
    
    UILabel *source = [self labelWithTitle:@"韩进"];
    [firstOrderView addSubview:source];
    [source makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(containerType.centerY);
        make.left.equalTo(containerType.right).offset(kMargin);
    }];
    
    NSString *weightString = [NSString stringWithFormat:@"重kgs:%@", [grabFirstItem Weight]];
    weightString = @"重kgs:100";
    UILabel *weight = [self labelWithTitle:weightString];
    [firstOrderView addSubview:weight];
    [weight makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerType.bottom).offset(kMargin);
        make.leading.equalTo(containerType);
    }];
    
    NSString *baoGuanString = [NSString stringWithFormat:@"报关:"];
    UILabel *baoGuan = [self labelWithTitle:baoGuanString];
    [firstOrderView addSubview:baoGuan];
    [baoGuan makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weight.right).offset(kMargin);
        make.centerY.equalTo(weight.centerY);
    }];
    
    NSString *orderMemoString = [NSString stringWithFormat:@"备注:%@", [grabFirstItem Weight]];
    orderMemoString = @"备注:100够不够";
    UILabel *orderMemo = [self labelWithTitle:orderMemoString];
    [firstOrderView addSubview:orderMemo];
    [orderMemo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weight.bottom).offset(kMargin);
        make.leading.equalTo(weight);
    }];
    
    NSString *tikongguiString = [NSString stringWithFormat:@"提空柜:%@", [grabFirstItem Weight]];
    tikongguiString = @"提空柜:100够不够";
    UILabel *tikonggui = [self labelWithTitle:tikongguiString];
    [firstOrderView addSubview:tikonggui];
    [tikonggui makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderMemo.bottom).offset(kMargin);
        make.leading.equalTo(orderMemo);
    }];
    UIImageView *whiteCircleImg1 = [[UIImageView alloc] init];
    [firstOrderView addSubview:whiteCircleImg1];
    [whiteCircleImg1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tikonggui.centerY);
        make.right.equalTo(tikonggui.left).offset(-kMargin);
        make.height.width.equalTo(kWhiteCircleImgeWidth);
    }];
    whiteCircleImg1.image = [UIImage imageNamed:@"ic_white_circle"];
    
    NSString *factoryAddressString = [NSString stringWithFormat:@"提空柜:%@", [grabFirstItem Weight]];
    factoryAddressString = @"北京山海关1";
    UILabel *factoryAddress = [self labelWithTitle:factoryAddressString];
    [firstOrderView addSubview:factoryAddress];
    [factoryAddress makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tikonggui.bottom).offset(kMargin);
        make.leading.equalTo(tikonggui);
    }];
    UIImageView *whiteCircleImg2 = [[UIImageView alloc] init];
    [firstOrderView addSubview:whiteCircleImg2];
    [whiteCircleImg2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(factoryAddress.centerY);
        make.right.equalTo(factoryAddress.left).offset(-kMargin);
        make.height.width.equalTo(kWhiteCircleImgeWidth);
    }];
    whiteCircleImg2.image = [UIImage imageNamed:@"ic_white_circle"];
    

    UILabel *factoryTruckingTime = [self labelWithTitle:grabFirstItem.FactoryTruckingTime];
    [firstOrderView addSubview:factoryTruckingTime];
    [factoryTruckingTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(factoryAddress.bottom).offset(kMargin);
        make.leading.equalTo(factoryAddress);
    }];
    factoryTruckingTime.text = @"2015-08-11 13:38:00";
    UIImageView *whiteCircleImg3 = [[UIImageView alloc] init];
    [firstOrderView addSubview:whiteCircleImg3];
    [whiteCircleImg3 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(factoryTruckingTime.centerY);
        make.right.equalTo(factoryTruckingTime.left).offset(-kMargin);
        make.height.width.equalTo(kWhiteCircleImgeWidth);
    }];
    whiteCircleImg3.image = [UIImage imageNamed:@"ic_white_circle"];
    
    NSString *deliveryYardString = [NSString stringWithFormat:@"还重柜:%@", [grabFirstItem DeliveryYard]];
    deliveryYardString = @"还重柜:100够不够";
    UILabel *deliveryYard = [self labelWithTitle:deliveryYardString];
    [firstOrderView addSubview:deliveryYard];
    [deliveryYard makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(factoryTruckingTime.bottom).offset(kMargin);
        make.leading.equalTo(factoryTruckingTime);
    }];
    UIImageView *whiteCircleImg4 = [[UIImageView alloc] init];
    [firstOrderView addSubview:whiteCircleImg4];
    [whiteCircleImg4 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(deliveryYard.centerY);
        make.right.equalTo(deliveryYard.left).offset(-kMargin);
        make.height.width.equalTo(kWhiteCircleImgeWidth);
    }];
    whiteCircleImg4.image = [UIImage imageNamed:@"ic_white_circle"];
    
    
}

- (void)setupSecondOrderView:(GrabOrderItem *)grabSecondItem {
    
    DashLineView *lineView = [[DashLineView alloc] init];
    lineView.lineColor = [UIColor whiteColor];
    lineView.backgroundColor = [UIColor clearColor];
    [self.totalView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstOrderView.bottom).offset(0);
        make.left.right.equalTo(0);
        make.height.equalTo(0.5);
    }];
    
    UIView *secondOrderView = [[UIView alloc] init];
    self.secondOrderView = secondOrderView;
    [self.totalView addSubview:secondOrderView];
    [secondOrderView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.bottom).offset(0);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(230);
    }];
    secondOrderView.backgroundColor = kRGB(18, 141, 254);
    
    UIImageView *whiteCircleImg = [[UIImageView alloc] init];
    [secondOrderView addSubview:whiteCircleImg];
    [whiteCircleImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(5);
        make.height.width.equalTo(kWhiteCircleImgeWidth);
    }];
    whiteCircleImg.image = [UIImage imageNamed:@"ic_white_circle"];
    
    UILabel *ID = [self labelWithTitle:grabSecondItem.ID];
    [secondOrderView addSubview:ID];
    [ID makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteCircleImg);
        make.left.equalTo(whiteCircleImg.right).offset(kMargin);
        make.right.equalTo(secondOrderView.right).offset(-80);
    }];
    ID.text = @"20000000-8888-0000-0000-000000000000";
    ID.numberOfLines = 0;
    
    UILabel *containerType = [self labelWithTitle:grabSecondItem.ContainerType];
    [secondOrderView addSubview:containerType];
    [containerType makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ID.bottom).offset(kMargin);
        make.leading.equalTo(ID);
    }];
    containerType.text = @"100GP";
    
    UILabel *source = [self labelWithTitle:@"韩进"];
    [secondOrderView addSubview:source];
    [source makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(containerType.centerY);
        make.left.equalTo(containerType.right).offset(kMargin);
    }];
    
    NSString *weightString = [NSString stringWithFormat:@"重kgs:%@", [grabSecondItem Weight]];
    weightString = @"重kgs:100";
    UILabel *weight = [self labelWithTitle:weightString];
    [secondOrderView addSubview:weight];
    [weight makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerType.bottom).offset(kMargin);
        make.leading.equalTo(containerType);
    }];
    
    NSString *baoGuanString = [NSString stringWithFormat:@"报关:"];
    UILabel *baoGuan = [self labelWithTitle:baoGuanString];
    [secondOrderView addSubview:baoGuan];
    [baoGuan makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weight.right).offset(kMargin);
        make.centerY.equalTo(weight.centerY);
    }];
    
    NSString *orderMemoString = [NSString stringWithFormat:@"备注:%@", [grabSecondItem Weight]];
    orderMemoString = @"备注:100够不够";
    UILabel *orderMemo = [self labelWithTitle:orderMemoString];
    [secondOrderView addSubview:orderMemo];
    [orderMemo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weight.bottom).offset(kMargin);
        make.leading.equalTo(weight);
    }];
    
    NSString *tikongguiString = [NSString stringWithFormat:@"提空柜:%@", [grabSecondItem Weight]];
    tikongguiString = @"提空柜:100够不够";
    UILabel *tikonggui = [self labelWithTitle:tikongguiString];
    [secondOrderView addSubview:tikonggui];
    [tikonggui makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderMemo.bottom).offset(kMargin);
        make.leading.equalTo(orderMemo);
    }];
    UIImageView *whiteCircleImg1 = [[UIImageView alloc] init];
    [secondOrderView addSubview:whiteCircleImg1];
    [whiteCircleImg1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tikonggui.centerY);
        make.right.equalTo(tikonggui.left).offset(-kMargin);
        make.height.width.equalTo(kWhiteCircleImgeWidth);
    }];
    whiteCircleImg1.image = [UIImage imageNamed:@"ic_white_circle"];
    
    NSString *factoryAddressString = [NSString stringWithFormat:@"提空柜:%@", [grabSecondItem Weight]];
    factoryAddressString = @"北京山海关1";
    UILabel *factoryAddress = [self labelWithTitle:factoryAddressString];
    [secondOrderView addSubview:factoryAddress];
    [factoryAddress makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tikonggui.bottom).offset(kMargin);
        make.leading.equalTo(tikonggui);
    }];
    UIImageView *whiteCircleImg2 = [[UIImageView alloc] init];
    [secondOrderView addSubview:whiteCircleImg2];
    [whiteCircleImg2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(factoryAddress.centerY);
        make.right.equalTo(factoryAddress.left).offset(-kMargin);
        make.height.width.equalTo(kWhiteCircleImgeWidth);
    }];
    whiteCircleImg2.image = [UIImage imageNamed:@"ic_white_circle"];
    
    
    UILabel *factoryTruckingTime = [self labelWithTitle:grabSecondItem.FactoryTruckingTime];
    [secondOrderView addSubview:factoryTruckingTime];
    [factoryTruckingTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(factoryAddress.bottom).offset(kMargin);
        make.leading.equalTo(factoryAddress);
    }];
    factoryTruckingTime.text = @"2015-08-11 13:38:00";
    UIImageView *whiteCircleImg3 = [[UIImageView alloc] init];
    [secondOrderView addSubview:whiteCircleImg3];
    [whiteCircleImg3 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(factoryTruckingTime.centerY);
        make.right.equalTo(factoryTruckingTime.left).offset(-kMargin);
        make.height.width.equalTo(kWhiteCircleImgeWidth);
    }];
    whiteCircleImg3.image = [UIImage imageNamed:@"ic_white_circle"];
    
    NSString *deliveryYardString = [NSString stringWithFormat:@"还重柜:%@", [grabSecondItem DeliveryYard]];
    deliveryYardString = @"还重柜:100够不够";
    UILabel *deliveryYard = [self labelWithTitle:deliveryYardString];
    [secondOrderView addSubview:deliveryYard];
    [deliveryYard makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(factoryTruckingTime.bottom).offset(kMargin);
        make.leading.equalTo(factoryTruckingTime);
    }];
    UIImageView *whiteCircleImg4 = [[UIImageView alloc] init];
    [secondOrderView addSubview:whiteCircleImg4];
    [whiteCircleImg4 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(deliveryYard.centerY);
        make.right.equalTo(deliveryYard.left).offset(-kMargin);
        make.height.width.equalTo(kWhiteCircleImgeWidth);
    }];
    whiteCircleImg4.image = [UIImage imageNamed:@"ic_white_circle"];
    
}

- (void)setupBottomView {
    self.grabFirstItem.TotalCosts = 100;
    UILabel *totalCosts = [self labelWithTitle:[NSString stringWithFormat:@"￥%zd", 100]];
    [self.view addSubview:totalCosts];
    [totalCosts makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.firstOrderView);
        if (self.itemDetailArrayCount == 1) {
            make.top.equalTo(self.firstOrderView.bottom).offset(10);
        } else if (self.itemDetailArrayCount == 2) {
            make.top.equalTo(self.secondOrderView.bottom).offset(10);
        }
    }];
    totalCosts.textColor = kRGB(251, 185, 84);
    totalCosts.font = [UIFont systemFontOfSize:25];

    UIButton *subtract100 = [[UIButton alloc] init];
    [self.view addSubview:subtract100];
    [subtract100 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(totalCosts.centerY);
        make.height.equalTo(40);
        make.width.equalTo(80);
        make.right.equalTo(-10);
    }];
    [subtract100 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [subtract100 setTitleColor:kRGB(251, 185, 84) forState:UIControlStateSelected];
    [subtract100 setTitle:@"减￥100" forState:UIControlStateNormal];
    [subtract100 setTitle:@"减￥100" forState:UIControlStateSelected];
    subtract100.layer.borderColor =  (subtract100.selected) ? [kRGB(251, 185, 84) CGColor] : [[UIColor lightGrayColor] CGColor];
    subtract100.layer.borderWidth = 1;
    subtract100.layer.cornerRadius = 5;
    subtract100.layer.masksToBounds = YES;
    subtract100.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [subtract100 addTarget:self action:@selector(subtract100Pressed:) forControlEvents:UIControlEventTouchUpInside];
    self.subtract100 = subtract100;
    
    UIButton *subtract50 = [[UIButton alloc] init];
    [self.view addSubview:subtract50];
    [subtract50 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(totalCosts.centerY);
        make.height.equalTo(40);
        make.width.equalTo(80);
        make.right.equalTo(subtract100.left).offset(-10);
    }];
    [subtract50 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [subtract50 setTitleColor:kRGB(251, 185, 84) forState:UIControlStateSelected];
    [subtract50 setTitle:@"减￥50" forState:UIControlStateNormal];
    [subtract50 setTitle:@"减￥50" forState:UIControlStateSelected];
    subtract50.layer.borderColor = (subtract50.selected) ? [kRGB(251, 185, 84) CGColor] : [[UIColor lightGrayColor] CGColor];
    subtract50.layer.borderWidth = 1;
    subtract50.layer.cornerRadius = 5;
    subtract50.layer.masksToBounds = YES;
    subtract50.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [subtract50 addTarget:self action:@selector(subtract50Pressed:) forControlEvents:UIControlEventTouchUpInside];
    self.subtract50 = subtract50;
    
    UIButton *robList = [[UIButton alloc] init];
    [self.view addSubview:robList];
    [robList makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subtract50.bottom).offset(5);
        make.leading.trailing.equalTo(self.firstOrderView);
        make.height.equalTo(38);
    }];
    [robList setTitle:@"抢单" forState:UIControlStateNormal];
    [robList setBackgroundImage:[UIImage resizedImage:@"btn_bg_blue_normal"] forState:UIControlStateNormal];
    [robList setBackgroundImage:[UIImage resizedImage:@"btn_bg_blue_press"] forState:UIControlStateNormal];
}

- (void)subtract50Pressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    sender.layer.borderColor = (sender.selected) ? [kRGB(251, 185, 84) CGColor] : [[UIColor lightGrayColor] CGColor];
    self.subtract100.selected = NO;
    self.subtract100.layer.borderColor = (self.subtract100.selected) ? [kRGB(251, 185, 84) CGColor] : [[UIColor lightGrayColor] CGColor];
    if(sender.selected) {
        NSLog(@"减去50");
    }
}

- (void)subtract100Pressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    sender.layer.borderColor = (sender.selected) ? [kRGB(251, 185, 84) CGColor] : [[UIColor lightGrayColor] CGColor];
    self.subtract50.selected = NO;
    self.subtract50.layer.borderColor = (self.subtract50.selected) ? [kRGB(251, 185, 84) CGColor] : [[UIColor lightGrayColor] CGColor];
    if(sender.selected) {
        NSLog(@"减去100");
    }
}

- (UILabel *)labelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:17];
    return label;
}


@end
