//
//  ELInProgressTaskController.m
//  tcb
//
//  Created by Chuanxun on 15/11/16.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "ELInProgressTaskController.h"
#import "ELInProgressTask.h"
#import <MJExtension.h>
#import "ShowRobListOrderController.h"
#import "AutoSignInController.h"
#import "InProgressTaskDoubleBoxCell.h"
#import "ELInProgressTask.h"
#import "NSArray+log.h"
#import "ELDispatchOrder.h"
#import "NSString+Extension.h"

typedef NS_ENUM(NSInteger,LOAD_TASK_REASON) {
    KINITIAL_LOAD = 0,
    KREFRESH_HEADER = 1,
    KREFRESH_FOOTER = 2,
};

@interface ELInProgressTaskController ()<InProgressTaskDoubleBoxCellDelegate>

@property (strong, nonatomic) NSMutableArray *tasks;
@property (strong, nonatomic) InProgressTaskDoubleBoxCell *prototypeCell;

@property (strong, nonatomic) UIView *viewForNoData;


@property (strong, nonatomic) UIImage *navigationBarBackgroundImage;
@property (strong, nonatomic) UIImage *navigationBarShadowImage;
@property (strong, nonatomic) UIColor *navigationBarBackgroundColor;
@property (strong, nonatomic) AutoSignInController *signInController;


@property (strong, nonatomic) AllProgressTask *allProgressTasks;

@end

@implementation ELInProgressTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    NSString *strTitle = NSLocalizedString(@"InProgressTask", @"进行中任务");
    self.navigationItem.title =strTitle;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        
        self.tableView.estimatedRowHeight = 100;
    }
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.prototypeCell = [InProgressTaskDoubleBoxCell cellWithTableView:self.tableView];
    self.prototypeCell.autoresizingMask = UIViewAutoresizingFlexibleWidth; // this must be set for the cell heights to be calculated correctly in landscape
    self.prototypeCell.hidden = YES;
    
    [self.tableView addSubview:self.prototypeCell];
    
    self.prototypeCell.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 0);
    
    self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    
    [self pull2Refresh];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


- (void)pull2Refresh
{
    __weak typeof (self) weakSelf = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadTaskData:KREFRESH_HEADER];
    }];
    NSString *strIdle = NSLocalizedString(@"Pull To Refresh Task", @"下拉刷新任务");
    [header setTitle:strIdle forState:MJRefreshStateIdle];
    NSString *strPull = NSLocalizedString(@"Relese To Refresh Now", @"松开立即刷新");
    [header setTitle:strPull forState:MJRefreshStatePulling];
    NSString *strRefreshing = NSLocalizedString(@"Refreshing...", @"正在刷新");
    [header setTitle:strRefreshing forState:MJRefreshStateRefreshing];
    NSString *strNoMoreData = NSLocalizedString(@"No More Data", @"没有更多任务");
    [header setTitle:strNoMoreData forState:MJRefreshStateNoMoreData];
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadTaskData:KREFRESH_FOOTER];
    }];
    footer.automaticallyRefresh = NO;
    strIdle = NSLocalizedString(@"Click or Drag To Refresh Task", @"点击或下拉刷新任务");
    [footer setTitle:strIdle forState:MJRefreshStateIdle];
    [footer setTitle:strPull forState:MJRefreshStatePulling];
    [footer setTitle:strRefreshing forState:MJRefreshStateRefreshing];
    [footer setTitle:strNoMoreData forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allProgressTasks.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InProgressTaskDoubleBoxCell *cell = [InProgressTaskDoubleBoxCell cellWithTableView:tableView];
    cell.task = self.allProgressTasks.list[indexPath.row];
    cell.delegate = self;
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self tableView:tableView heightForRowAtIndexPath:indexPath];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8) {
        self.prototypeCell.task = self.allProgressTasks.list[indexPath.row];
        self.prototypeCell.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 0);
        [self.prototypeCell setNeedsLayout];
        [self.prototypeCell layoutIfNeeded];
        CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height - 36;
        
    }
    
    return UITableViewAutomaticDimension;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma  mark - lazy load

- (void)loadTaskData:(LOAD_TASK_REASON)reason
{
    @synchronized(self) {
//        [NSThread sleepForTimeInterval:5];
//        if (reason != KINITIAL_LOAD) {
//            
//            if (self.tableView.mj_header.isRefreshing) {
//                [self.tableView.mj_header endRefreshing];
//                [self.tableView.mj_footer resetNoMoreData];
//            }else {
//                
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }
        
        if (reason == KREFRESH_FOOTER) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"cmd":CMD_GET_PROGRESS_TASK_LIST}];
        [APIClientTool myOrderListWithParam:params success:^(NSDictionary *dict) {
            NSNumber *ret = [dict valueForKey:@"ret"];
            NSDictionary *data = [dict valueForKey:@"data"];
            if (ret.intValue == 0) {
                self.allProgressTasks = [AllProgressTask mj_objectWithKeyValues:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.self.allProgressTasks.list.count == 0) {
                        
                        [self makePageForNoTask];
                        
                    }else {
                        
                        [self.tableView reloadData];
                    }
                });

            }else {
                [SVProgressHUD showErrorWithStatus:[dict valueForKey:@"msg"]];
            }
            
            if (reason == KREFRESH_HEADER) {
                [self.tableView.mj_header endRefreshing];
            }else if (reason == KREFRESH_FOOTER) {
                [self.tableView.mj_footer endRefreshing];
            }
            
        } failed:^{
            if (reason == KREFRESH_HEADER) {
                [self.tableView.mj_header endRefreshing];
            }else if (reason == KREFRESH_FOOTER) {
                [self.tableView.mj_footer endRefreshing];
            }
            [SVProgressHUD showErrorWithStatus:@"连接网络失败"];
        }];
    }
}

