//
//  AddCompanyCardController.m
//  tcb
//
//  Created by Jax on 15/12/7.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "AddCompanyCardController.h"
#import "SaveBankAccountController.h"
#import "BankAccountList.h"
#import "BankAccountListCell.h"
#import "BankAccountInfoController.h"
#import "DeleteBankInfoModel.h"

@interface AddCompanyCardController () /*<UITableViewDelegate, UITableViewDataSource, BankAccountListCellDelegate>*/

@property (nonatomic, strong) BankAccountList *bankAccountList;

@property (nonatomic, strong) UIView *listView;


@end

@implementation AddCompanyCardController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的银行卡";
    self.view.backgroundColor = [UIColor whiteColor];
    [self getMyBankAccountList];

    
    /* 注册通知，收到通知刷新银行列表 */
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(getMyBankAccountList) name:@"RefreshBankLsit" object:nil];
}

- (void)getMyBankAccountList {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"GetBankAccountList" forKey:@"cmd"];
    
    [SVProgressHUD showWithStatus:@"获取银行账户列表中" maskType:SVProgressHUDMaskTypeBlack];
    [APIClientTool GetBankAccountListWithParam:param success:^(NSDictionary *dict) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
                NSLog(@"JSONString === %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
        [SVProgressHUD dismiss];
        BankAccountList *bankAccountList = [BankAccountList mj_objectWithKeyValues:dict];
        if (bankAccountList.ret == 0) {
            self.bankAccountList = bankAccountList;
            [self setUpListView:bankAccountList];
        } else {
            [SVProgressHUD showErrorWithStatus:@"你还没有银行账号"];
            [self setUpAddButton];
        }
    } failed:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络接连失败"];
        
    }];
}

//- (void)setUpBankListUI {
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
//    self.edgesForExtendedLayout    = UIRectEdgeNone;
//    [self.view addSubview:self.tableView];
//
//     self.tableView.tableFooterView = [[UIView alloc] init];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.tableView reloadData];
//}

