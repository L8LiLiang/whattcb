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
#import "GrabOrderDetail.h"

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self configTableView];
    
    self.view.backgroundColor = ThemeColor;
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抢单";
}

- (void)configTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
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
    return self.grabOrder.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *grabList = self.grabOrder.list;
    ShowRobListOrderCell *showRobListOrderCell = [ShowRobListOrderCell cellWithTableView:tableView];
    showRobListOrderCell.grabOrder = self.grabOrder;
    showRobListOrderCell.grabList = grabList[indexPath.row];
    showRobListOrderCell.grabItemArray = [grabList[indexPath.row] items];
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
    return  [ShowRobListOrderCell cellHeightWithItemArray:[self.grabOrder.list[indexPath.row] items]];
    
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *grabList = self.grabOrder.list;
    GrabList *list = grabList[indexPath.row];
    NSArray *items = list.items;
    NSString *grabCode = [items[0] GrabCode];
    
    [SVProgressHUD showWithStatus:@"加载抢单详情中" maskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *parma = [NSMutableDictionary dictionary];
    [parma setValue:@"GrabDetail" forKey:@"cmd"];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
   [data setValue:grabCode forKey:@"GrabCode"];
    [parma setValue:data forKey:@"data"];
    [APIClientTool GrabListDetailWithParam:parma success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"加载抢单详情中 === %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
        
        NSNumber *ret = [dict objectForKey:@"ret"];
        NSString *msg = [dict objectForKey:@"msg"];
        NSDictionary *data = [dict objectForKey:@"data"];
        
        if ([ret integerValue] == 0) {
            GrabOrderDetail *grabOrderDetail = [GrabOrderDetail mj_objectWithKeyValues:data];
            RobListOrderController *robListOrderController = [[RobListOrderController alloc] init];
            robListOrderController.grabOrderDetail = grabOrderDetail;
            [self.navigationController pushViewController:robListOrderController animated:YES];
            
        } else {
            [SVProgressHUD showErrorWithStatus:msg];
        }

    } failed:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络接连失败"];
    }];
}

#pragma mark - 下拉刷新数据
- (void)loadNewData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self wantGrabList];
    });
}

#pragma mark - 
- (void)wantGrabList {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"GetGrabOrders" forKey:@"cmd"];
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    [dataParam setValue:@1 forKey:@"pageIndex"];
    [dataParam setValue:@10 forKey:@"pageSize"];
    [param setValue:dataParam forKey:@"data"];
    
    [APIClientTool GrabListWithParam:param success:^(NSDictionary *dict) {
        
        NSNumber *ret = [dict objectForKey:@"ret"];
        NSString *msg = [dict objectForKey:@"msg"];
        NSDictionary *data = [dict objectForKey:@"data"];
        
        if ([ret integerValue] == 0) {
            
            self.grabOrder = [GrabOrder mj_objectWithKeyValues:data];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        
            
        } else {
            [SVProgressHUD showErrorWithStatus:msg];
            [self.tableView.mj_header endRefreshing];
        }

    } failed:^{
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
        [self.tableView.mj_header endRefreshing];
    }];

}


@end
