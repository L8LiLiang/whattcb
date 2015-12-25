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

#import "APIClientTool.h"
#import "NSString+Extension.h"
#import "DashLineView.h"
#import "OptionButton.h"
#import "AddLineCell.h"
#import "RefuseOrderDispatchResult.h"
#import "AcceptOrderDispatchResult.h"
#import "AutoSignInController.h"

#define kLabelFont(font)  [UIFont systemFontOfSize:font]
#define kLabelLeftMargin 15
#define kMarginLeft 10
#define kNodeCellHeight 38
#define kNodeCellNum (self.firstDetail.NodeList.count)
#define kNodeCellNum1 (self.secondDetail.NodeList.count)
#define kDetailViewHeight ((self.detailCount == 1)?(215 + kNodeCellNum * kNodeCellHeight) : (215 + kNodeCellNum1 * kNodeCellHeight))
#define kWeightFont [UIFont systemFontOfSize:14]


@interface ListMoreOrderController ()<UITableViewDelegate, UITableViewDataSource, ListMoreOrderCellDelegate>

/**
 *  派车单模型
 */
@property (nonatomic, strong) SendCarList *sendCarList;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *itemArray;

/**
 *  装所有的子视图
 */
@property (nonatomic, strong) UIView *totalView;
/**
 *  箱子个数
 */
@property (nonatomic, assign) NSInteger detailCount;
/**
 *  箱子详情1视图
 */
@property (nonatomic, strong) UIView *detailView1;
/**
 *  箱子详情2视图
 */
@property (nonatomic, strong) UIView *detailView2;
/**
 *  箱子详情1
 */
@property (nonatomic, strong) OrderItem *firstDetail;
/**
 *  箱子详情2
 */
@property (nonatomic, strong) OrderItem *secondDetail;
/**
 *  费用视图
 */
@property (nonatomic, strong) UIView *feeView;

@property (nonatomic, strong) NSString *dispCode;

/**
 *  派单详情模型
 */
@property (nonatomic, strong) OrderDetail *orderDetail;

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
    
    self.view.backgroundColor = ThemeColor;
    
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


- (void)configTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = ThemeColor;
    self.tableView.tag = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
}


- (void)configTableViewWithTag:(NSInteger)tag {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = ThemeColor;
    self.tableView.tag = tag;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
}

#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *list = self.sendCarList.list;
    if (tableView.tag == 0) {
        /* 接单列表tableView */
        if ([list count] == 0) {
            return 2;
        } else {
            return [list count] + 1;
        }
    } else if (tableView.tag == 1) {
        /* 单个订单详情节点列表1 */
        return self.firstDetail.NodeList.count;
    } else if (tableView.tag == 2) {
        /* 单个订单详情节点列表2 */
        return self.secondDetail.NodeList.count;
    }
    return 0;
}

- (void)setupGrabCell:(UITableViewCell *)cell {
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
}

