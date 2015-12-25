//
//  FleetMsgDetailController.m
//  tcb
//
//  Created by Jax on 15/12/11.
//  Copyright © 2015年 Jax. All rights reserved.
//

#define kTitleFont [UIFont systemFontOfSize:25]
#define kTimeFont [UIFont systemFontOfSize:20]
#define kContentFont [UIFont systemFontOfSize:17]

#import "FleetMsgDetailController.h"
#import "FleetMsgDetailModel.h"
#import "NSString+Extension.h"

@interface FleetMsgDetailController ()
@property (nonatomic, strong) FleetMsgDetailModel *fleetMsgDetailModel;
@end

@implementation FleetMsgDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.company;
    
    [self getMsgDetail];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)getMsgDetail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GetMsgDetail" forKey:@"cmd"];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setValue:[NSNumber numberWithInteger:self.Id] forKey:@"id"];
    [params setValue:data forKey:@"data"];
    
    [SVProgressHUD showWithStatus:@"车队通知详情获取中" maskType:SVProgressHUDMaskTypeBlack];
    [APIClientTool GetMsgDetailWithParam:params success:^(NSDictionary *dict) {
         [SVProgressHUD dismiss];
        FleetMsgDetailModel *fleetMsgDetailModel = [FleetMsgDetailModel mj_objectWithKeyValues:dict];
        if (fleetMsgDetailModel.ret == 0) {
            self.fleetMsgDetailModel = fleetMsgDetailModel;
            [self setUpViews];
        }
    
    } failed:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
}

- (void)setUpViews {
    FleetMsgDetail *fleetMsgDetail = self.fleetMsgDetailModel.data;
    
    UIScrollView *scrollerView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollerView];
    scrollerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    
    UIView *contentView = [[UIView alloc] init];
    [scrollerView addSubview:contentView];
    contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [contentView addSubview:titleLabel];
    titleLabel.text = fleetMsgDetail.Title;
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(94);
        make.left.equalTo(20);
        make.right.equalTo(-20);
        make.height.equalTo(40);
    }];
    titleLabel.font = kTitleFont;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [contentView addSubview:timeLabel];
    timeLabel.text = fleetMsgDetail.Time;
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.bottom).offset(20);
        make.leading.equalTo(titleLabel);
        make.trailing.equalTo(titleLabel);
        make.height.equalTo(30);
    }];
    timeLabel.font = kTimeFont;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    [contentView addSubview:contentLabel];
    contentLabel.text = fleetMsgDetail.Content;
    CGSize contentSize = [fleetMsgDetail.Content sizeWithFont:kContentFont andMaxSize:CGSizeMake(SCREEN_WIDTH - 2 * 20, CGFLOAT_MAX)];
    
    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.bottom).offset(20);
        make.leading.equalTo(timeLabel);
        make.trailing.equalTo(timeLabel);
        make.height.equalTo(contentSize.height);
    }];
    contentLabel.font = kContentFont;
    contentLabel.numberOfLines = 0;
    
    scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, 230 + contentSize.height);
}

@end