-(NSArray *)tasks
{
    if (!_tasks) {
        _tasks = [NSMutableArray new];
    }
    return _tasks;
}

#pragma mark - Add

- (void)makePageForNoTask
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectInset(self.view.frame, 10, 10)];
    [self.view addSubview:containerView];
    self.viewForNoData = containerView;
    
    UIImage *image = [UIImage imageNamed:@"bg_mail"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView sizeToFit];
    [containerView addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerView.centerX);
        make.top.equalTo(containerView.top).offset(100);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.numberOfLines = 0;
    NSString *strTip1 = NSLocalizedString(@"You have not inprogressing task,", @"您目前没有进行中的任务，");
    label1.text = strTip1;
    [containerView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.numberOfLines = 0;
    NSString *strTip2 = NSLocalizedString(@"Try to click WoYaoJieDan,", @"请点击我要接单查看是否有新的派车单。");
    label2.text = strTip2;
    [containerView addSubview:label2];
    
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerView.centerX);
        make.top.equalTo(imageView.bottom).offset(@12);
    }];
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerView.centerX);
        make.top.equalTo(label1.bottom).offset(@8);
    }];
    
    UIButton *btnGetOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    [containerView addSubview:btnGetOrder];
    UIImage *imageNormal = [UIImage imageNamed:@"btn_bg_blue_normal"];
    UIImage *imagePress = [UIImage imageNamed:@"btn_bg_blue_press"];
    [btnGetOrder setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [btnGetOrder setBackgroundImage:imagePress forState:UIControlStateHighlighted];
    NSString *strGetOrder = NSLocalizedString(@"Get Order", @"我要接单");
    [btnGetOrder setTitle:strGetOrder forState:UIControlStateNormal];
    [btnGetOrder makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerView.centerX);
        make.top.equalTo(label2.bottom).offset(20);
        make.width.equalTo(@120);
        make.height.equalTo(@40);
    }];
    [btnGetOrder addTarget:self action:@selector(goToGetOrder:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Go To Get Order
- (void)goToGetOrder:(UIButton *)sender
{
    ShowRobListOrderController *controller = [ShowRobListOrderController new];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - InProgressTaskDoubleBoxCellDelegate

-(void)cellDetailBtn1Clicked:(InProgressTaskDoubleBoxCell *)cell
{
    TCBLog(@"cellDetailBtn1Clicked");
    
    ELInProgressTask *task = cell.task;
//    NSString *dispCode = task.item[0].DispCode;
    NSMutableArray *dispCodes = [NSMutableArray new];
    NSMutableArray *telephoneNums = [NSMutableArray new];
    for (int i = 0; i < task.item.count; i++) {
        ELInProgressTaskItem *item = task.item[i];
        [dispCodes addObject:item.DispCode];
        [telephoneNums addObject:item.DispatcherMobile];
    }
    AutoSignInController *controller = [[AutoSignInController alloc] initWithDispatchOrderIDs:dispCodes SelectedItemIndex:0 telephoneNums:telephoneNums readonly:NO];
    self.signInController = controller;
//    self.navigationController.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)cellDetailBtn2Clicked:(InProgressTaskDoubleBoxCell *)cell
{
    TCBLog(@"cellDetailBtn2Clicked");
    ELInProgressTask *task = cell.task;
//    NSString *dispCode = task.item[1].DispCode;
    NSMutableArray *dispCodes = [NSMutableArray new];
    NSMutableArray *telephoneNums = [NSMutableArray new];
    for (int i = 0; i < task.item.count; i++) {
        ELInProgressTaskItem *item = task.item[i];
        [dispCodes addObject:item.DispCode];
        [telephoneNums addObject:item.DispatcherMobile];
    }
    AutoSignInController *controller = [[AutoSignInController alloc] initWithDispatchOrderIDs:dispCodes SelectedItemIndex:1 telephoneNums:telephoneNums readonly:NO];
    self.signInController = controller;
//    self.navigationController.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)cellContactBtnClicked:(InProgressTaskDoubleBoxCell *)cell
{
    TCBLog(@"cellContactBtnClicked");
    
    ELInProgressTask *task = cell.task;
    NSString *mobile = task.item[0].DispatcherMobile;
//    UIApplication *app = [UIApplication sharedApplication];
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",mobile];
//    NSURL *url = [NSURL URLWithString:str];
//    if ([app canOpenURL:url]) {
//        [app openURL:url];
//    }
        
    if ([mobile isTelephoneNum]) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",mobile];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
}


@end
