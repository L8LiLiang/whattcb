//
//  CheckListController.m
//  tcb
//
//  Created by Jax on 15/12/4.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "CheckListController.h"
#import "CheckListCell.h"
#import "FeeConfirmModel.h"
#import "FeeConfirmResultModel.h"
#import "FeeDetailController.h"
#import "NSString+Extension.h"



typedef NS_ENUM(NSInteger,CLCRefreshSource) {
    CLCRS_HEADER = 0,
    CLCRS_FOOTER = 1,
};


@interface CheckListController () <UITableViewDelegate, UITableViewDataSource, CheckListCellDelegate>

@property (nonatomic, strong) FeeConfirmModel *feeConfirmModel;
@property (nonatomic, strong) UITableView     *tableView;
@property (nonatomic, strong) NSMutableArray<FeeConfirmList *> *datas;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation CheckListController
#pragma mark - 懒加载
- (FeeConfirmModel *)feeConfirmModel {
    if (_feeConfirmModel == nil) {
        _feeConfirmModel = [[FeeConfirmModel alloc] init];
    }
    return _feeConfirmModel;
}

-(NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [NSMutableArray new];
    }
    return _datas;
}

#pragma mark - view cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBarHidden  = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRGB(235, 234, 234);
    
    //  配置TableView
    [self configTableView];
    self.currentIndex = 1;
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header                    = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewDataWithSource:CLCRS_HEADER];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadNewDataWithSource:CLCRS_FOOTER];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    
}

- (void)configTableView {
    self.tableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 32) style:UITableViewStylePlain];
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
//    FeeConfirmData *feeConfirmData = self.feeConfirmModel.data;
//    NSArray *feeConfirmListArray   = feeConfirmData.list;
//    return feeConfirmListArray.count;
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    FeeConfirmData *feeConfirmData                = self.feeConfirmModel.data;
//    NSArray *feeConfirmListArray                  = feeConfirmData.list;
//    FeeConfirmList *feeConfirmList                = feeConfirmListArray[indexPath.row];
//    NSArray *feeConfirmItemArray                  = feeConfirmList.item;
    
    FeeConfirmList *feeConfirmList                = self.datas[indexPath.row];
    NSArray *feeConfirmItemArray = feeConfirmList.item;
    
    CheckListCell *checkListCell        = [CheckListCell cellWithTableView:tableView];
    checkListCell.feeConfirmItemArray        = feeConfirmItemArray;
    checkListCell.tag                        = indexPath.row;
    checkListCell.checkListCellDelegate = self;
    return checkListCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    FeeConfirmData *feeConfirmData = self.feeConfirmModel.data;
//    NSArray *feeConfirmListArray   = feeConfirmData.list;
//    FeeConfirmList *feeConfirmList = feeConfirmListArray[indexPath.row];
//    NSArray *feeConfirmItemArray   = feeConfirmList.item;
    
    FeeConfirmList *feeConfirmList                = self.datas[indexPath.row];
    NSArray *feeConfirmItemArray = feeConfirmList.item;
    
    return [CheckListCell cellHeightWithFeeConfirmItemArray:feeConfirmItemArray];
}