- (void)setupNoOrderCell:(UITableViewCell *)cell {
    UIView *totalView = [[UIView alloc] init];
    [cell.contentView addSubview:totalView];
    [totalView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.contentView.centerX);
        make.centerY.equalTo(cell.contentView.centerY);
        make.left.right.equalTo(0);
        make.height.equalTo(200);
    }];
    UIImageView *imageView = [[UIImageView alloc] init];
    [totalView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"bg_mail"];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalView.top).offset(0);
        make.height.equalTo(100);
        make.width.equalTo(120);
        make.centerX.equalTo(cell.contentView.centerX);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"没有收到任何派车单,请联系您";
    label1.textAlignment = NSTextAlignmentCenter;
    [totalView addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.bottom).offset(10);
        make.left.right.equalTo(0);
        make.height.equalTo(30);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"的车队确认派车计划";
    label2.textAlignment = NSTextAlignmentCenter;
    [totalView addSubview:label2];
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.bottom).offset(0);
        make.left.right.equalTo(0);
        make.height.equalTo(30);
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [self setupGrabCell:cell];
            return cell;
        } else {
            NSArray *list = self.sendCarList.list;
            if (list.count > 1) {
                List *itemList = list[indexPath.row - 1];
                NSArray *itemArray = itemList.item;
                ListMoreOrderCell *listMoreOrderCell = [ListMoreOrderCell cellWithTableView:tableView];
                listMoreOrderCell.tag = indexPath.row - 1;
                listMoreOrderCell.sendCarList = self.sendCarList;
                listMoreOrderCell.itemArray = itemArray;
                listMoreOrderCell.listMoreOrderCellDelegate = self;
                listMoreOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return listMoreOrderCell;
                
            } else if (list.count == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                [self setupNoOrderCell:cell];
                return cell;
            } else if (list.count == 1) {
                UITableViewCell *singleOrderCell = [[UITableViewCell alloc] init];
                singleOrderCell.backgroundColor = ThemeColor;
                singleOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self setupSingleOrderCell:singleOrderCell dataArray:self.itemArray];
                [self setupFee];
                [self setupContact];
                return singleOrderCell;
            }
            
        }

    } else if (tableView.tag == 1) {
        NSArray *nodeListArray = self.firstDetail.NodeList;
        Nodelist *nodeList = nodeListArray[indexPath.row];
        
        if (indexPath.row == 0) {
            AddLineCell *topCell = [AddLineCell cellWithTableView:tableView];
            topCell.addLineCellStyle = AddLineCellStyleTop;
            topCell.contentView.backgroundColor = kRGB(17, 141, 254);
            topCell.imageView.image = [UIImage imageNamed:@"ic_white_circle"];
            NSString *topString = [NSString stringWithFormat:@"%@%@:%@",nodeList.Display, nodeList.NodeType, nodeList.Address];
            topCell.textLabel.text = topString;
            topCell.textLabel.textColor = [UIColor whiteColor];
            topCell.userInteractionEnabled = NO;
            return topCell;
        } else if (indexPath.row == self.firstDetail.NodeList.count - 1) {
            AddLineCell *bottomCell = [AddLineCell cellWithTableView:tableView];
            bottomCell.addLineCellStyle = AddLineCellStyleBottom;
            bottomCell.contentView.backgroundColor = kRGB(17, 141, 254);
            bottomCell.imageView.image = [UIImage imageNamed:@"ic_white_circle"];
            NSString *bottomString = [NSString stringWithFormat:@"%@%@:%@", nodeList.Display, nodeList.NodeType, nodeList.Address];
            bottomCell.textLabel.text = bottomString;
            bottomCell.textLabel.textColor = [UIColor whiteColor];
            bottomCell.userInteractionEnabled = NO;
            return bottomCell;
        } else {
            AddLineCell *middleCell = [AddLineCell cellWithTableView:tableView];
            middleCell.addLineCellStyle = AddLineCellStyleMiddle;
            middleCell.contentView.backgroundColor = kRGB(17, 141, 254);
            middleCell.imageView.image = [UIImage imageNamed:@"ic_white_circle"];
            middleCell.textLabel.text = nodeList.Address;
            middleCell.textLabel.textColor = [UIColor whiteColor];
            middleCell.userInteractionEnabled = NO;
            return middleCell;
        }

    } else if  (tableView.tag == 2) {
        NSArray *nodeListArray1 = self.secondDetail.NodeList;
        Nodelist *nodeList1 = nodeListArray1[indexPath.row];
        
        if (indexPath.row == 0) {
            AddLineCell *topCell = [AddLineCell cellWithTableView:tableView];
            topCell.addLineCellStyle = AddLineCellStyleTop;
            topCell.contentView.backgroundColor = kRGB(17, 141, 254);
            topCell.imageView.image = [UIImage imageNamed:@"ic_white_circle"];
            NSString *topString1 = [NSString stringWithFormat:@"%@%zd:%@",nodeList1.NodeName, nodeList1.Display, nodeList1.Address];
            topCell.textLabel.text = topString1;
            topCell.textLabel.textColor = [UIColor whiteColor];
            topCell.userInteractionEnabled = NO;
            return topCell;
        } else if (indexPath.row == self.secondDetail.NodeList.count - 1) {
            AddLineCell *bottomCell = [AddLineCell cellWithTableView:tableView];
            bottomCell.addLineCellStyle = AddLineCellStyleBottom;
            bottomCell.contentView.backgroundColor = kRGB(17, 141, 254);
            bottomCell.imageView.image = [UIImage imageNamed:@"ic_white_circle"];
            NSString *bottomString1 = [NSString stringWithFormat:@"%@%zd:%@", nodeList1.NodeName, nodeList1.Display, nodeList1.Address];
            bottomCell.textLabel.text = bottomString1;
            bottomCell.textLabel.textColor = [UIColor whiteColor];
            bottomCell.userInteractionEnabled = NO;
            return bottomCell;
        } else {
            AddLineCell *middleCell = [AddLineCell cellWithTableView:tableView];
            middleCell.addLineCellStyle = AddLineCellStyleMiddle;
            middleCell.contentView.backgroundColor = kRGB(17, 141, 254);
            middleCell.imageView.image = [UIImage imageNamed:@"ic_white_circle"];
            middleCell.textLabel.text = nodeList1.Address;
            middleCell.textLabel.textColor = [UIColor whiteColor];
            middleCell.userInteractionEnabled = NO;
            return middleCell;
        }
 
    }
    
    
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        if (indexPath.row == 0) {
            return 50;
        } else {
            NSArray *list = self.sendCarList.list;
            if ([list count] == 0) {
                return SCREEN_HEIGHT - 50;
            } else if (list.count > 1) {
                List *itemList = list[indexPath.row - 1];
                return [ListMoreOrderCell cellHeightWithItemArray:itemList.item];
            } else if (list.count == 1) {
                
                CGFloat topH = ((self.detailCount == 1) ? (kDetailViewHeight) : (kDetailViewHeight + 211 + 100));
                CGFloat scrollerViewContentSizeH = (40 + topH + 40 + 10 + 100);
                
                return scrollerViewContentSizeH;
            }
        }

    } else {
        return  kNodeCellHeight;
    }
    return 0;
}



#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        NSInteger grabListNumber = self.sendCarList.grabOrderCount;
        if (grabListNumber != 0) {
            //  抢单界面
            ShowRobListOrderController *showRobListOrderController = [[ShowRobListOrderController alloc] init];
            [self.navigationController pushViewController:showRobListOrderController animated:YES];
        }
    }
}

#pragma mark - 请求我要接单多票数据
- (void)wantMoreList {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"GetPrepareOrderList" forKey:@"cmd"];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSInteger role =  [[NSUserDefaults standardUserDefaults] integerForKey:@"kRole"];
    [data setValue:@1 forKey:@"role"];
    [param setValue:data forKey:@"data"];

