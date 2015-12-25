//
//  ListMoreOrderController.m
//  tcb
//
//  Created by Jax on 15/11/16.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ListMoreOrderController.h"

#import "ListMoreOrderCell.h"
#import "SendCarList.h"

#import "ShowRobListOrderController.h"

#import "ListSingleOrderController.h"
#import "OrderDetail.h"




@interface ListMoreOrderController ()<UITableViewDelegate, UITableViewDataSource, ListMoreOrderCellDelegate>

/**
 *  派车单模型
 */
@property (nonatomic, strong) SendCarList *sendCarList;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ListMoreOrderController

#pragma mark - 懒加载
- (SendCarList *)sendCarList {
    if (_sendCarList == nil) {
        _sendCarList = [[SendCarList alloc] init];
    }
    return _sendCarList;
}

#pragma mark - 视图生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我要接单";
    
    //  配置TableView
    [self configTableView];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];

    
}

- (void)configTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = ThemeColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.imageView.image = [UIImage imageNamed:@"ic_sound"];
        NSInteger grabOrderCount = self.sendCarList.grabOrderCount;
        NSString *msgString = [NSString stringWithFormat:@"您有%zd个派车任务可抢", grabOrderCount];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:msgString];
        NSMutableDictionary *attributeDict = [NSMutableDictionary dictionary];
        [attributeDict setValue:[UIColor orangeColor] forKeyPath:NSForegroundColorAttributeName];
        NSRange range = [msgString rangeOfString:[NSString stringWithFormat:@"%zd", grabOrderCount]];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
        cell.textLabel.attributedText = attributeString;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else {
        NSArray *list = self.sendCarList.list;
        NSArray *itemArray = list[indexPath.row - 1];
        ListMoreOrderCell *listMoreOrderCell = [ListMoreOrderCell cellWithTableView:tableView];
        listMoreOrderCell.sendCarList = self.sendCarList;
        listMoreOrderCell.itemArray = itemArray;
        listMoreOrderCell.listMoreOrderCellDelegate = self;
        listMoreOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return listMoreOrderCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSArray *list = self.sendCarList.list;
//    NSArray *itemArray = list[indexPath.row - 1];
//    [ListMoreOrderCell cellHeightWithItemArray:itemArray];

    if (indexPath.row == 0) {
        return 60;
    } else {
        return 310;
    }
}


#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //  抢单界面
        ShowRobListOrderController *showRobListOrderController = [[ShowRobListOrderController alloc] init];
        [self.navigationController pushViewController:showRobListOrderController animated:YES];
    }
}

#pragma mark - 跳转订单详情页
- (void)nextViewOnTap:(UITapGestureRecognizer *)tap {
    
    //  这个界面是可以获取派单号的DispCode == 订单详情（下个页面获取数据展示）
    OrderDetail *orderDetail = [[OrderDetail alloc] init];
    ListSingleOrderController *listSingleOrderController = [[ListSingleOrderController alloc] init];
    listSingleOrderController.orderDetail = orderDetail;
    [self.navigationController pushViewController:listSingleOrderController animated:YES];
}

#pragma mark - 下拉刷新数据
- (void)loadNewData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    });
}

@end
