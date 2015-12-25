//
//  CheckMonthController.m
//  tcb
//
//  Created by Chuanxun on 15/12/3.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "CheckMonthController.h"
#import "CheckMonthCell.h"
#import "ELMonthReconciliationList.h"
#import "CheckMonthDetailController.h"
#import "ELProposeConfirmManager.h"
#import "NSString+Extension.h"

typedef NS_ENUM(NSInteger,CheckTableViewRefreshSource) {
    KREFRESH_HEADER = 1,
    KREFRESH_FOOTER = 2
};

typedef NS_ENUM(NSInteger,CheckTableViewRole) {
    KDriver = 1,
    KFleet = 2
};

@interface CheckMonthController () <CheckMonthCellDelegate>

@property (strong, nonatomic) ELMonthReconciliationList *list;

@property (assign, nonatomic) NSInteger currentIndex;

@property (strong, nonatomic) NSMutableArray<ELMonthReconciliation *> *datas;

@end

static NSString *reuse_id = @"CheckMonthCell";


@implementation CheckMonthController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"CheckMonthCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuse_id];
    
    self.tableView.rowHeight = [CheckMonthCell cellHeight];
    
    //little gray
    self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.currentIndex = 1;
    
    [self pull2Refresh];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self.tableView.mj_header beginRefreshing];
}

- (void)pull2Refresh
{
    __weak typeof (self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData:KREFRESH_HEADER pageIndex:1 role:KDriver];
    }];
    NSString *strIdle = NSLocalizedString(@"Pull To Refresh", @"下拉刷新账单");
    [header setTitle:strIdle forState:MJRefreshStateIdle];
    NSString *strPull = NSLocalizedString(@"Relese To Refresh Now", @"松开立即刷新");
    [header setTitle:strPull forState:MJRefreshStatePulling];
    NSString *strRefreshing = NSLocalizedString(@"Refreshing...", @"正在刷新");
    [header setTitle:strRefreshing forState:MJRefreshStateRefreshing];
    NSString *strNoMoreData = NSLocalizedString(@"No More Data", @"没有更多账单");
    [header setTitle:strNoMoreData forState:MJRefreshStateNoMoreData];
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadData:KREFRESH_FOOTER pageIndex:1 role:KDriver];
    }];
    footer.automaticallyRefresh = NO;
    strIdle = NSLocalizedString(@"Click or Drag To Refresh Task", @"点击或下拉刷新");
    [footer setTitle:strIdle forState:MJRefreshStateIdle];
    [footer setTitle:strPull forState:MJRefreshStatePulling];
    [footer setTitle:strRefreshing forState:MJRefreshStateRefreshing];
    [footer setTitle:strNoMoreData forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
}


- (void)loadData:(CheckTableViewRefreshSource)source pageIndex:(NSInteger)index role:(CheckTableViewRole)role
{
    
    NSInteger pageIndex;

    @synchronized(self) {
        
        if (source == KREFRESH_FOOTER) {
            pageIndex = self.currentIndex++;
        }else {
            pageIndex = 1;
            self.currentIndex = 1;
        }
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"cmd":@"GetReconciliationList",@"data":@{@"pageIndex":@(pageIndex),@"role":[NSNumber numberWithInteger:role]}}];
    [APIClientTool getReconciliationListWithParam:params success:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        NSNumber *ret = [dict valueForKey:@"ret"];
        NSDictionary *data = [dict valueForKey:@"data"];
        if (ret.intValue == 0) {
            @synchronized(self) {
                self.list = [ELMonthReconciliationList mj_objectWithKeyValues:data];
                if (source == KREFRESH_FOOTER) {
                    [self.datas addObjectsFromArray:self.list.list];
                }else {
                    self.datas = [NSMutableArray arrayWithArray:self.list.list.copy];
                }
            }
            
        }else {
            [SVProgressHUD showErrorWithStatus:[dict valueForKey:@"msg"]];
        }
        
        if (ret.intValue == 0) {
            [self.tableView reloadData];
        }
        
        if (source == KREFRESH_HEADER) {
            [self.tableView.mj_header endRefreshing];
        }else if (source == KREFRESH_FOOTER && self.list.list.count != 0) {
            [self.tableView.mj_footer endRefreshing];
        }else if (source == KREFRESH_FOOTER && self.list.list.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failed:^{
        if (source == KREFRESH_HEADER) {
            [self.tableView.mj_header endRefreshing];
        }else if (source == KREFRESH_FOOTER) {
            [self.tableView.mj_footer endRefreshing];
        }
        [SVProgressHUD showErrorWithStatus:@"连接网络失败"];
    }];

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @synchronized(self) {
        
        return self.datas.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @synchronized(self) {
        CheckMonthCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_id forIndexPath:indexPath];
        
        cell.reconciliation = self.datas[indexPath.row];
        cell.delegate = self;
        
        return cell;
    }

}