//    [SVProgressHUD showWithStatus:@"正在加载多票列表数据" maskType:SVProgressHUDMaskTypeBlack];
    [APIClientTool WantMoreListWithParam:param success:^(NSDictionary *dict) {
//        [SVProgressHUD dismiss];
        
//                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//                NSLog(@"JSONString正在加载多票列表数据 === %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
//        
        
        
        
        
        NSNumber *ret = [dict objectForKey:@"ret"];
        NSString *msg = [dict objectForKey:@"msg"];
        NSDictionary *data = [dict objectForKey:@"data"];
        if ([ret integerValue] == 0) {
            SendCarList *sendCarList = [SendCarList mj_objectWithKeyValues:data];
            self.sendCarList = sendCarList;
   
             NSArray *list = self.sendCarList.list;
            if (list.count == 1) {
                /* 直接显示 */
                List *itemList = list[0];
                NSArray *itemArray = itemList.item;
                Item *firstItem = itemArray[0];
                NSString *dispCode = firstItem.DispCode;
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setValue:@"GetPrepareOrder" forKey:@"cmd"];
                NSMutableDictionary *data = [NSMutableDictionary dictionary];
                [data setValue:dispCode forKey:@"dispCode"];
                [param setValue:data forKey:@"data"];
                
//                [SVProgressHUD showWithStatus:@"加载派单详情中" maskType:SVProgressHUDMaskTypeBlack];
                [APIClientTool WantSingleListWithParam:param success:^(NSDictionary *dict) {
//                    [SVProgressHUD dismiss];
                    
                    NSNumber *ret = [dict objectForKey:@"ret"];
                    NSString *msg = [dict objectForKey:@"msg"];
                    NSDictionary *data = [dict objectForKey:@"data"];
                    if ([ret integerValue] == 0) {
                        OrderDetail *orderDetail = [OrderDetail mj_objectWithKeyValues:data];
                        self.orderDetail = orderDetail;
                        [self setUpSingleOrderDetailView];
                        
                        NSArray *itemArray = orderDetail.item;
                        self.itemArray = orderDetail.item;
                        NSInteger detailCount = [itemArray count];
                        self.detailCount = detailCount;
                        
                        [self.tableView reloadData];
                        [self.tableView.mj_header endRefreshing];
                    } else {
                        [SVProgressHUD showErrorWithStatus:msg];
                    }
                } failed:^{
//                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
                }];
                
            } else {
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }
            
            
        } else {
            [self.tableView.mj_header endRefreshing];
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failed:^{
//        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
    }];
    
}

#pragma mark - ListMoreOrderCellDelegate
#pragma mark  跳转派单单详情页
- (void)nextViewOnTap:(UITapGestureRecognizer *)tap {
    
    //  这个界面是可以获取派单号的DispCode == 派单详情（下个页面获取数据展示）
    UIView *nextView = tap.view;
    NSInteger seletedRow = nextView.tag;
    NSArray *list = self.sendCarList.list;
    List *itemList = list[seletedRow];
    NSArray *itemArray = itemList.item;
    Item *firstItem = itemArray[0];
    NSString *dispCode = firstItem.DispCode;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"GetPrepareOrder" forKey:@"cmd"];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setValue:dispCode forKey:@"dispCode"];
    [param setValue:data forKey:@"data"];
    
    [SVProgressHUD showWithStatus:@"加载派单详情中" maskType:SVProgressHUDMaskTypeBlack];
    [APIClientTool WantSingleListWithParam:param success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
                NSLog(@"JSONString === %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
        
        
        NSNumber *ret = [dict objectForKey:@"ret"];
        NSString *msg = [dict objectForKey:@"msg"];
        NSDictionary *data = [dict objectForKey:@"data"];
        if ([ret integerValue] == 0) {
            OrderDetail *orderDetail = [OrderDetail mj_objectWithKeyValues:data];
            ListSingleOrderController *listSingleOrderController = [[ListSingleOrderController alloc] init];
            listSingleOrderController.orderDetail = orderDetail;
            listSingleOrderController.dispCode = dispCode;
            [self.navigationController pushViewController:listSingleOrderController animated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failed:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
    }];

}
#pragma mark  联系调度
- (void)contactAndDispatch:(UIButton *)sender {
    NSInteger seletedRow = sender.tag;
    NSArray *list = self.sendCarList.list;
    List *itemList = list[seletedRow];
    NSArray *itemArray = itemList.item;
    Item *firstItem = itemArray[0];
    NSString *dispatcherMobile = firstItem.DispatcherMobile;
    
    NSMutableString *string = [[NSMutableString alloc] initWithFormat:@"tel:%@", dispatcherMobile];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
    [self.view addSubview:callWebview];
}


#pragma mark - 下拉刷新数据
- (void)loadNewData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self wantMoreList];
    });
}



- (void)setUpSingleOrderDetailView {
   

}


#pragma mark - 

