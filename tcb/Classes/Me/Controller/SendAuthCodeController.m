//
//  SendAuthCodeController.m
//  tcb
//
//  Created by Jax on 15/12/7.
//  Copyright © 2015年 Jax. All rights reserved.
//

#define kCaptchaSecond 60

#import "SendAuthCodeController.h"
#import "BankVerityCodeModel.h"
#import "SaveBankInfoModel.h"
#import "AddCompanyCardController.h"

@interface SendAuthCodeController ()

@property (nonatomic, strong) UIButton *captchaButton;
@property (nonatomic, strong) UITextField *captchaField;

@end

@implementation SendAuthCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"校验码";
    self.view.backgroundColor = kRGB(239, 239, 239);
    
    [self setupViews];
}

- (void)setupViews {
    UIView *view0 = [[UIView alloc] init];
    [self.view addSubview:view0];
    [view0 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(64);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"输入收到的短信验证码";
    [view0 addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(0);
        make.left.equalTo(15);
    }];
    
    
    UIView *captchaView = [[UIView alloc] init];
    [self.view addSubview:captchaView];
    [captchaView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(view0.bottom).offset(0);
        make.height.equalTo(44);
    }];
    captchaView.backgroundColor = kRGB(255, 255, 255);
    
    UILabel *captchaLabel = [[UILabel alloc] init];
    [captchaView addSubview:captchaLabel];
    [captchaLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(3);
        make.top.bottom.equalTo(0);
        make.width.equalTo(90);
    }];
    captchaLabel.text = @"短信验证码";
    captchaLabel.textColor = [UIColor lightGrayColor];
    
    UIButton *captchaButton = [[UIButton alloc] init];
    [captchaView addSubview:captchaButton];
    [captchaButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.right.equalTo(0);
        make.width.equalTo(120);
    }];
    [captchaButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [captchaButton setTitleColor:kDefaultBarButtonItemColor forState:UIControlStateNormal];
    captchaButton.titleEdgeInsets = UIEdgeInsetsMake(2, 5, 2, 5);
    [captchaButton addTarget:self action:@selector(sendCaptchaButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.captchaButton = captchaButton;
    UIView *lineView = [[UIView alloc] init];
    [captchaView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(12);
        make.bottom.equalTo(-12);
        make.right.equalTo(captchaButton.left).offset(3);
        make.width.equalTo(0.8);
    }];
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    UITextField *captchaTextField = [[UITextField alloc] init];
    [captchaView addSubview:captchaTextField];
    [captchaTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.right.equalTo(lineView.left).offset(3);
        make.left.equalTo(captchaLabel.right).offset(3);
    }];
    self.captchaField = captchaTextField;
    captchaTextField.keyboardType = UIKeyboardTypeNumberPad;

    UIButton *nextButton = [[UIButton alloc] init];
    [self.view addSubview:nextButton];
    [nextButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(8);
        make.right.equalTo(-8);
        make.top.equalTo(captchaView.bottom).offset(5);
        make.height.equalTo(48);
    }];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:kDefaultBarButtonItemColor forState:UIControlStateNormal];
    nextButton.backgroundColor = kRGB(167, 167, 167);
    nextButton.layer.cornerRadius = 4;
    [nextButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)sendCaptchaButtonClicked:(UIButton *)sender {

        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:@"SendBankVerifyCode" forKey:@"cmd"];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        [data setValue:@"15701182581" forKey:@"mobile"];
        [param setValue:data forKey:@"data"];
        
        [SVProgressHUD showWithStatus:@"验证码发送中" maskType:SVProgressHUDMaskTypeBlack];
        [APIClientTool SendCaptchaWithParam:param success:^(NSDictionary *dict) {
            
            BankVerityCodeModel *bankVerityCodeModel = [BankVerityCodeModel mj_objectWithKeyValues:dict];
            if (bankVerityCodeModel.ret == 0) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
                //  在这里要控制发送验证码按钮
                //  启动倒计时
                self.captchaButton.enabled = NO;
                [self performSelector:@selector(reflashGetKeyBt:) withObject:[NSNumber numberWithInt:kCaptchaSecond] afterDelay:0];
                
            } else if (bankVerityCodeModel.ret == 1) {
                [SVProgressHUD dismiss];
                TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:bankVerityCodeModel.msg leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
                [tcbAlertView show];
            }
        } failed:^{
            
        }];

}

#pragma mark - 倒数计时
//倒数
- (void)reflashGetKeyBt:(NSNumber *)second
{
    if ([second integerValue] == 0) {
        [self.captchaButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        self.captchaButton.enabled = YES;
    }
    else {
        int i = [second intValue];
        [self.captchaButton setTitle:[NSString stringWithFormat:@"%i秒后重发",i] forState:UIControlStateNormal];
        [self performSelector:@selector(reflashGetKeyBt:) withObject:[NSNumber numberWithInt:i -1] afterDelay:1];
    }
    
}

#pragma mark - 下一步
- (void)nextButtonClicked:(UIButton *)sender {
    if (self.captchaField.text.length == 0) {
        TCBAlertView *tcbAlertView = [[TCBAlertView alloc] initWithTitle:@"拖车宝" contentText:@"亲,你还没有输入验证码" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [tcbAlertView show];
        return ;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"SaveBankAccount" forKey:@"cmd"];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setValue:self.accountName forKey:@"accountName"];
    [data setValue:self.accountNum forKey:@"accountNum"];
    [data setValue:self.bankCode forKey:@"bankCode"];
    [data setValue:self.accountType forKey:@"accountType"];
    [data setValue:self.accountAddress forKey:@"accountAddress"];
    [data setValue:self.accountProvince forKey:@"accountProvince"];
    [data setValue:self.accountCity forKey:@"accountCity"];
    [data setValue:self.phoneNo forKey:@"phoneNo"];
    [data setValue:self.captchaField.text forKey:@"verificationCode"];
    [param setValue:data forKey:@"data"];
    NSLog(@"%@", param);
    [SVProgressHUD showWithStatus:@"银行卡信息保存中" maskType:SVProgressHUDMaskTypeBlack];
    [APIClientTool SaveBankAccountWithParam:param success:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        SaveBankInfoModel *saveBankInfoModel = [SaveBankInfoModel mj_objectWithKeyValues:dict];
        if (saveBankInfoModel.ret == 0) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            NSNotification *noti = [NSNotification notificationWithName:@"RefreshBankLsit" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:noti];
            AddCompanyCardController *addCompanyCardController =  (AddCompanyCardController *)self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3];
            [self.navigationController popToViewController:addCompanyCardController animated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:saveBankInfoModel.msg];
        }
    } failed:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
    
}

@end