#pragma mark - CheckMonthCellDelegate
-(void)checkMonthCellDeatilButtonClicked:(CheckMonthCell *)cell
{
    ELMonthReconciliation *rec = cell.reconciliation;
    
    CheckMonthDetailController *vc = [[CheckMonthDetailController alloc] initWithCheckNo:rec.CheckNo checkStatus:rec.statementStatus title:rec.statementName];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)checkMonthCellTelephone:(CheckMonthCell *)cell
{
    ELMonthReconciliation *rec = cell.reconciliation;
    
    if ([rec.Tel isTelephoneNum]) {
        NSString *str = [NSString stringWithFormat:@"tel:%@",rec.Tel];
        UIWebView *webView = [[UIWebView alloc] init];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:webView];
    }
}

-(void)checkMonthCellConfirm:(CheckMonthCell *)cell
{
    NSString *checkNo = cell.reconciliation.CheckNo.copy;
    void(^block)() = ^{
        NSDictionary *dict = @{@"cmd":@"ConfirmReconciliation",@"data":@{@"checkNo":checkNo}};
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        [SVProgressHUD showWithStatus:@"正在确认对账"];
        [APIClientTool confirmReconciliationWithParam:param success:^(NSDictionary *dict) {
            
            int ret = [[dict valueForKey:@"ret"] intValue];
            if (ret == 0) {
                [SVProgressHUD showSuccessWithStatus:@"确认对账成功"];
            }else {
                [SVProgressHUD showErrorWithStatus:[dict valueForKey:@"msg"]];
            }
            
        } failed:^{
            [SVProgressHUD showErrorWithStatus:@"网络异常，确认对账失败"];
        }];
        
    };
    
    ELProposeConfirmManager *manager = [ELProposeConfirmManager sharedManager];
    [manager proposeWithControllser:self title:@"确认对账？" msg:@[@"确认对账"] blocks:@[block]];
}

-(void)checkMonthCellConfirmAccount:(CheckMonthCell *)cell
{
    NSString *checkNo = cell.reconciliation.CheckNo.copy;
    void(^block)() = ^{
        NSDictionary *dict = @{@"cmd":@"ConfirmAccount",@"data":@{@"checkNo":checkNo}};
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        [SVProgressHUD showWithStatus:@"正在确认收款"];
        [APIClientTool confirmAccountWithParam:param success:^(NSDictionary *dict) {
            
            int ret = [[dict valueForKey:@"ret"] intValue];
            if (ret == 0) {
                [SVProgressHUD showSuccessWithStatus:@"确认收款成功"];
            }else {
                [SVProgressHUD showErrorWithStatus:[dict valueForKey:@"msg"]];
            }
            
        } failed:^{
            [SVProgressHUD showErrorWithStatus:@"网络异常，确认收款失败"];
        }];
    };
    
    ELProposeConfirmManager *manager = [ELProposeConfirmManager sharedManager];
    [manager proposeWithControllser:self title:@"确认收款？" msg:@[@"确认收款"] blocks:@[block]];
}

-(void)checkMonthReturnBack:(CheckMonthCell *)cell
{
    NSString *checkNo = cell.reconciliation.CheckNo.copy;
    void(^block)() = ^{
        NSDictionary *dict = @{@"cmd":@"BackReconciliation",@"data":@{@"checkNo":checkNo}};
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        [SVProgressHUD showWithStatus:@"正在退返"];
        [APIClientTool backReconciliationWithParam:param success:^(NSDictionary *dict) {
            
            int ret = [[dict valueForKey:@"ret"] intValue];
            if (ret == 0) {
                [SVProgressHUD showSuccessWithStatus:@"退返成功"];
            }else {
                [SVProgressHUD showErrorWithStatus:[dict valueForKey:@"msg"]];
            }
            
        } failed:^{
            [SVProgressHUD showErrorWithStatus:@"网络异常，退返失败"];
        }];
    };
    
    ELProposeConfirmManager *manager = [ELProposeConfirmManager sharedManager];
    [manager proposeWithControllser:self title:@"退返？" msg:@[@"退返"] blocks:@[block]];
}

#pragma  mark - lazy load
-(NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [NSMutableArray new];
    }
    return _datas;
}


@end