- (void)setupSingleOrderCell:(UITableViewCell *)cell dataArray:(NSArray *)itemArray {
    
    OrderItem *firstDetail = itemArray[0];
    self.firstDetail = firstDetail;
    
    CGFloat topH = ((self.detailCount == 1) ? (kDetailViewHeight) : (kDetailViewHeight + 211 + 100));
    CGFloat scrollerViewContentSizeH = (40 + topH + 40 + 10 + 100);
    
    UIView *totalView = [[UIView alloc] init];
    self.totalView = totalView;
    [cell.contentView addSubview:totalView];
    totalView.frame = CGRectMake(0, 0, SCREEN_WIDTH, scrollerViewContentSizeH);
    
    /*************************第一个箱子的view**************************/
    
    //  车队名+调度姓名+派单时间
    UILabel *dispatcherLabel = [[UILabel alloc] init];
    [totalView addSubview:dispatcherLabel];
    [dispatcherLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(40);
    }];
    dispatcherLabel.font = kLabelFont(17);
    dispatcherLabel.textColor = [UIColor whiteColor];
    NSString *teamName = firstDetail.TeamName;
    NSString *dispatcher = firstDetail.Dispatcher;
    NSString *DispTime = firstDetail.DispTime;
    NSString *dispatchText = [NSString stringWithFormat:@"   %@  %@  %@", teamName, dispatcher, DispTime];
    dispatcherLabel.text = dispatchText;
    dispatcherLabel.backgroundColor = kRGB(17, 112, 197);
    
    //   进出口字段
    UIView *detailView1 = [[UIView alloc] init];
    [totalView addSubview:detailView1];
    [detailView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dispatcherLabel.bottom).offset(0);
        make.left.right.equalTo(0);
        make.height.equalTo(kDetailViewHeight);
    }];
    self.detailView1 = detailView1;
    detailView1.backgroundColor = kRGB(17, 141, 254);
    
    /*--------------------------船名航次--------------------------*/
    UILabel *shipVoyage1 = [self labelWithTitle:@"船名航次"];
    [detailView1 addSubview:shipVoyage1];
    [shipVoyage1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailView1.top).offset(10);
        make.left.equalTo(detailView1.left).offset(kLabelLeftMargin);
    }];
    UILabel *shipVoyageName1 = [self labelWithTitle:firstDetail.ShipVoyage];
    shipVoyageName1.font = kLabelFont(17);
    [detailView1 addSubview:shipVoyageName1];
    [shipVoyageName1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shipVoyage1.centerY);
        make.left.equalTo(shipVoyage1.right).equalTo(kLabelLeftMargin);
    }];
    /*--------------------------提单号--------------------------*/
    UILabel *BookingNo1 = [self labelWithTitle:@"提单号"];
    [detailView1 addSubview:BookingNo1];
    [BookingNo1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shipVoyage1.bottom).offset(10);
        make.left.equalTo(totalView.left).offset(kLabelLeftMargin);
    }];
    UILabel *BookingNoName1 = [self labelWithTitle:firstDetail.BillNo];
    BookingNoName1.font = kLabelFont(17);
    [detailView1 addSubview:BookingNoName1];
    [BookingNoName1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(BookingNo1.centerY);
        make.left.equalTo(shipVoyageName1.left).equalTo(0);
    }];
    /*--------------------装箱--------截仓------------------------*/
    NSInteger businessType1 = firstDetail.BusinessType;
    NSString *string11 = (businessType1 == 0 ? @"装箱" : @"装货");
    NSString *string21 = (businessType1 == 0 ? @"截关" : @"截仓");
    UILabel *businessType11 = [self labelWithTitle:string11];
    [detailView1 addSubview:businessType11];
    businessType11.textAlignment = NSTextAlignmentCenter;
    [businessType11 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BookingNo1.bottom).offset(10);
        make.left.equalTo(detailView1.left).offset(0);
        make.width.equalTo(SCREEN_WIDTH * 0.5);
        make.height.equalTo(35);
    }];
    UILabel *businessType21 = [self labelWithTitle:string21];
    [detailView1 addSubview:businessType21];
    businessType21.textAlignment = NSTextAlignmentCenter;
    [businessType21 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BookingNo1.bottom).offset(10);
        make.right.equalTo(detailView1.right).offset(0);
        make.width.equalTo(SCREEN_WIDTH * 0.5);
        make.height.equalTo(35);
    }];
    
    /*---------------------------出清-------------------------*/
    UIButton *customsMode1 = [[UIButton alloc] init];
    [detailView1 addSubview:customsMode1];
    [customsMode1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(businessType11.top).offset(12);
        make.centerX.equalTo(detailView1.centerX);
        make.width.equalTo(60);
        make.height.equalTo(40);
    }];
    [customsMode1 setTitle:firstDetail.CustomsMode forState:UIControlStateNormal];
    customsMode1.layer.borderColor = [[UIColor whiteColor] CGColor];
    customsMode1.layer.borderWidth = 1;
    
    /*----------------装箱time--------截仓time-------------------*/
    UILabel *beginTime1 = [self labelWithTitle:firstDetail.BeginTime];
    [detailView1 addSubview:beginTime1];
    beginTime1.textAlignment = NSTextAlignmentCenter;
    beginTime1.font = [UIFont systemFontOfSize:13];
    
    [beginTime1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(businessType11.bottom).offset(4);
        make.left.equalTo(detailView1.left).offset(0);
        make.right.equalTo(customsMode1.left).offset(0);
    }];
    UILabel *endTime1 = [self labelWithTitle:firstDetail.EndTime];
    [detailView1 addSubview:endTime1];
    endTime1.textAlignment = NSTextAlignmentCenter;
    endTime1.font = [UIFont systemFontOfSize:13];
    [endTime1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(beginTime1.top).offset(0);
        make.right.equalTo(detailView1.right).offset(0);
        make.left.equalTo(customsMode1.right).offset(0);
    }];
    
    /*--------------------------毛重--------------------------*/
    UIView *weightView1 = [[UIView alloc] init];
    [detailView1 addSubview:weightView1];
    NSString *pieceOrContainerTypeString1 = firstDetail.Piece;
    NSString *weightString1 = firstDetail.Weight;
    NSString *cubageString1 = firstDetail.Cubage;
    
    CGSize pieceOrContainerTypeStringSize1 = [pieceOrContainerTypeString1 sizeWithFont:kWeightFont  andMaxSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)];
    CGSize weightStringSize1 = [weightString1 sizeWithFont:kWeightFont  andMaxSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)];
    CGSize cubageStringSize1 = [cubageString1 sizeWithFont:kWeightFont  andMaxSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)];
    
    CGFloat weightViewW1 = pieceOrContainerTypeStringSize1.width + weightStringSize1.width + cubageStringSize1.width + 22;
    CGFloat weightViewH1 = pieceOrContainerTypeStringSize1.height;
    
    [weightView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customsMode1.bottom).offset(20);
        make.width.equalTo(weightViewW1);
        make.height.equalTo(weightViewH1);
        make.centerX.equalTo(detailView1.centerX);
    }];
    
    UILabel *pieceOrContainerType1 = [self labelWithTitle:pieceOrContainerTypeString1];
    [weightView1 addSubview:pieceOrContainerType1];
    [pieceOrContainerType1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(0);
    }];
    pieceOrContainerType1.font =  kWeightFont;
    
    UIView *lineView11 = [[UIView alloc] init];
    lineView11.backgroundColor = [UIColor whiteColor];
    [weightView1 addSubview:lineView11];
    [lineView11 makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(0);
        make.left.equalTo(pieceOrContainerType1.right).offset(5);
        make.width.equalTo(1);
    }];
    
    UILabel *weight1 = [self labelWithTitle:weightString1];
    [weightView1 addSubview:weight1];
    weight1.font =  kWeightFont;
    [weight1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(0);
        make.left.equalTo(lineView11.right).offset(5);
    }];
    
    UIView *lineView12 = [[UIView alloc] init];
    [weightView1 addSubview:lineView12];
    [lineView12 makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(0);
        make.left.equalTo(weight1.right).offset(5);
        make.width.equalTo(1);
    }];
    lineView12.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *cubage1 = [self labelWithTitle:cubageString1];
    [weightView1 addSubview:cubage1];
    [cubage1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(lineView12.right).offset(5);
    }];
    cubage1.font =  kWeightFont;
    
    /*--------------------------苏杰电子速--------------------------*/
    UILabel *factoryShortName1 = [self labelWithTitle:firstDetail.FactoryShortName];
    [detailView1 addSubview:factoryShortName1];
    [factoryShortName1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weightView1.bottom).offset(7);
        make.centerX.equalTo(detailView1.centerX);
    }];
    factoryShortName1.font =  kWeightFont;
    
    /*--------------------------备注--------------------------*/
    UILabel *followRemark1 = [self labelWithTitle:@"备注:"];
    [detailView1 addSubview:followRemark1];
    [followRemark1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(factoryShortName1.bottom).offset(5);
        make.left.equalTo(detailView1.left).offset(15);
    }];
    followRemark1.font = kLabelFont(17);
    
    UILabel *followRemarkName1 = [self labelWithTitle:firstDetail.FollowRemark];
    [detailView1 addSubview:followRemarkName1];
    [followRemarkName1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(factoryShortName1.bottom).offset(5);
        make.left.equalTo(followRemark1.right).offset(8);
    }];
    followRemarkName1.font = kLabelFont(17);
    
    /*--------------------------画虚线--------------------------*/
    DashLineView *dashLineView1 = [[DashLineView alloc] init];
    dashLineView1.lineColor = [UIColor whiteColor];
    dashLineView1.backgroundColor = [UIColor clearColor];
    [totalView addSubview:dashLineView1];
    [dashLineView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(followRemark1.bottom).offset(5);
        make.left.right.equalTo(totalView).offset(0);
        make.height.equalTo(1);
    }];
    
    NSArray *nodeListArray = self.firstDetail.NodeList;
    NSInteger nodeListCount1 = nodeListArray.count;
    
    /*--------------------------node--------------------------*/
    UITableView *nodeTableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH, nodeListCount1 * kNodeCellHeight) style:UITableViewStylePlain];
    [detailView1 addSubview:nodeTableView1];
    [nodeTableView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dashLineView1.bottom).offset(0);
        make.left.right.equalTo(0);
        make.height.equalTo(nodeListCount1 * kNodeCellHeight);
    }];
    nodeTableView1.tag = 1;
    nodeTableView1.editing = NO;
    nodeTableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    nodeTableView1.rowHeight = kNodeCellHeight;
    nodeTableView1.dataSource = self;
    nodeTableView1.delegate = self;
    nodeTableView1.scrollEnabled = NO;
    
    /*****************如果有2个箱子加上第二个箱子的view*********************/
    if (self.detailCount == 2) {
        
        OrderItem *secondDetail = itemArray[1];
        self.secondDetail = secondDetail;
        UIView *whiteLine = [[UIView alloc] init];
        [totalView addSubview:whiteLine];
        [whiteLine makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(detailView1.bottom).offset(0.5);
            make.left.right.equalTo(totalView);
            make.height.equalTo(0.5);
        }];
        whiteLine.backgroundColor = [UIColor whiteColor];
        
        //   进出口字段2
        UIView *detailView2 = [[UIView alloc] init];
        [totalView addSubview:detailView2];
        [detailView2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(whiteLine.bottom).offset(0);
            make.left.right.equalTo(0);
            make.height.equalTo(kDetailViewHeight);
        }];
        self.detailView2 = detailView2;
        detailView2.backgroundColor = kRGB(17, 141, 254);
        
        /*--------------------------船名航次2--------------------------*/
        UILabel *shipVoyage2 = [self labelWithTitle:@"船名航次"];
        [detailView2 addSubview:shipVoyage2];
        [shipVoyage2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(detailView2.top).offset(10);
            make.left.equalTo(detailView2.left).offset(kLabelLeftMargin);
        }];
        UILabel *shipVoyageName2 = [self labelWithTitle:secondDetail.ShipVoyage];
        shipVoyageName2.font = kLabelFont(17);
        [detailView2 addSubview:shipVoyageName2];
        [shipVoyageName2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(shipVoyage2.centerY);
            make.left.equalTo(shipVoyage2.right).equalTo(kLabelLeftMargin);
        }];
        /*--------------------------提单号2--------------------------*/
        UILabel *BookingNo2 = [self labelWithTitle:@"提单号"];
        [detailView2 addSubview:BookingNo2];
        [BookingNo2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(shipVoyage2.bottom).offset(10);
            make.left.equalTo(totalView.left).offset(kLabelLeftMargin);
        }];
        UILabel *BookingNoName2 = [self labelWithTitle:secondDetail.BillNo];
        BookingNoName2.font = kLabelFont(17);
        [detailView2 addSubview:BookingNoName2];
        [BookingNoName2 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(BookingNo2.centerY);
            make.left.equalTo(shipVoyageName2.left).equalTo(0);
        }];
        /*--------------------装箱2--------截仓2------------------------*/
        NSInteger businessType2 = secondDetail.BusinessType;
        NSString *string21 = (businessType2 == 0 ? @"装箱" : @"装货");
        NSString *string22 = (businessType2 == 0 ? @"截关" : @"截仓");
        UILabel *businessType21 = [self labelWithTitle:string21];
        [detailView2 addSubview:businessType21];
        businessType21.textAlignment = NSTextAlignmentCenter;
        [businessType21 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(BookingNo2.bottom).offset(10);
            make.left.equalTo(detailView2.left).offset(0);
            make.width.equalTo(SCREEN_WIDTH * 0.5);
            make.height.equalTo(35);
        }];
        UILabel *businessType22 = [self labelWithTitle:string22];
        [detailView2 addSubview:businessType22];
        businessType22.textAlignment = NSTextAlignmentCenter;
        [businessType22 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(BookingNo2.bottom).offset(10);
            make.right.equalTo(detailView2.right).offset(0);
            make.width.equalTo(SCREEN_WIDTH * 0.5);
            make.height.equalTo(35);
        }];
        
        /*---------------------------出清2-------------------------*/
        UIButton *customsMode2 = [[UIButton alloc] init];
        [detailView2 addSubview:customsMode2];
        [customsMode2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(businessType21.top).offset(12);
            make.centerX.equalTo(detailView2.centerX);
            make.width.equalTo(60);
            make.height.equalTo(40);
        }];
        [customsMode2 setTitle:secondDetail.CustomsMode forState:UIControlStateNormal];
        customsMode2.layer.borderColor = [[UIColor whiteColor] CGColor];
        customsMode2.layer.borderWidth = 1;
        
        /*----------------装箱time2--------截仓time2-------------------*/
        UILabel *beginTime2 = [self labelWithTitle:secondDetail.BeginTime];
        [detailView2 addSubview:beginTime2];
        [beginTime2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(businessType21.bottom).offset(4);
            make.left.equalTo(detailView2.left).offset(0);
            make.right.equalTo(customsMode2.left).offset(0);
        }];
        beginTime2.textAlignment = NSTextAlignmentCenter;
        beginTime2.font = [UIFont systemFontOfSize:13];
        
        UILabel *endTime2 = [self labelWithTitle:secondDetail.EndTime];
        [detailView2 addSubview:endTime2];
        endTime2.textAlignment = NSTextAlignmentCenter;
        endTime2.font = [UIFont systemFontOfSize:13];
        [endTime2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(beginTime2.top).offset(0);
            make.right.equalTo(detailView2.right).offset(0);
            make.left.equalTo(customsMode2.right).offset(0);
        }];
        
        /*--------------------------毛重2--------------------------*/
        UIView *weightView2 = [[UIView alloc] init];
        [detailView2 addSubview:weightView2];
        NSString *pieceOrContainerTypeString2 = secondDetail.Piece;
        NSString *weightString2 = secondDetail.Weight;
        NSString *cubageString2 = secondDetail.Cubage;
        
        CGSize pieceOrContainerTypeStringSize2 = [pieceOrContainerTypeString2 sizeWithFont:kWeightFont  andMaxSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)];
        CGSize weightStringSize2 = [weightString2 sizeWithFont:kWeightFont  andMaxSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)];
        CGSize cubageStringSize2 = [cubageString2 sizeWithFont:kWeightFont  andMaxSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)];
        
        CGFloat weightViewW2 = pieceOrContainerTypeStringSize2.width + weightStringSize2.width + cubageStringSize2.width + 22;
        CGFloat weightViewH2 = pieceOrContainerTypeStringSize2.height;
        
        [weightView2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(customsMode2.bottom).offset(20);
            make.width.equalTo(weightViewW2);
            make.height.equalTo(weightViewH2);
            make.centerX.equalTo(detailView2.centerX);
        }];
        
        UILabel *pieceOrContainerType2 = [self labelWithTitle:pieceOrContainerTypeString1];
        [weightView2 addSubview:pieceOrContainerType2];
        [pieceOrContainerType2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(0);
        }];
        pieceOrContainerType2.font =  kWeightFont;
        
        UIView *lineView21 = [[UIView alloc] init];
        [weightView2 addSubview:lineView21];
        [lineView21 makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(0);
            make.left.equalTo(pieceOrContainerType2.right).offset(5);
            make.width.equalTo(1);
        }];
        lineView21.backgroundColor = [UIColor whiteColor];
        
        UILabel *weight2 = [self labelWithTitle:weightString2];
        [weightView2 addSubview:weight2];
        weight2.font =  kWeightFont;
        [weight2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(0);
            make.left.equalTo(lineView21.right).offset(5);
        }];
        
        UIView *lineView22 = [[UIView alloc] init];
        [weightView2 addSubview:lineView22];
        [lineView22 makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(0);
            make.left.equalTo(weight1.right).offset(5);
            make.width.equalTo(1);
        }];
        lineView22.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *cubage2 = [self labelWithTitle:cubageString2];
        [weightView2 addSubview:cubage2];
        [cubage2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.equalTo(lineView12.right).offset(5);
        }];
        cubage2.font =  kWeightFont;
        
        /*--------------------------苏杰电子速2--------------------------*/
        UILabel *factoryShortName2 = [self labelWithTitle:secondDetail.FactoryShortName];
        [detailView2 addSubview:factoryShortName2];
        [factoryShortName2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weightView2.bottom).offset(7);
            make.centerX.equalTo(detailView2.centerX);
        }];
        factoryShortName2.font =  kWeightFont;
        
        /*--------------------------备注2--------------------------*/
        UILabel *followRemark2 = [self labelWithTitle:@"备注:"];
        [detailView2 addSubview:followRemark2];
        [followRemark2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(factoryShortName2.bottom).offset(5);
            make.left.equalTo(detailView2.left).offset(15);
        }];
        followRemark2.font = kLabelFont(17);
        
        UILabel *followRemarkName2 = [self labelWithTitle:secondDetail.FollowRemark];
        [detailView2 addSubview:followRemarkName2];
        [followRemarkName2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(factoryShortName2.bottom).offset(5);
            make.left.equalTo(followRemark2.right).offset(8);
        }];
        followRemarkName2.font = kLabelFont(17);
        
        /*--------------------------画虚线2--------------------------*/
        DashLineView *dashLineView2 = [[DashLineView alloc] init];
        dashLineView2.lineColor = [UIColor whiteColor];
        dashLineView2.backgroundColor = [UIColor clearColor];
        [totalView addSubview:dashLineView2];
        [dashLineView2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(followRemark2.bottom).offset(5);
            make.left.right.equalTo(totalView).offset(0);
            make.height.equalTo(1);
        }];
        
        NSArray *nodeListArray2 = secondDetail.NodeList;
        NSInteger nodeListCount2 = nodeListArray2.count;
        /*--------------------------node2--------------------------*/
        UITableView *nodeTableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH, 3 * 38) style:UITableViewStylePlain];
        [detailView2 addSubview:nodeTableView2];
        [nodeTableView2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dashLineView2.bottom).offset(1);
            make.left.right.equalTo(0);
            make.height.equalTo(nodeListCount2 * kNodeCellHeight);
        }];
        nodeTableView2.tag = 2;
        nodeTableView2.editing = NO;
        nodeTableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        nodeTableView2.rowHeight = kNodeCellHeight;
        nodeTableView2.dataSource = self;
        nodeTableView2.delegate = self;
        nodeTableView2.scrollEnabled = NO;
    }
}

