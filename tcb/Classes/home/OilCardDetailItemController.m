//
//  OilCardDetailItemController.m
//  tcb
//
//  Created by Chuanxun on 15/12/15.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "OilCardDetailItemController.h"
#import "OilCardConsumptionList.h"
#import "OilCardDetailItemCell.h"
#import "ConsumptionDetailController.h"

typedef NS_ENUM(NSInteger,OCDICRefreshSource) {
    OCDICRS_HEADER = 0,
    OCDICRS_FOOTER = 1,
};


@interface OilCardDetailItemController ()

@property (copy, nonatomic) NSString *cardID;
@property (assign, nonatomic) OilCardDetailItemControllerType vcType;
@property (strong, nonatomic) OilCardConsumptionList *list;
@property (strong, nonatomic) NSMutableArray *allDatas;
@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation OilCardDetailItemController


static NSString *reuse_id = @"OilCardDetailItemCell";

- (instancetype)initWithCardID:(NSString *)cardId Type:(OilCardDetailItemControllerType)type
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.cardID = cardId;
        self.vcType = type;
        self.currentIndex = 1;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"OilCardDetailItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuse_id];
    self.tableView.rowHeight = [OilCardDetailItemCell bestHeight];
    
    
    self.tableView.backgroundColor = kRGB(235, 235, 235);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self pull2Refresh];
    
    [self.tableView.mj_header beginRefreshing];
}


- (void)pull2Refresh
{
    __weak typeof (self) weakSelf = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData:OCDICRS_HEADER pageIndex:1];
    }];
    NSString *strIdle = NSLocalizedString(@"Pull To Refresh", @"下拉刷新");
    [header setTitle:strIdle forState:MJRefreshStateIdle];
    NSString *strPull = NSLocalizedString(@"Relese To Refresh Now", @"松开立即刷新");
    [header setTitle:strPull forState:MJRefreshStatePulling];
    NSString *strRefreshing = NSLocalizedString(@"Refreshing...", @"正在刷新");
    [header setTitle:strRefreshing forState:MJRefreshStateRefreshing];
    NSString *strNoMoreData = NSLocalizedString(@"No More Data", @"没有更多数据");
    [header setTitle:strNoMoreData forState:MJRefreshStateNoMoreData];
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadData:OCDICRS_FOOTER pageIndex:1];
    }];
    footer.automaticallyRefresh = NO;
    strIdle = NSLocalizedString(@"Click or Drag To Refresh", @"点击或下拉刷新");
    [footer setTitle:strIdle forState:MJRefreshStateIdle];
    [footer setTitle:strPull forState:MJRefreshStatePulling];
    [footer setTitle:strRefreshing forState:MJRefreshStateRefreshing];
    [footer setTitle:strNoMoreData forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
}


- (void)loadData:(OCDICRefreshSource)source pageIndex:(NSInteger)index
{
    NSAssert(self.cardID, @"加油卡ID为空");
    [SVProgressHUD showWithStatus:@"正在加载数据"];
    NSInteger pageIndex;
    if (source == OCDICRS_FOOTER) {
        pageIndex = self.currentIndex++;
    }else {
        pageIndex = 1;
        self.currentIndex = 1;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"cmd":@"GetConsumptionList",@"data":@{@"fuelCardId":self.cardID,
                                                                            @"state":@(self.vcType),
                                                                            @"pageIndex":@(pageIndex),
                                                                            @"pageSize":@(50)}
                                     }];
    [APIClientTool GetConsumptionListWithParam:params success:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        NSNumber *ret = [dict valueForKey:@"ret"];
        NSDictionary *data = [dict valueForKey:@"data"];
        if (ret.intValue == 0) {
            [SVProgressHUD dismiss];
            self.list = [OilCardConsumptionList mj_objectWithKeyValues:data];
            if (source == OCDICRS_FOOTER) {
                [self.allDatas addObjectsFromArray:self.list.list];
            }else {
                self.allDatas = [NSMutableArray arrayWithArray:self.list.list.copy];
            }
        }else {
            [SVProgressHUD showErrorWithStatus:[dict valueForKey:@"msg"]];
        }
        
        if (ret.intValue == 0) {
            [self.tableView reloadData];
        }
        
        if (source == OCDICRS_HEADER) {
            [self.tableView.mj_header endRefreshing];
        }else if (source == OCDICRS_FOOTER && self.list.list.count != 0) {
            [self.tableView.mj_footer endRefreshing];
        }else if (source == OCDICRS_FOOTER && self.list.list.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failed:^{
        if (source == OCDICRS_HEADER) {
            [self.tableView.mj_header endRefreshing];
        }else if (source == OCDICRS_FOOTER) {
            [self.tableView.mj_footer endRefreshing];
        }
        [SVProgressHUD showErrorWithStatus:@"连接网络失败"];
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.allDatas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OilCardDetailItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_id forIndexPath:indexPath];
    
    cell.item = self.allDatas[indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    OilCardConsumptionItem *item = self.allDatas[indexPath.row];
    BOOL isRecharge = [item.Cost characterAtIndex:0] != '-';
    ConsumptionDetailController *vc = [[ConsumptionDetailController alloc] initWithConsumptionId:item.Id isRecharge:isRecharge];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma  mark - lazy load

-(NSMutableArray *)allDatas
{
    if (!_allDatas) {
        _allDatas = [NSMutableArray new];
    }
    return _allDatas;
}

@end