- (void)setUpListView:(BankAccountList *)bankAccountList {
    BankList *banklist = bankAccountList.data[0];
    
    UIView *listView = [[UIView alloc] init];
    [self.view addSubview:listView];
    [listView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(64);
        make.left.right.equalTo(0);
        make.height.equalTo(60);
    }];
    self.listView = listView;
    listView.backgroundColor = kRGB(234, 234, 234);
    [listView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToBankInfoController:)]];
    
    UILabel *name = [[UILabel alloc] init];
    [listView addSubview:name];
    [name makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(0);
        make.width.equalTo(SCREEN_WIDTH);
        make.height.equalTo(30);
    }];
    name.text =  banklist.AccountName;
    
    UILabel *card = [[UILabel alloc] init];
    [listView addSubview:card];
    [card makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.bottom.equalTo(0);
        make.width.equalTo(SCREEN_WIDTH);
        make.height.equalTo(30);
    }];
    card.text = banklist.AccountNum;
    
    UIButton *deleteButton = [[UIButton alloc] init];
    [listView addSubview:deleteButton];
    [deleteButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.right.bottom.equalTo(-10);
        make.width.equalTo(80);
    }];
    deleteButton.layer.borderWidth = 1;
    deleteButton.layer.borderColor = kDefaultBarButtonItemColor.CGColor;
    deleteButton.layer.masksToBounds = YES;
    deleteButton.layer.cornerRadius = 4;
    deleteButton.tag = banklist.Id;
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:kDefaultBarButtonItemColor forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setUpAddButton {
    UIButton *addCardButton = [[UIButton alloc] init];
    [self.view addSubview:addCardButton];
    [addCardButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(74);
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.height.equalTo(45);
    }];
    [addCardButton setTitle:@"+银行卡" forState:UIControlStateNormal];
    [addCardButton setTitleColor:kDefaultBarButtonItemColor forState:UIControlStateNormal];
    [addCardButton addTarget:self action:@selector(addCardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    addCardButton.layer.borderColor = kDefaultBarButtonItemColor.CGColor;
    addCardButton.layer.borderWidth = 1;
    addCardButton.layer.masksToBounds = YES;
    addCardButton.layer.cornerRadius = 4;


}

- (void)addCardButtonClicked:(UIButton *)sender {
    SaveBankAccountController *saveBankAccountController = [[SaveBankAccountController alloc] init];
    [self.navigationController pushViewController:saveBankAccountController animated:YES];
    
}

- (void)tapToBankInfoController:(UITapGestureRecognizer *)tap {
    BankAccountInfoController *bankAccountInfoController = [[BankAccountInfoController alloc] init];
    BankList *bankList =  self.bankAccountList.data[0];
    bankAccountInfoController.ID = bankList.Id;
    [self.navigationController pushViewController:bankAccountInfoController animated:YES];
}

//#pragma mark - table data delegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.bankAccountList.data.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    BankAccountListCell *bankAccountListCell = [BankAccountListCell cellWithTable:tableView ];
//    bankAccountListCell.tag = indexPath.row;
//    bankAccountListCell.bankList = self.bankAccountList.data[indexPath.row];
//    bankAccountListCell.delegate = self;
//    return bankAccountListCell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 60;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//   /* 进入银行卡详情 */
//    BankAccountInfoController *bankAccountInfoController = [[BankAccountInfoController alloc] init];
//    BankList *bankList =  self.bankAccountList.data[indexPath.row];
//    bankAccountInfoController.ID = bankList.Id;
//    [self.navigationController pushViewController:bankAccountInfoController animated:YES];
//}
//
//#pragma mark - BankAccountListCellDelegate 
//- (void)deleteButtonClickedOnBankAccountListCell:(IdButton *)sender {
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setValue:@"DeleteBankInfo" forKey:@"cmd"];
//    NSMutableDictionary *data = [NSMutableDictionary dictionary];
//    [data setValue:[NSNumber numberWithInteger:sender.Id] forKey:@"id"];
//    [param setValue:data forKey:@"data"];
//    
//    [SVProgressHUD showWithStatus:@"删除中" maskType:SVProgressHUDMaskTypeBlack];
//    [APIClientTool DeleteBankInfoWithParam:param success:^(NSDictionary *dict) {
//        [SVProgressHUD dismiss];
//        DeleteBankInfoModel *deleteBankInfoModel = [DeleteBankInfoModel mj_objectWithKeyValues:dict];
//        if (deleteBankInfoModel.ret == 0) {
//            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
//            self.tableView.frame = CGRectZero;
//            self.tableView.hidden = YES;
//            [self.tableView removeFromSuperview];
////            self.tableView = nil;
//            [self setUpAddButton];
//        } else {
//            [SVProgressHUD showErrorWithStatus:deleteBankInfoModel.msg];
//        }
//    } failed:^{
//       [SVProgressHUD dismiss];
//        [SVProgressHUD showErrorWithStatus:@"删除失败"];
//    }];
//}

- (void)deleteButtonClicked:(UIButton *)sender {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"DeleteBankInfo" forKey:@"cmd"];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setValue:[NSNumber numberWithInteger:sender.tag] forKey:@"id"];
    [param setValue:data forKey:@"data"];
    
    [SVProgressHUD showWithStatus:@"删除中" maskType:SVProgressHUDMaskTypeBlack];
    [APIClientTool DeleteBankInfoWithParam:param success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        DeleteBankInfoModel *deleteBankInfoModel = [DeleteBankInfoModel mj_objectWithKeyValues:dict];
        if (deleteBankInfoModel.ret == 0) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [self.listView removeFromSuperview];
            self.listView = nil;
            [self setUpAddButton];
        } else {
            [SVProgressHUD showErrorWithStatus:deleteBankInfoModel.msg];
        }
    } failed:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"删除失败"];
    }];

}

@end