- (void)setupFee {
    
    UIView *feeView = [[UIView alloc] init];
    [self.totalView addSubview:feeView];
    [feeView makeConstraints:^(MASConstraintMaker *make) {
        if (self.detailCount == 1) {
            make.top.equalTo(self.detailView1.bottom).offset(0);
        } else if (self.detailCount == 2) {
            make.top.equalTo(self.detailView2.bottom).offset(0);
        }
        make.left.equalTo(self.totalView.left).offset(0);
        make.right.equalTo(self.totalView.right).offset(0);
        make.height.equalTo(40);
    }];
    self.feeView = feeView;
    feeView.backgroundColor = kRGB(255, 255, 255);
    
    UILabel *feeLabel = [self labelWithTitle:@"运费金额:"];
    [feeView addSubview:feeLabel];
    [feeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feeView.top).offset(0);
        make.left.equalTo(feeView.left).offset(20);
        make.bottom.equalTo(feeView.bottom).offset(0);
    }];
    feeLabel.textColor = [UIColor blackColor];
    
    UILabel *feeNum = [self labelWithTitle:[NSString stringWithFormat:@"￥ %@", self.firstDetail.Fee]];
    [feeView addSubview:feeNum];
    feeNum.textColor = kRGB(244, 74, 12);
    [feeNum makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feeView.top).offset(0);
        make.left.equalTo(feeLabel.right).offset(15);
        make.bottom.equalTo(feeView.bottom).offset(0);
    }];
}