#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 获取费用确认列表数据
- (void)getFeeConfirmListWithSource:(CLCRefreshSource)source {
    
    NSInteger index;
    @synchronized(self) {
        if (source == CLCRS_FOOTER) {
            index = self.currentIndex++;
        }else {
            index = 1;
            self.currentIndex = 1;
        }
    }
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"GetFeeConfirmList" forKey:@"cmd"];
    NSMutableDictionary *data  = [NSMutableDictionary dictionary];
    [data setValue:@(index) forKey:@"pageIndex"];
    [data setValue:@10 forKey:@"pageSize"];
    [param setValue:data forKey:@"data"];
    
    [SVProgressHUD showWithStatus:@"正在加载费用确认列表" maskType:SVProgressHUDMaskTypeBlack];
    [APIClientTool GetFeeConfirmListWithParam:param success:^(NSDictionary *dict) {
        FeeConfirmModel *feeConfirmModel = [FeeConfirmModel mj_objectWithKeyValues:dict];
        if (feeConfirmModel.ret == 0) {
            [SVProgressHUD dismiss];
            self.feeConfirmModel = feeConfirmModel;
            FeeConfirmData *feeConfirmData                = self.feeConfirmModel.data;
            NSArray *feeConfirmListArray                  = feeConfirmData.list;
            
            if (source == CLCRS_FOOTER) {
                [self.datas addObjectsFromArray:feeConfirmListArray];
//                for (int i = 0; i < feeConfirmListArray.count; i ++) {
//                    FeeConfirmList *feeConfirmList                = feeConfirmListArray[i];
//                    NSArray *feeConfirmItemArray                  = feeConfirmList.item;
//                    [self.datas addObject:feeConfirmItemArray];
//                }
            }else {
//                self.datas = [NSMutableArray new];
//                for (int i = 0; i < feeConfirmListArray.count; i ++) {
//                    FeeConfirmList *feeConfirmList                = feeConfirmListArray[i];
//                    NSArray *feeConfirmItemArray                  = feeConfirmList.item;
//                    [self.datas addObject:feeConfirmItemArray];
//                }
                self.datas = [NSMutableArray arrayWithArray:feeConfirmListArray.copy];
            }

            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            if (source == CLCRS_HEADER) {
                [self.tableView.mj_header endRefreshing];
            }else if (source == CLCRS_FOOTER && feeConfirmListArray.count != 0) {
                [self.tableView.mj_footer endRefreshing];
            }else if (source == CLCRS_FOOTER && feeConfirmListArray.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            if (source == CLCRS_HEADER) {
                [self.tableView.mj_header endRefreshing];
            }else if (source == CLCRS_FOOTER ) {
                [self.tableView.mj_footer endRefreshing];
            }
            [SVProgressHUD showErrorWithStatus:feeConfirmModel.msg];
        }
        
    } failed:^{
        [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
        [self.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark - ListMoreOrderCellDelegate
#pragma mark  跳转到费用详情界面
- (void)nextViewOnTap:(UITapGestureRecognizer *)tap {
    NSInteger seletedRow                     = tap.view.tag;
//    FeeConfirmData *feeConfirmData           = self.feeConfirmModel.data;
//    NSArray *feeConfirmListArray             = feeConfirmData.list;
//    FeeConfirmList *feeConfirmList           = feeConfirmListArray[seletedRow];
//    NSArray *feeConfirmItemArray             = feeConfirmList.item;
    
    FeeConfirmList *feeConfirmList                = self.datas[seletedRow];
    NSArray *feeConfirmItemArray = feeConfirmList.item;
    
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
    feeDetailController.dispCode             = dispCode;
    feeDetailController.phoneNumberArray     = array0;
    feeDetailController.dispCodeArray        = array1;
    feeDetailController.sourceType = SourceTypeCheck;
    [self.navigationController pushViewController:feeDetailController animated:YES];
    
}
#pragma mark  费用确认
- (void)feeConfirm:(UIButton *)sender {
    
    NSInteger seletedRow           = sender.tag;
//    FeeConfirmData *feeConfirmData = self.feeConfirmModel.data;
//    NSArray *feeConfirmListArray   = feeConfirmData.list;
//    FeeConfirmList *feeConfirmList = feeConfirmListArray[seletedRow];
//    NSArray *feeConfirmItemArray   = feeConfirmList.item;
    
    FeeConfirmList *feeConfirmList                = self.datas[seletedRow];
    NSArray *feeConfirmItemArray = feeConfirmList.item;
    
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

- (void)contactFleet:(UIButton *)sender
{
    NSInteger seletedRow           = sender.tag;
//    FeeConfirmData *feeConfirmData = self.feeConfirmModel.data;
//    NSArray *feeConfirmListArray   = feeConfirmData.list;
//    FeeConfirmList *feeConfirmList = feeConfirmListArray[seletedRow];
//    NSArray *feeConfirmItemArray   = feeConfirmList.item;
    
    FeeConfirmList *feeConfirmList                = self.datas[seletedRow];
    NSArray *feeConfirmItemArray = feeConfirmList.item;
    
    FeeConfirmItem *feeConfirmItem = [feeConfirmItemArray firstObject];
    NSString *tel             = feeConfirmItem.DispatcherMobile;
    
    if ([tel isTelephoneNum]) {
        NSString *telephone = [NSString stringWithFormat:@"tel:%@",tel];
        UIWebView *webView = [[UIWebView alloc] init];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telephone]]];
        [self.view addSubview:webView];
    }    
}

#pragma mark - 下拉刷新数据
- (void)loadNewDataWithSource:(CLCRefreshSource)source {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getFeeConfirmListWithSource:source];
    });
}

@end

