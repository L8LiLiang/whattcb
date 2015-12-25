//
//  FeeConfirmList.m
//  tcb
//
//  Created by Jax on 15/11/27.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "FeeConfirmListController.h"
#import "FeeConfirmListCell.h"
#import "FeeConfirmModel.h"
#import "FeeConfirmResultModel.h"
#import "FeeDetailController.h"

static NSInteger pageNum = 1;

@interface FeeConfirmListController () <UITableViewDelegate, UITableViewDataSource, FeeConfirmListCellDelegate>

@property (nonatomic, strong) FeeConfirmModel *feeConfirmModel;
@property (nonatomic, strong) UITableView     *tableView;

@end

@implementation FeeConfirmListController
#pragma mark - 懒加载
- (FeeConfirmModel *)feeConfirmModel {
    if (_feeConfirmModel == nil) {
        _feeConfirmModel = [[FeeConfirmModel alloc] init];
    }
    return _feeConfirmModel;
}

#pragma mark - view cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBarHidden  = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title                                  = @"费用确认";

    //  配置TableView
    [self configTableView];

    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header                    = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    
}

- (void)configTableView {
    self.tableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.edgesForExtendedLayout    = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource      = self;
    self.tableView.delegate        = self;
    self.tableView.backgroundColor = ThemeColor;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FeeConfirmData *feeConfirmData = self.feeConfirmModel.data;
    NSArray *feeConfirmListArray   = feeConfirmData.list;
    return feeConfirmListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FeeConfirmData *feeConfirmData                = self.feeConfirmModel.data;
    NSArray *feeConfirmListArray                  = feeConfirmData.list;
    FeeConfirmList *feeConfirmList                = feeConfirmListArray[indexPath.row];
    NSArray *feeConfirmItemArray                  = feeConfirmList.item;

    FeeConfirmListCell *feeConfirmListCell        = [FeeConfirmListCell cellWithTableView:tableView];
     feeConfirmListCell.tag                        = indexPath.row;
    feeConfirmListCell.feeConfirmItemArray        = feeConfirmItemArray;
   
    feeConfirmListCell.feeConfirmListCellDelegate = self;
    return feeConfirmListCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeeConfirmData *feeConfirmData = self.feeConfirmModel.data;
    NSArray *feeConfirmListArray   = feeConfirmData.list;
    FeeConfirmList *feeConfirmList = feeConfirmListArray[indexPath.row];
    NSArray *feeConfirmItemArray   = feeConfirmList.item;
    return [FeeConfirmListCell cellHeightWithFeeConfirmItemArray:feeConfirmItemArray];
}