- (void)setupContact {
    UIView *contactView = [[UIView alloc] init];
    [self.totalView addSubview:contactView];
    [contactView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feeView.bottom).equalTo(10);
        make.left.equalTo(self.totalView.left).equalTo(0);
        make.right.equalTo(self.totalView.right).equalTo(0);
        make.height.equalTo(100);
    }];
    contactView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < 2; i ++) {
        CGFloat lineViewWidth = 0.50f;
        CGFloat lineViewHeight = 60.0f;
        CGFloat margin = (SCREEN_WIDTH - 2 * lineViewWidth) / 3.0 ;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(margin + (margin + lineViewWidth) * i, (100 - lineViewHeight) / 2.0, lineViewWidth, lineViewHeight)];
        [contactView addSubview:lineView];
        lineView.backgroundColor = [UIColor grayColor];
    }
    
    NSArray *optionButtonTitle = @[@"联系调度", @"拒绝出车", @"马上接单"];
    NSArray *optionButtonImage = @[@"ic_phone", @"ic_rest", @"ic_car_wantList"];
    for (int i = 0; i < 3; i++) {
        CGFloat optionButtonW = (SCREEN_WIDTH - 1) / 3;;
        CGFloat optionButtonH = 100;
        CGFloat margin = (SCREEN_WIDTH - 3 * optionButtonW) / 4.0;
        OptionButton *optionButton = [[OptionButton alloc] initWithTitle:optionButtonTitle[i] imageName:optionButtonImage[i]];
        optionButton.frame = CGRectMake(margin + (margin +  optionButtonW) * i , 0, optionButtonW, optionButtonH);
        optionButton.tag = i;
        optionButton.userInteractionEnabled = YES;
        [optionButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOptionButton:)]];
        [contactView addSubview:optionButton];
    }
}

