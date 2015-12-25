//
//  FleetMessageController.m
//  tcb
//
//  Created by Jax on 15/12/11.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "FleetMessageController.h"
#import "FleetMessageModel.h"
#import "FleetMsgCell.h"
#import "FleetMsgDetailController.h"

@interface FleetMessageController ()

@property (nonatomic, strong) FleetMessageModel *fleetMessageModel;

@end

@implementation FleetMessageController

- (FleetMessageModel *)fleetMessageModel {
    if (_fleetMessageModel == nil) {
        _fleetMessageModel = [[FleetMessageModel alloc] init];
    }
    return _fleetMessageModel;
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
    [self getFleetMessage];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FleetMessageList *fleetMessageList = self.fleetMessageModel.data;
    return fleetMessageList.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FleetMsgCell *fleetMsgCell = [FleetMsgCell cellWithTableView:tableView];
    
    FleetMessageList *fleetMessageList = self.fleetMessageModel.data;
    NSArray *list = fleetMessageList.list;
    
    FleetMessage *fleetMsg = list[indexPath.row];
    fleetMsgCell.fleetMessage = fleetMsg;
    
    return fleetMsgCell;
}



- (void)getFleetMessage {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GetTruckMsgList" forKey:@"cmd"];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setValue:@1 forKey:@"pageIndex"];
    [data setValue:@5 forKey:@"pageSize"];
    [params setValue:data forKey:@"data"];
    [SVProgressHUD showWithStatus:@"车队信息获取中" maskType:SVProgressHUDMaskTypeBlack];
    [APIClientTool GetTruckMsgListWithParam:params success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        FleetMessageModel *fleetMessageModel = [FleetMessageModel mj_objectWithKeyValues:dict];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"JSONString === %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
        if (fleetMessageModel.ret == 0) {
            self.fleetMessageModel = fleetMessageModel;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } else {
            [SVProgressHUD showErrorWithStatus:fleetMessageModel.msg];
            [self.tableView.mj_header endRefreshing];
        }
        
        
    } failed:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FleetMessageList *fleetMessageList = self.fleetMessageModel.data;
    NSArray *list = fleetMessageList.list;
    FleetMessage *fleetMsg = list[indexPath.row];
    
    FleetMsgDetailController *fleetMsgDetailController = [[FleetMsgDetailController alloc] init];
    fleetMsgDetailController.Id = fleetMsg.Id;
    fleetMsgDetailController.company = fleetMsg.Company;
    [self.navigationController pushViewController:fleetMsgDetailController animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

@end
