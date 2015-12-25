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
#import "InProgressTaskCell.h"
#import "ShowRobListOrderController.h"
#import "AutoSignInController.h"
#import "InProgressTaskDoubleBoxCell.h"



typedef NS_ENUM(NSInteger,LOAD_TASK_REASON) {
    KINITIAL_LOAD = 0,
    KREFRESH_HEADER = 1,
    KREFRESH_FOOTER = 2,
};

@interface ELInProgressTaskController ()<InProgressTaskCellDelegate,UINavigationControllerDelegate,InProgressTaskDoubleBoxCellDelegate>

@property (strong, nonatomic) NSMutableArray *tasks;
@property (strong, nonatomic) InProgressTaskDoubleBoxCell *prototypeCell;

@property (strong, nonatomic) UIView *viewForNoData;


@property (strong, nonatomic) UIImage *navigationBarBackgroundImage;
@property (strong, nonatomic) UIImage *navigationBarShadowImage;
@property (strong, nonatomic) UIColor *navigationBarBackgroundColor;
@property (weak, nonatomic) AutoSignInController *signInController;

@end

@implementation ELInProgressTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    NSString *strTitle = NSLocalizedString(@"InProgressTask", @"进行中任务");
    self.navigationItem.title =strTitle;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.estimatedRowHeight = 220;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.prototypeCell = [InProgressTaskDoubleBoxCell cellWithTableView:self.tableView];
    self.prototypeCell.autoresizingMask = UIViewAutoresizingFlexibleWidth; // this must be set for the cell heights to be calculated correctly in landscape
    self.prototypeCell.hidden = YES;
    
    [self.tableView addSubview:self.prototypeCell];
    
    self.prototypeCell.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 0);
    
    self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    
    [self pull2Refresh];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}


- (void)pull2Refresh
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadTaskData:KREFRESH_HEADER];
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
        [self loadTaskData:KREFRESH_FOOTER];
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
    return self.tasks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InProgressTaskDoubleBoxCell *cell = [InProgressTaskDoubleBoxCell cellWithTableView:tableView];
    cell.task = self.tasks[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.prototypeCell.task = self.tasks[indexPath.row];
//    [self.prototypeCell updateConstraintsIfNeeded];
//    [self.prototypeCell layoutIfNeeded];
//    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    NSLog(@"%@",NSStringFromCGSize(size));
//    return size.height + 1;
    
    return [self.prototypeCell rowHeight];
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
        if (reason != KINITIAL_LOAD) {
            
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer resetNoMoreData];
            }else {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        NSString *jsonDataFilePath = [[NSBundle mainBundle] pathForResource:@"InProgressTaskTestData" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:jsonDataFilePath];
        NSError *error;
        NSArray *dictArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (!error) {
            [dictArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ELInProgressTask *task = [ELInProgressTask mj_objectWithKeyValues:obj];
                [self.tasks addObject:task];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.tasks.count == 0) {
                    
                    [self makePageForNoTask];
                    
                }else {
                    
                    [self.tableView reloadData];
                }
            });
            //TCBLog(@"%@",self.tasks);
        }else
        {
            TCBLog(@"load data error:%@",error);
        }
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
    
    UIImage *image = [UIImage imageNamed:@"myStatus"];
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

#pragma mark - InProgressTaskCellDelegate
-(void)inProgressTaskCellClickContactButton:(InProgressTaskCell *)cell
{
    TCBLog(@"inProgressTaskCellClickContactButton");
}

-(void)inProgressTaskCellClickDetailButton:(InProgressTaskCell *)cell
{
    TCBLog(@"inProgressTaskCellClickDetailButton");
    AutoSignInController *controller = [AutoSignInController new];
    self.signInController = controller;
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - InProgressTaskDoubleBoxCellDelegate

-(void)cellDetailBtn1Clicked:(InProgressTaskDoubleBoxCell *)cell
{
    TCBLog(@"cellDetailBtn1Clicked");
    AutoSignInController *controller = [AutoSignInController new];
    self.signInController = controller;
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)cellDetailBtn2Clicked:(InProgressTaskDoubleBoxCell *)cell
{
    TCBLog(@"cellDetailBtn2Clicked");
    AutoSignInController *controller = [AutoSignInController new];
    self.signInController = controller;
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)cellContactBtnClicked:(InProgressTaskDoubleBoxCell *)cell
{
    TCBLog(@"cellContactBtnClicked");

}

#pragma mark - UINavigationControllerDelegate

//-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (viewController == self.signInController) {
//        self.navigationBarBackgroundImage = [navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
//        self.navigationBarShadowImage = [navigationController.navigationBar shadowImage];
//        self.navigationBarBackgroundColor = navigationController.navigationBar.backgroundColor;
//        
//        [navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//        [navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
//        
//        UIColor *color = [UIColor colorWithRed:18/255.0 green:141/255.0 blue:255/255.0 alpha:1];
//        navigationController.navigationBar.backgroundColor = color;
//        
//    }else {
//        [navigationController.navigationBar setBackgroundImage:self.navigationBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
//        [navigationController.navigationBar setShadowImage:self.navigationBarShadowImage];
//        navigationController.navigationBar.backgroundColor = self.navigationBarBackgroundColor;
//    }
//}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.signInController) {
        navigationController.navigationBar.hidden = YES;
    }else {
        navigationController.navigationBar.hidden = NO;
    }
}

@end
