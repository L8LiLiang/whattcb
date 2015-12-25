//
//  FeeDetailControllerViewController.m
//  tcb
//
//  Created by Jax on 15/11/27.
//  Copyright © 2015年 Jax. All rights reserved.
//

#define kFootViewHeight 60

#import "UIImage+JAX.h"
#import "NSString+Extension.h"

#import "FeeDetailController.h"
#import "FeeDetailModel.h"
#import "AlreadyCollectionCell.h"
#import "WithoutCollectionCell.h"
#import "FeeConfirmResultModel.h"
#import "NoteABillController.h"
#import "AutoSignInController.h"


@interface FeeDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) FeeDetailModel *feeDetailModel;

@end

@implementation FeeDetailController

#pragma mark - 懒加载
- (FeeDetailModel *)feeDetailModel {
    if (_feeDetailModel == nil) {
        _feeDetailModel = [[FeeDetailModel  alloc] init];
    }
    return _feeDetailModel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title                             = @"费用明细";
    self.view.backgroundColor              = kRGB(235, 234, 234);
    if (self.sourceType != SourceTypeTask) {
        UIBarButtonItem *taskDetail            = [[UIBarButtonItem alloc] initWithTitle:@"任务详情" style:UIBarButtonItemStylePlain target:self action:@selector(taskDetailClicked:) ];
        self.navigationItem.rightBarButtonItem = taskDetail;
    }
    
    //  配置TableView
    [self configTableView];
    //  获取记账明细
    [self getAcountDetail];
}

