//
//  ShowRobListOrderController.m
//  tcb
//
//  Created by Jax on 15/11/16.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ShowRobListOrderController.h"
#import "ShowRobListOrderCell.h"
#import "RobListOrderController.h"

@interface ShowRobListOrderController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GrabOrder *grabOrder;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ShowRobListOrderController

#pragma mark - 懒加载
- (GrabOrder *)grabOrder {
    if (_grabOrder == nil) {
        _grabOrder = [[GrabOrder alloc] init];
    }
    return _grabOrder;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抢单";
    
    [self configTableView];
    
    self.view.backgroundColor = ThemeColor;
    
}

- (void)configTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GrabOrder *grabOrder = [[GrabOrder alloc] init];
    NSArray *grabList = grabOrder.list;
    
    ShowRobListOrderCell *showRobListOrderCell = [ShowRobListOrderCell cellWithTableView:tableView];
    showRobListOrderCell.grabOrder = grabOrder;
    showRobListOrderCell.grabItemArray = grabList[indexPath.row];
    
    
    return showRobListOrderCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = ThemeColor;
    UILabel *robListForScoreLabel = [[UILabel alloc] init];
    robListForScoreLabel.text = @"参与抢单获积分,积分越多,获得礼品几率越高";
    if (iPhone4 || iPhone5) {
        robListForScoreLabel.font = [UIFont systemFontOfSize:14];
    }
    [headView addSubview:robListForScoreLabel];
    [robListForScoreLabel makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 10, 0, 0));
    }];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
//    return  [ShowRobListOrderCell cellHeightWithItemArray:nil];
    
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RobListOrderController *robListOrderController = [[RobListOrderController alloc] init];
    [self.navigationController pushViewController:robListOrderController animated:YES];
}

@end