#pragma mark - 快速创建Label
- (UILabel *)labelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor =[UIColor whiteColor];
    //    label.font = [UIFont systemFontOfSize:18];
    return label;
}

#pragma mark - 底部按钮点击事件
- (void)onTapOptionButton:(UITapGestureRecognizer *)recognizer {
    UIView *tapView = recognizer.view;
    switch (recognizer.view.tag) {
        case 0:
            [self contact:tapView];
            break;
        case 1:
            [self refuse:tapView];
            break;
        case 2:
            [self accept:tapView];
            break;
        default:
            break;
    }
}

- (void)contact:(UIView *)tapView {
    NSString *dispatcherMobile = self.firstDetail.DispatcherMobile;
    if ([dispatcherMobile isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"你拨打的号码为空"];
        return;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",dispatcherMobile];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (void)refuse:(UIView *)tapView {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [param setValue:@"RefuseOrderDispatch" forKey:@"cmd"];
    [data setValue:self.dispCode forKey:@"dispCode"];
    [param setValue:data forKey:@"data"];
    [APIClientTool RefuseOrderDispatchWithParam:param success:^(NSDictionary *dict) {
        NSLog(@"%@", dict);
        RefuseOrderDispatchResult *refuseOrderDispatchResult = [RefuseOrderDispatchResult mj_objectWithKeyValues:dict];
        if (refuseOrderDispatchResult.ret == 0) {
            //            [SVProgressHUD showSuccessWithStatus:refuseOrderDispatchResult.msg];
            [SVProgressHUD showSuccessWithStatus:@"拒绝出车成功"];
            tapView.userInteractionEnabled = NO;
            
        } else {
            //            [SVProgressHUD showErrorWithStatus:refuseOrderDispatchResult.msg]
            [SVProgressHUD showErrorWithStatus:@"拒绝出车失败"];
        }
        
    } failed:^{
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
}

- (void)accept:(UIView *)tapView {

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [param setValue:@"AcceptOrderDispatch" forKey:@"cmd"];
    [data setValue:self.dispCode forKey:@"dispCode"];
    [param setValue:data forKey:@"data"];
    [APIClientTool AcceptOrderDispatchWithParam:param success:^(NSDictionary *dict) {
        AcceptOrderDispatchResult *acceptOrderDispatchResult = [AcceptOrderDispatchResult mj_objectWithKeyValues:dict];
        if (acceptOrderDispatchResult.ret == 0) {
            //            [SVProgressHUD showSuccessWithStatus:acceptOrderDispatchResult.msg];
            [SVProgressHUD showSuccessWithStatus:@"接单成功"];
            tapView.userInteractionEnabled = NO;
            /* 接单成功 跳转到订单详情页 */
            //  去签到界面
            NSMutableArray *dispCodeArray = [NSMutableArray array];
            [dispCodeArray addObject:self.dispCode];
            NSMutableArray *phoneNumArray = [NSMutableArray array];
            [phoneNumArray addObject:self.firstDetail.DispatcherMobile];
            
            AutoSignInController *controller = [[AutoSignInController alloc] initWithDispatchOrderIDs:dispCodeArray SelectedItemIndex:0 telephoneNums:phoneNumArray readonly:YES];
            [self.navigationController pushViewController:controller animated:YES];
            
            
            
        } else {
            //            [SVProgressHUD showErrorWithStatus:acceptOrderDispatchResult.msg];
            [SVProgressHUD showErrorWithStatus:@"接单失败"];
        }
    } failed:^{
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
}

@end
