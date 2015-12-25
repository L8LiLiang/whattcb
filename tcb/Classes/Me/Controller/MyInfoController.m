//
//  MyInfoController.m
//  tcb
//
//  Created by Jax on 15/12/2.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "MyInfoController.h"
#import <UIImageView+WebCache.h>

#define kBottomViewHeight 130

@interface MyInfoController ()

//UserName:用户名称,
//TruckNo:车牌号,
//Horsepower:马力,
//DriverBookNo:司机本,
//GPSId:GPSId,
//Record:备案
//HeadUrl:头像图片

@end

@implementation MyInfoController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资料";
    self.view.backgroundColor = kRGB(233, 233, 233);
    [self getMyInfo];
}



- (void)getMyInfo {


    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"GetUserProfile" forKey:@"cmd"];
    [SVProgressHUD showWithStatus:@"个人信息获取中" maskType:SVProgressHUDMaskTypeBlack];
    [APIClientTool getUserProfileWithParam:param success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        
        MyInfoResultModel *myInfoResultModel = [MyInfoResultModel mj_objectWithKeyValues:dict];
        if (myInfoResultModel.ret == 0) {
            self.myInfoResultModel = myInfoResultModel;
            [self setUpViews];
        } else {
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
        }
        
    } failed:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];

}
- (void)setUpViews {
    
    MyInfoData *myInfoData = self.myInfoResultModel.data;
    
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(64 + 10);
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.height.equalTo(100);
    }];
    
    UIImageView *headImageView2 = [[UIImageView alloc] init];
    [headImageView2 sd_setImageWithURL:[NSURL URLWithString:myInfoData.HeadUrl] placeholderImage:[UIImage imageNamed:@"ic_driving_license"]];
    [topView addSubview:headImageView2];
    [headImageView2 makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.top.equalTo(10);
        make.width.height.equalTo(40);
    }];
    
    UIImageView *headImageView1 = [[UIImageView alloc] init];
    headImageView1.image = [UIImage imageNamed:@"personinfo_person"];
    [topView addSubview:headImageView1];
    [headImageView1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.centerY.equalTo(headImageView2.centerY);
        make.width.height.equalTo(20);
    }];
    
    UILabel *myNameLabel = [[UILabel alloc] init];
    [topView addSubview:myNameLabel];
    [myNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headImageView1.centerY);
        make.left.equalTo(headImageView1.right).offset(5);
        make.right.equalTo(headImageView2.left).offset(-5);
    }];
    myNameLabel.text = myInfoData.UserName;
    
    UIImageView *cardImageView = [[UIImageView alloc] init];
    [topView addSubview:cardImageView];
    [cardImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView2.bottom).offset(10);
        make.left.equalTo(10);
        make.width.height.equalTo(20);
    }];
    cardImageView.image = [UIImage imageNamed:@"personinfo_info"];
    
    UILabel *cardLabel = [[UILabel alloc] init];
    [topView addSubview:cardLabel];
    [cardLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardImageView.centerY);
        make.left.equalTo(cardImageView.right).offset(5);
        make.right.equalTo(0);
    }];
    cardLabel.text = myInfoData.TruckNo;
    
    UIView *middleView = [[UIView alloc] init];
    [self.view addSubview:middleView];
    [middleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.bottom).offset(0);
        make.leading.equalTo(topView);
        make.trailing.equalTo(topView);
        make.height.equalTo(50);
    }];
   
    UIButton *editButton = [[UIButton alloc] init];
    [middleView addSubview:editButton];
    [editButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.right.equalTo(-10);
        make.width.equalTo(80);
    }];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setImage:[UIImage imageNamed:@"personinfo_write"] forState:UIControlStateNormal];
    editButton.enabled = NO;
    [editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView.bottom).offset(0);
        make.leading.equalTo(topView);
        make.trailing.equalTo(topView);
        make.height.equalTo(kBottomViewHeight);
    }];
    
    UILabel *horsepower = [[UILabel alloc] init];
    horsepower.text = [NSString stringWithFormat:@"  马    力:  %zd", myInfoData.Horsepower];
    [bottomView addSubview:horsepower];
    [horsepower makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(kBottomViewHeight * 0.25 - 2);
    }];
    
    UILabel *driverBookNo = [[UILabel alloc] init];
    driverBookNo.text = [NSString stringWithFormat:@"  司机本:  %zd", myInfoData.DriverBookNo];
    [bottomView addSubview:driverBookNo];
    [driverBookNo makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(horsepower.bottom).offset(0);
        make.height.equalTo(kBottomViewHeight * 0.25 - 2);
    }];
    
    UILabel *record = [[UILabel alloc] init];
    record.text = [NSString stringWithFormat:@"  备    案:  %zd", myInfoData.Record];
    [bottomView addSubview:record];
    [record makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
       make.top.equalTo(driverBookNo.bottom).offset(0);
        make.height.equalTo(kBottomViewHeight * 0.25 - 2);
    }];
    
    UILabel *GPS = [[UILabel alloc] init];
    GPS.text = [NSString stringWithFormat:@"   G P S:  %zd", myInfoData.GPSId];
    [bottomView addSubview:GPS];
    [GPS makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(record.bottom).offset(0);
        make.height.equalTo(kBottomViewHeight * 0.25 - 2);
    }];
    
    topView.backgroundColor = [UIColor whiteColor];
    bottomView.backgroundColor = [UIColor whiteColor];
    middleView.backgroundColor = [UIColor whiteColor];

}



@end
