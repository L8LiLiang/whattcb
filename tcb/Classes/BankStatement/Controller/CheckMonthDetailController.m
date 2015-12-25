//
//  CheckMonthDetailController.m
//  tcb
//
//  Created by Chuanxun on 15/12/4.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "CheckMonthDetailController.h"
#import "CheckMonthDetailCell.h"
#import "ELMonthReconciliationDetailList.h"
#import <DateTools.h>
#import "CheckMonthDetailFooterView.h"
#import "FeeDetailController.h"
#import "ELProposeConfirmManager.h"
#import "ELStatementAttachController.h"

#pragma mark - TableHeaderView

@interface TableHeaderView : UIView


@property (copy, nonatomic) NSString *dateStr;

@property (weak, nonatomic) UILabel *label;

@end

@implementation TableHeaderView

- (instancetype)initWithDateString:(NSString *)dateStr
{
    if (self  = [super init]) {
        self.dateStr = dateStr;
        
        UILabel *label1= [UILabel new];
        label1.text = @"时间";
        label1.font = [UIFont systemFontOfSize:16];
        [self addSubview:label1];
        
        UILabel *label2 = [UILabel new];
        label2.text = @"2015.08.01 - 2015.08.31";
        label2.font = [UIFont systemFontOfSize:16];
        [self addSubview:label2];
        
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.leading).offset(@12);
            make.centerY.equalTo(self);
            make.width.equalTo(@40);
        }];
        
        [label2 makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(label1.trailing).offset(8);
            make.centerY.equalTo(label1);
        }];
        
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

@end



#pragma mark - TableView

static NSString *reuse_id = @"CheckMonthDetailCell";

typedef NS_ENUM(NSInteger,CheckTableViewRefreshSource) {
    KREFRESH_HEADER = 1,
    KREFRESH_FOOTER = 2
};



@interface CheckMonthDetailController () <CheckMonthDetailCellDelegate,CheckMonthDetailFooterViewDelegate>

@property (copy, nonatomic) NSString *checkNo;
@property (copy, nonatomic) NSString *navigationTitle;

@property (assign, nonatomic) CheckStatus checkStatus;

@property (strong, nonatomic) ELMonthReconciliationDetailList *list;
@property (assign, nonatomic) NSInteger currentIndex;

@property (strong, nonatomic) NSMutableArray<ELMonthReconciliationDetail *> *datas;

@property (strong, nonatomic) CheckMonthDetailCell *prototypeCell;

@end

@implementation CheckMonthDetailController

-(instancetype)initWithCheckNo:(NSString *)checkNo checkStatus:(CheckStatus)checkStatus title:(NSString *)title
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.checkNo = checkNo;
        self.title = title;
        self.currentIndex = 1;
        self.checkStatus = checkStatus;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"CheckMonthDetailCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuse_id];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        
        self.tableView.estimatedRowHeight = 100;
    }
    //    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.prototypeCell = [[[NSBundle mainBundle] loadNibNamed:@"CheckMonthDetailCell" owner:nil options:nil] firstObject];
    self.prototypeCell.autoresizingMask = UIViewAutoresizingFlexibleWidth; // this must be set for the cell heights to be calculated correctly in landscape
    self.prototypeCell.hidden = YES;
    [self.tableView addSubview:self.prototypeCell];
    self.prototypeCell.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 0);
    
    //light gray
    self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self pull2Refresh];
    
    [self.tableView.mj_header beginRefreshing];
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [self.tableView.mj_header beginRefreshing];
//}

- (void)pull2Refresh
{
    __weak typeof (self) weakSelf = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData:KREFRESH_HEADER pageIndex:1];
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
        [weakSelf loadData:KREFRESH_FOOTER pageIndex:1];
    }];
    footer.automaticallyRefresh = NO;
    strIdle = NSLocalizedString(@"Click or Drag To Refresh Task", @"点击或下拉刷新");
    [footer setTitle:strIdle forState:MJRefreshStateIdle];
    [footer setTitle:strPull forState:MJRefreshStatePulling];
    [footer setTitle:strRefreshing forState:MJRefreshStateRefreshing];
    [footer setTitle:strNoMoreData forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
    
}