- (void)configTableView {
    self.tableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kFootViewHeight) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource      = self;
    self.tableView.delegate        = self;
    self.tableView.backgroundColor = kRGB(235, 234, 234);
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupFootButton {
   FeeDetailData *feeDetailData = self.feeDetailModel.data;
    if (feeDetailData.feeState == 1 && (self.sourceType == SourceTypeTask || self.sourceType == SourceTypeFeeConfirmList)) {
        CGFloat margin          = 10;
        UIButton *returnButton  = [[UIButton alloc] init];
        [self.view addSubview:returnButton];
        returnButton.frame      = CGRectMake(margin, SCREEN_HEIGHT - kFootViewHeight, (SCREEN_WIDTH - 3 * margin ) * 0.5, 45);
        [returnButton setTitle:@"退返" forState:UIControlStateNormal];
        [returnButton setBackgroundImage:[UIImage resizedImage:@"btn_bg_red_norma"] forState:UIControlStateNormal];
        [returnButton addTarget:self action:@selector(returnButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        UIButton *confirmButton = [[UIButton alloc] init];
        [self.view addSubview:confirmButton];
        confirmButton.frame     = CGRectMake(margin * 2 + ((SCREEN_WIDTH - 3 * margin) * 0.5), SCREEN_HEIGHT - kFootViewHeight, (SCREEN_WIDTH - 3 * margin) * 0.5, 45);
        [confirmButton setBackgroundImage:[UIImage resizedImage:@"btn_bg_blue_normal"] forState:UIControlStateNormal];
        [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.sourceType == SourceTypeCheck) {
        UIButton *collectionButton = [[UIButton alloc] init];
        [collectionButton setTitle:@"确认收款" forState:UIControlStateNormal];
        [collectionButton setTitle:@"未收款" forState:UIControlStateDisabled];
        [self.view addSubview:collectionButton];
        [collectionButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.bottom.right.equalTo(-10);
            make.height.equalTo(40);
        }];
        collectionButton.backgroundColor = kRGB(17, 171, 254);
        collectionButton.layer.cornerRadius = 5;
        collectionButton.layer.masksToBounds = YES;
        [collectionButton addTarget:self action:@selector(collectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark -确认收款
- (void)collectionButtonClicked:(UIButton *)sender {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FeeDetailData *feeDetailData = self.feeDetailModel.data;
    NSArray *feeDetailListArray  = feeDetailData.feeList;
    return feeDetailListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeeDetailData *feeDetailData = self.feeDetailModel.data;
    NSArray *feeDetailListArray  = feeDetailData.feeList;
    FeeDetailList *feeDetailList = feeDetailListArray[indexPath.row];
    NSString *moneyString        = feeDetailList.Money;
    NSString *writeoffMoney      = feeDetailList.WriteoffMoney;
    CGFloat moneyFloat           = [NSString cgFloatMoneyFromstringMoney:moneyString];
    CGFloat writeoffMoneyFloat   = [NSString cgFloatMoneyFromstringMoney:writeoffMoney];
    
    NSInteger isReadOnly = feeDetailList.IsReadOnly;
    
    NSLog(@"%ld, %f", isReadOnly, writeoffMoneyFloat);
    
    if (moneyFloat >= writeoffMoneyFloat && writeoffMoneyFloat > 0.0f) {
        //  收款cell
        AlreadyCollectionCell *alreadyCollectionCell = [AlreadyCollectionCell cellWithTableView:tableView];
        alreadyCollectionCell.feeDetailList          = feeDetailList;
        NSInteger isReadOnly = feeDetailList.IsReadOnly;
        if (isReadOnly == 1) {
            alreadyCollectionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return alreadyCollectionCell;
    }
    if (writeoffMoneyFloat == 0) {
        //  未收款cell
        WithoutCollectionCell *withoutCollectionCell = [WithoutCollectionCell cellWithTableView:tableView];
        withoutCollectionCell.feeDetailList          = feeDetailList;
        if (isReadOnly == 1) {
            withoutCollectionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return withoutCollectionCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.sourceType == SourceTypeCheck) {
        return nil;
    }
    
    UIView *headView              = [[UIView alloc] init];
    headView.backgroundColor      = kRGB(235, 234, 234);
    UIButton *noteABill           = [[UIButton alloc] init];
    [headView addSubview:noteABill];
    [noteABill makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(5);
        make.right.equalTo(-5);
        make.bottom.equalTo(headView.bottom).offset(-10);
    }];
    noteABill.layer.borderWidth   = 1;
    noteABill.layer.masksToBounds = YES;
    noteABill.layer.cornerRadius  = 3;
    [noteABill setTitle:@"+记一笔" forState:UIControlStateNormal];
    [noteABill setTitleColor:kDefaultBarButtonItemColor forState:UIControlStateNormal];
    [noteABill setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [noteABill addTarget:self action:@selector(noteABillButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    FeeDetailData *feeDetailData = self.feeDetailModel.data;
    NSInteger feeStatus = feeDetailData.feeState;
    NSLog(@"feeStatus == %zd", feeStatus);
    if (feeStatus == 0) {
        noteABill.enabled = YES;
        noteABill.layer.borderColor   = kDefaultBarButtonItemColor.CGColor;
    } else {
        noteABill.enabled = NO;
        noteABill.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView             = [[UIView alloc] init];
    footView.backgroundColor     = kRGB(235, 234, 234);

    CGFloat feeTotal             = 0.0f;
    FeeDetailData *feeDetailData = self.feeDetailModel.data;
    NSArray *feeDetailList       = feeDetailData.feeList;
    if (feeDetailList.count != 0) {
        UILabel *totalCost = [[UILabel alloc] init];
        [footView addSubview:totalCost];
        [totalCost makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(footView.centerY);
            make.right.equalTo(-5);
        }];
        for (int i = 0; i < feeDetailList.count ; i ++) {
            NSString *moneyString = [feeDetailList[i] Money];
            feeTotal += [NSString cgFloatMoneyFromstringMoney:moneyString] ;
        }
        NSString *feeTotalString = [NSString stringWithFormat:@"总计 :  ￥%0.2f", feeTotal];
        NSRange range = [feeTotalString rangeOfString:[NSString stringWithFormat:@"￥%0.2f", feeTotal]];
        NSMutableAttributedString *feeTotalAttribute = [[NSMutableAttributedString alloc] initWithString:feeTotalString];
        [feeTotalAttribute addAttribute:NSForegroundColorAttributeName
                              value:[UIColor orangeColor]
                              range:range];
        totalCost.attributedText = feeTotalAttribute;
    }
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.sourceType == SourceTypeCheck) {
        return 0;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //  跳到记一笔界面 修改或删除费用
    FeeDetailData *feeDetailData             = self.feeDetailModel.data;
    NSArray *feeDetailListArray          = feeDetailData.feeList;
    
    FeeDetailList *feeDetailList     = feeDetailListArray[indexPath.row];
    NSInteger isReadOnly = feeDetailList.IsReadOnly;
    if (isReadOnly == 1) {
        UILabel *label = [[UILabel alloc] init];
        [self.view addSubview:label];
        label.frame = CGRectMake((SCREEN_WIDTH - 120) * 0.5, SCREEN_HEIGHT, 120, 35);
        label.text = @"费用不可编辑";
        label.layer.borderWidth = 1;
        label.layer.borderColor = [UIColor blackColor].CGColor;
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 5;
        label.textAlignment = NSTextAlignmentCenter;
        [UIView animateWithDuration:0.4 animations:^{
            label.frame = CGRectMake((SCREEN_WIDTH - 120) * 0.5, SCREEN_HEIGHT - 60, 120, 35);
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [label removeFromSuperview];
            });
        }];
        
        return ;
    }
    NSInteger feeStatus = feeDetailData.feeState;
    NoteABillController *noteABillController = [[NoteABillController alloc] init];
    noteABillController.dispCode             = self.dispCode;
    noteABillController.feeDetailList    = feeDetailList;
    noteABillController.saveFeeType          = SaveFeeTypeModifyOrDelete;
    noteABillController.canEdit = feeStatus;
    /* 获取当前费目的FeeId */
    NSArray *feeDetailTypeListArray = feeDetailData.feeTypeList;
    [feeDetailTypeListArray enumerateObjectsUsingBlock:^(FeeDetailTypeList *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([feeDetailList.FeeName isEqualToString:[obj FeeName]]) {
            noteABillController.feeTypeID = obj.FeeId;
            *stop = YES;
        }
    }];
    noteABillController.reloadFeeDetailBlock = ^() {
        [self getAcountDetail];
    };
    [self.navigationController pushViewController:noteABillController animated:YES];
}

#pragma mark - 获取记账明细
- (void)getAcountDetail {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [param setValue:@"GetAcountDetail" forKey:@"cmd"];
    [data setValue:self.dispCode forKey:@"dispCode"];
    [param setValue:data forKey:@"data"];
    [APIClientTool GetAcountDetailWithParam:param success:^(NSDictionary *dict) {
        NSLog(@"dict == %@", dict);
        FeeDetailModel *feeDetailModel = [FeeDetailModel mj_objectWithKeyValues:dict];
        self.feeDetailModel = feeDetailModel;
        
        if (feeDetailModel.ret == 0) {
            [self setupFootButton];
            [self.tableView reloadData];
            
        } else {
            [SVProgressHUD showErrorWithStatus:feeDetailModel.msg];
        }
        
    } failed:^{
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
}

#pragma mark - 记一笔
- (void)noteABillButtonClicked:(UIButton *)sender {
    FeeDetailData *feeDetailData                 = self.feeDetailModel.data;
    NSArray *feeDetailTypeListArray              = feeDetailData.feeTypeList;
    NoteABillController *noteABillController     = [[NoteABillController alloc] init];
    noteABillController.feeDetailTypeListArray   = feeDetailTypeListArray;
    NSArray *feeDetailListArray                  = feeDetailData.feeList;
    NSMutableArray *array                        = [NSMutableArray array];
    for (int i = 0; i < feeDetailListArray.count ; i ++) {
        FeeDetailList *feeDetailList                 = feeDetailListArray[i];
        [array addObject:feeDetailList.FeeName];
    }
    noteABillController.alreadyExistFeeNameArray = array;
    noteABillController.otherFeeName = feeDetailData.otherFeeName;
    noteABillController.saveFeeType              = SaveFeeTypeAdd;
    noteABillController.dispCode                 = self.dispCode;
    noteABillController.reloadFeeDetailBlock     = ^() {
        [self getAcountDetail];
    };
    [self.navigationController pushViewController:noteABillController animated:YES];
}

#pragma mark - 退却/确认
- (void)returnButtonClicked:(UIButton *)sender {
    TCBLog(@"退却");
    sender.tag = 0;
    [self feeHandle:sender];
}

- (void)confirmButtonClicked:(UIButton *)sender {
    TCBLog(@"确认");
    sender.tag = 2;
    [self feeHandle:sender];
}

- (void)feeHandle:(UIButton *)sender {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [param setValue:@"ConductAboutDispatch" forKey:@"cmd"];
    [data setValue:self.dispCode forKey:@"dispCode"];
    //  费用确认:2, 费用退返:0
    [data setValue:[NSNumber numberWithInteger:sender.tag] forKey:@"data"];

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

#pragma mark - 任务详情
- (void)taskDetailClicked:(UIBarButtonItem *)sender {
    //  去签到界面
    AutoSignInController *controller = [[AutoSignInController alloc] initWithDispatchOrderIDs:self.dispCodeArray SelectedItemIndex:0 telephoneNums:self.phoneNumberArray readonly:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
