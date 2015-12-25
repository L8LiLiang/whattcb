//
//  BankAccountInfoControllerViewController.m
//  tcb
//
//  Created by Jax on 15/12/8.
//  Copyright © 2015年 Jax. All rights reserved.
//

#define kLabelWidth 80

#import "BankAccountInfoController.h"
#import "BankAccountInfoModel.h"

@interface BankAccountInfoController ()

@property (nonatomic, strong) BankAccountInfoModel *bankAccountInfoModel;

@end

@implementation BankAccountInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"银行卡详情";
    self.view.backgroundColor = kRGB(234, 234, 234);
    [self getBankAccountInfo];
}

- (void)getBankAccountInfo {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"GetBankInfo" forKey:@"cmd"];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setValue:[NSNumber numberWithInteger:self.ID] forKey:@"id"];
    [param setValue:data forKey:@"data"];
    
    [SVProgressHUD showWithStatus:@"获取账户详情中" maskType:SVProgressHUDMaskTypeBlack];
    [APIClientTool GetBankInfoWithParam:param success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"getBankAccountInfo === %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
        self.bankAccountInfoModel = [BankAccountInfoModel mj_objectWithKeyValues:dict];
        if (self.bankAccountInfoModel.ret == 0) {
            [self setupViews:self.bankAccountInfoModel];
        } else {
            [SVProgressHUD showErrorWithStatus:self.bankAccountInfoModel.msg];
        }
    } failed:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络链接是失败"];
    }];
}

- (void)setupViews:(BankAccountInfoModel *)bankAccountInfoModel {
    AccountInfoData *accountInfoData = bankAccountInfoModel.data;
    
    UIView *view0 = [[UIView alloc] init];
    [self.view addSubview:view0];
    [view0 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(64);
        make.left.right.equalTo(0);
        make.height.equalTo(25);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"输入您要添加的卡号";
    [view0 addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(0);
        make.left.equalTo(15);
    }];
    
    
    UIView *view1 = [[UIView alloc] init];
    [self.view addSubview:view1];
    [view1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view0.bottom).offset(0);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    view1.backgroundColor = kRGB(245, 245, 245);
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"持卡人";
    [view1 addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.bottom.equalTo(0);
        make.width.equalTo(kLabelWidth);
    }];
    UILabel *name = [[UILabel alloc] init];
    [view1 addSubview:name];
    [name makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(0);
        make.left.equalTo(label1.right).offset(0);
    }];
    name.text = accountInfoData.AccountName;
    
    
    UIView *view2 = [[UIView alloc] init];
    [self.view addSubview:view2];
    [view2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1.bottom).offset(10);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    view2.backgroundColor = kRGB(245, 245, 245);
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"卡 号";
    [view2 addSubview:label2];
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.bottom.equalTo(0);
        make.width.equalTo(kLabelWidth);
    }];
    UILabel *cardId = [[UILabel alloc] init];
    [view2 addSubview:cardId];
    [cardId makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(0);
        make.left.equalTo(label2.right).offset(0);
    }];
    cardId.text = accountInfoData.AccountNum;
    
    UIView *view3 = [[UIView alloc] init];
    [self.view addSubview:view3];
    [view3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view2.bottom).offset(0);
        make.left.right.equalTo(0);
        make.height.equalTo(25);
    }];
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"开户行信息";
    [view3 addSubview:label3];
    [label3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(0);
        make.left.equalTo(15);
    }];
    
    
    UIView *view4 = [[UIView alloc] init];
    [self.view addSubview:view4];
    [view4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view3.bottom).offset(0);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    view4.backgroundColor = kRGB(245, 245, 245);
    UILabel *label4 = [[UILabel alloc] init];
    label4.text = @"银 行";
    [view4 addSubview:label4];
    [label4 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.bottom.equalTo(0);
        make.width.equalTo(kLabelWidth);
    }];
    UILabel *bank = [[UILabel alloc] init];
    [view4 addSubview:bank];
    [bank makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(0);
        make.left.equalTo(label4.right).offset(0);
    }];
    bank.text = accountInfoData.BankName;
    
    
    UIView *view5 = [[UIView alloc] init];
    [self.view addSubview:view5];
    [view5 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view4.bottom).offset(10);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    view5.backgroundColor = kRGB(245, 245, 245);
    UILabel *label5 = [[UILabel alloc] init];
    label5.text = @"省/市";
    [view5 addSubview:label5];
    [label5 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.bottom.equalTo(0);
        make.width.equalTo(kLabelWidth);
    }];
    UILabel *area = [[UILabel alloc] init];
    [view5 addSubview:area];
    [area makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(0);
        make.left.equalTo(label5.right).offset(0);
    }];
    area.font = [UIFont systemFontOfSize:13];
    area.text = [NSString stringWithFormat:@"%@ %@", accountInfoData.AccountProvince, accountInfoData.AccountCity];
    
    UIView *view6 = [[UIView alloc] init];
    [self.view addSubview:view6];
    [view6 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view5.bottom).offset(10);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    view6.backgroundColor = kRGB(245, 245, 245);
    UILabel *label6 = [[UILabel alloc] init];
    label6.text = @"网点名称";
    [view6 addSubview:label6];
    [label6 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.bottom.equalTo(0);
        make.width.equalTo(kLabelWidth);
    }];
    UILabel *netName = [[UILabel alloc] init];
    [view6 addSubview:netName];
    [netName makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(label6.right).offset(0);
        make.right.equalTo(0);
    }];
    netName.text = accountInfoData.AccountAddress;
    
//    UIView *view7 = [[UIView alloc] init];
//    [self.view addSubview:view7];
//    [view7 makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(view6.bottom).offset(10);
//        make.left.right.equalTo(0);
//        make.height.equalTo(44);
//    }];
//    view7.backgroundColor = kRGB(245, 245, 245);
//    UILabel *label7 = [[UILabel alloc] init];
//    label7.text = @"预留手机";
//    [view7 addSubview:label7];
//    [label7 makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(15);
//        make.top.bottom.equalTo(0);
//        make.width.equalTo(kLabelWidth);
//    }];
//    UILabel *phoneNum = [[UILabel alloc] init];
//    [view7 addSubview:phoneNum];
//    [phoneNum makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(0);
//        make.left.equalTo(label7.right).offset(0);
//        make.right.equalTo(0);
//    }];
//    phoneNum.text = accountInfoData.pho

    
}


@end