#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 获取费用确认列表数据
- (void)getFeeConfirmList {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"GetFeeConfirmList" forKey:@"cmd"];
    NSMutableDictionary *data  = [NSMutableDictionary dictionary];
    [data setValue:@1 forKey:@"pageIndex"];
    [data setValue:@10 forKey:@"pageSize"];
    [param setValue:data forKey:@"data"];
    
    [SVProgressHUD showWithStatus:@"正在加载费用确认列表" maskType:SVProgressHUDMaskTypeBlack];
    [APIClientTool GetFeeConfirmListWithParam:param success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        NSLog(@"%@", dict);
        FeeConfirmModel *feeConfirmModel = [FeeConfirmModel mj_objectWithKeyValues:dict];
        if (feeConfirmModel.ret == 0) {
            self.feeConfirmModel = feeConfirmModel;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_header endRefreshing];
            [SVProgressHUD showErrorWithStatus:feeConfirmModel.msg];
        }
        
    } failed:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
        [self.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark - ListMoreOrderCellDelegate
#pragma mark  跳转到费用详情界面
- (void)nextViewOnTap:(UITapGestureRecognizer *)tap {
    NSInteger seletedRow                     = tap.view.tag;
    FeeConfirmData *feeConfirmData           = self.feeConfirmModel.data;
    NSArray *feeConfirmListArray             = feeConfirmData.list;
    FeeConfirmList *feeConfirmList           = feeConfirmListArray[seletedRow];
    NSArray *feeConfirmItemArray             = feeConfirmList.item;
    FeeConfirmItem *feeConfirmItem           = [feeConfirmItemArray firstObject];
    NSString *dispCode                       = feeConfirmItem.DispCode;
    NSMutableArray *array0                   = [NSMutableArray array];
    NSMutableArray *array1                   = [NSMutableArray array];
    for (int i                               = 0; i < feeConfirmItemArray.count; i ++) {
    FeeConfirmItem *feeConfirmItem           = feeConfirmItemArray[i];
        [array0 addObject:feeConfirmItem.DispatcherMobile];
        [array1 addObject:feeConfirmItem.DispCode];
    }
    FeeDetailController *feeDetailController = [[FeeDetailController alloc] init];
    feeDetailController.sourceType = SourceTypeFeeConfirmList;
    feeDetailController.dispCode             = dispCode;
    feeDetailController.phoneNumberArray     = array0;
    feeDetailController.dispCodeArray        = array1;
    [self.navigationController pushViewController:feeDetailController animated:YES];
    
}
#pragma mark  费用确认
- (void)feeConfirm:(UIButton *)sender {
    
    NSInteger seletedRow           = sender.tag;
    FeeConfirmData *feeConfirmData = self.feeConfirmModel.data;
    NSArray *feeConfirmListArray   = feeConfirmData.list;
    FeeConfirmList *feeConfirmList = feeConfirmListArray[seletedRow];
    NSArray *feeConfirmItemArray   = feeConfirmList.item;
    FeeConfirmItem *feeConfirmItem = [feeConfirmItemArray firstObject];
    NSString *dispCode             = feeConfirmItem.DispCode;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [param setValue:@"ConductAboutDispatch" forKey:@"cmd"];
    [data setValue:dispCode forKey:@"dispCode"];
    //  费用确认:2, 费用退返:0
    [data setValue:@2 forKey:@"data"];
    
    [SVProgressHUD showWithStatus:@"费用确认中" maskType:SVProgressHUDMaskTypeBlack];
    [APIClientTool ConductAboutDispatchWithParam:param success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        FeeConfirmResultModel *feeConfirmResultModel = [[FeeConfirmResultModel alloc] init];
        if (feeConfirmResultModel.ret == 0) {
            [SVProgressHUD showSuccessWithStatus:feeConfirmResultModel.msg];
        } else {
            [SVProgressHUD showErrorWithStatus:feeConfirmResultModel.msg];
        }
    } failed:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
    
}


#pragma mark - 下拉刷新数据
- (void)loadNewData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getFeeConfirmList];
    });
}

- (void)loadMoreData {
    pageNum ++;
    [self getMoreFeeConfirmList];
}

- (void)getMoreFeeConfirmList {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"GetFeeConfirmList" forKey:@"cmd"];
    NSMutableDictionary *data  = [NSMutableDictionary dictionary];
    [data setValue:[NSNumber numberWithInteger:pageNum] forKey:@"pageIndex"];
    [data setValue:@10 forKey:@"pageSize"];
    [param setValue:data forKey:@"data"];
    
    [SVProgressHUD showWithStatus:@"加载更多费用确认列表中" maskType:SVProgressHUDMaskTypeBlack];
    [APIClientTool GetFeeConfirmListWithParam:param success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        FeeConfirmModel *feeConfirmModel = [FeeConfirmModel mj_objectWithKeyValues:dict];
        if (feeConfirmModel.ret == 0) {
             NSArray *list =  feeConfirmModel.data.list;
            if (list.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"没有更多数据可加载"];
                return  ;
            }
            
            NSMutableArray *mutabList = [self.feeConfirmModel.data.list mutableCopy];
            NSArray *moreList = [mutabList arrayByAddingObjectsFromArray:list];
            self.feeConfirmModel.data.list = moreList;
            
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_header endRefreshing];
            [SVProgressHUD showErrorWithStatus:feeConfirmModel.msg];
        }
        
    } failed:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

@end

