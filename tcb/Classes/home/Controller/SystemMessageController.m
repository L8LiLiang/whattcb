//
//  SystemMessageController.m
//  tcb
//
//  Created by Jax on 15/12/11.
//  Copyright © 2015年 Jax. All rights reserved.
//
#import "SystemMessageController.h"
#import "SystemMsgModel.h"
#import "FleetMsgCell.h"

@interface SystemMessageController ()

@property (nonatomic, strong) SystemMsgModel *systemMsgModel;

@end

@implementation SystemMessageController

- (SystemMsgModel *)systemMsgModel {
    if (_systemMsgModel == nil) {
        _systemMsgModel = [[SystemMsgModel alloc] init];
    }
    return _systemMsgModel;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kRGB(245, 245, 245);
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header                    = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    
    
    
}
- (void)loadNewData {
    [self getSystemMessage];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SystemMsgData *systemMsgData = self.systemMsgModel.data;
    return systemMsgData.list.count;
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FleetMsgCell *fleetMsgCell = [FleetMsgCell cellWithTableView:tableView];
    
    SystemMsgData *systemMsgData = self.systemMsgModel.data;
    NSArray *list = systemMsgData.list;
    SystemMsg *systemMsg = list[indexPath.row];
    fleetMsgCell.systemMsg = systemMsg;
    
    return fleetMsgCell;
    return nil;
}

- (void)getSystemMessage {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GetSystemMsgList" forKey:@"cmd"];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setValue:@1 forKey:@"pageIndex"];
    [data setValue:@10 forKey:@"pageSize"];
    [params setValue:data forKey:@"data"];
    [SVProgressHUD showWithStatus:@"系统通知获取中" maskType:SVProgressHUDMaskTypeBlack];
    [APIClientTool GetSystemMsgListWithParam:params success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        SystemMsgModel *systemMsgModel = [SystemMsgModel mj_objectWithKeyValues:dict];
        if (systemMsgModel.ret == 0) {
            self.systemMsgModel = systemMsgModel;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } else {
            [SVProgressHUD showErrorWithStatus:systemMsgModel.msg];
            [self.tableView.mj_header endRefreshing];
        }
    } failed:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
        [self.tableView.mj_header endRefreshing];
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end