- (void)loadData:(CheckTableViewRefreshSource)source pageIndex:(NSInteger)index
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

        
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"cmd":@"GetReconciliationDetailList",@"data":@{@"pageIndex":@(pageIndex),@"checkNo":self.checkNo}}];
    [APIClientTool getReconciliationDetailListWithParam:params success:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        NSNumber *ret = [dict valueForKey:@"ret"];
        NSDictionary *data = [dict valueForKey:@"data"];
        if (ret.intValue == 0) {
            
            @synchronized(self) {
                self.list = [ELMonthReconciliationDetailList mj_objectWithKeyValues:data];
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
            self.tableView.tableFooterView = [self footerView];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @synchronized(self) {
        
        return self.datas.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @synchronized(self) {
        CheckMonthDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_id forIndexPath:indexPath];
        
        cell.reconciliationDetail = self.datas[indexPath.row];
        cell.delegate = self;
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8) {
        self.prototypeCell.reconciliationDetail = self.datas[indexPath.row];
        self.prototypeCell.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 0);
        [self.prototypeCell setNeedsLayout];
        [self.prototypeCell layoutIfNeeded];
        CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height + 1;
    }
    
    return UITableViewAutomaticDimension;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    TableHeaderView *headerView = [[TableHeaderView alloc] initWithDateString:@""];
//    return headerView;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 50;
//}

- (UIView *)footerView
{
    CheckMonthDetailFooterView *footerView = [CheckMonthDetailFooterView footerViewWithStatus:self.checkStatus];
    footerView.detailList = self.list;
    footerView.delegate = self;
    
    return footerView;
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    CheckMonthDetailFooterView *footerView = [CheckMonthDetailFooterView footerViewWithStatus:self.checkStatus];
//    footerView.detailList = self.list;
//    footerView.delegate = self;
//    
//    return footerView;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return [CheckMonthDetailFooterView bestHeight];
//}

#pragma mark - CheckMonthDetailCellDelegate

-(void)detailCellDetailBtnClicked:(CheckMonthDetailCell *)cell
{
    ELMonthReconciliationDetail *detail = cell.reconciliationDetail;
    FeeDetailController *feeDetailController = [[FeeDetailController alloc] init];
    feeDetailController.dispCode             = detail.DispCode;
    feeDetailController.phoneNumberArray     = nil;
    feeDetailController.dispCodeArray        = nil;
    feeDetailController.sourceType = SourceTypeCheck;
    [self.navigationController pushViewController:feeDetailController animated:YES];
}



#pragma mark - CheckMonthDetailFooterViewDelegate

-(void)allReturn:(CheckMonthDetailFooterView *)view
{
    if (!self.checkNo)
        return;
    
    NSString *checkNo = self.list.checkNo.copy;
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
    [manager proposeWithControllser:self title:@"全部退返？" msg:@[@"退返"] blocks:@[block]];

}

-(void)allConfirm:(CheckMonthDetailFooterView *)view
{
    if (!self.checkNo)
        return;
    
    NSString *checkNo = self.list.checkNo.copy;
    void(^block)() = ^{
        NSDictionary *dict = @{@"cmd":@"ConfirmReconciliation",@"data":@{@"checkNo":checkNo}};
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithStatus:@"正在确认对账"];
        });
        [APIClientTool confirmReconciliationWithParam:param success:^(NSDictionary *dict) {

            int ret = [[dict valueForKey:@"ret"] intValue];
            if (ret == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:@"确认对账成功"];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showErrorWithStatus:[dict valueForKey:@"msg"]];
                });
            }
            
        } failed:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"网络异常，确认对账失败"];
            });
        }];
 
    };
    
    ELProposeConfirmManager *manager = [ELProposeConfirmManager sharedManager];
    [manager proposeWithControllser:self title:@"全部确认对账？" msg:@[@"确认对账"] blocks:@[block]];
}


-(void)confirmAccount:(CheckMonthDetailFooterView *)view
{
    if (!self.checkNo)
        return;
    
    NSString *checkNo = self.list.checkNo.copy;
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

-(void)lookDetail:(CheckMonthDetailFooterView *)view
{
    if (!self.checkNo)
        return;
    
    ELStatementAttachController *vc = [[ELStatementAttachController alloc] initWithCheckNo:self.checkNo];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - LazyLoad

-(NSMutableArray<ELMonthReconciliationDetail *> *)datas
{
    if (!_datas) {
        _datas = [NSMutableArray new];
    }
    return _datas;
}

@end
